:: name: vcsrevheader.bat
:: version: 1.2
:: author: SMFSW
:: copyright: MIT (c) 2017 SMFSW

:: SCRIPT PARAMETERS
:: %1 = VCS local copy path
:: %2 = VCS local copy include path
:: %3 = project name

:: Known Compatibility Issues:
:: - May cause issues if msys toolset is found in windows path (when launched using cmd as described below)

:: Known Issues:
:: - Only for local copies, if trying to launch the script from a full repository (including different projects), it won't work


:: TODO:
:: - Add some defaults (missing) when launched without parameters


@ECHO off
TITLE VCS revision to header (SMFSW)
COLOR 0a
ECHO Running: "%~0"

SETLOCAL

::::::::::::::::::::::
:: START ENV & INIT ::
::::::::::::::::::::::
:START
:: Set root path and display it for reference ::
CD "%~1"
ECHO Starting folder: %~1
ECHO.

:: SET LOCAL GLOBAL VARIBLES ::
:: VCS application with path var
SET VCS=
:: Displayed app name var
SET name=
:: Output VCS revision var
SET outheader="%~2\vcsrev_%3.h"
SET vcsrev=
SET updrev=

:: Go to the beginning of main script
GOTO :BEGIN


:::::::::::::::::
:: SUBROUTINES ::
:::::::::::::::::
:: Search for VCS app in path (subbroutine)
:SEEK_VCS
FOR %%e IN (%PATHEXT%) DO (
	FOR %%X IN (%name%%%e) DO (
		IF NOT DEFINED VCS (
			SET VCS=%%~$PATH:X
		)
	)
)
GOTO :TEST_VCS
EXIT /B

:: Test if VCS var is defined
:TEST_VCS
IF NOT DEFINED VCS ( GOTO :ERROR_APP )
EXIT /B

:: Display separator
:SEP
ECHO --------------------------------------------------------------------------
EXIT /B


:::::::::::::::::::::
:: ERRORS HANDLING ::
:::::::::::::::::::::
:: Called when no VCS folder has been found in local copy
:ERROR_LOCAL
CALL :SEP
ECHO %~1% is not a VCS local copy
ECHO Exiting
CALL :SEP
GOTO :END

:: Called when VCS app has not been found in windows path
:ERROR_APP
CALL :SEP
ECHO PLEASE INSTALL %name% (or maybe add it to your path environment variable)
ECHO Exiting
CALL :SEP
GOTO :END


:::::::::::::::::
:: MAIN SCRIPT ::
:::::::::::::::::
:BEGIN

:: Test for VCS folder in project
:TEST_DIR
IF EXIST ".svn" (
	:: Test for SUBVERSION
	SET name=svn
	ECHO Subversion found in local copy...
) ELSE IF EXIST ".git" (
	:: Test for GIT
	SET name=git
	ECHO GIT found in local copy...
) ELSE IF EXIST ".hg" (
	:: Test for MERCURIAL
	SET name=hg
	ECHO Mercurial found in local copy...
) ELSE GOTO :ERROR_LOCAL
ECHO.

CALL :SEEK_VCS

:: Retrieve informations from local copy
IF "%name%"=="svn" (
	"%VCS%" info -r BASE> vcsrev.tmp
	FOR /f "tokens=2 delims==:" %%a IN ('%windir%\system32\find "Last Changed Rev:" ^< vcsrev.tmp') DO SET vcsrev=%%a
	FOR /f "tokens=2 delims==:" %%a IN ('%windir%\system32\find "Revision:" ^< vcsrev.tmp') DO SET updrev=%%a
	rem svnversion> revision.tmp
	rem SET /p vcsrev=< revision.tmp
) ELSE IF "%name%"=="git" (
	ECHO needs to be implemented for GIT
	GOTO :END
) ELSE IF "%name%"=="hg" (
	:: Get infos from MERCURIAL
	"%VCS%" -R "%~1" identify -n -i -t> vcsrev.tmp
	SET /p vcsrev=< vcsrev.tmp
	SET updrev=%vcsrev%
)

:: Remove temporary files
DEL *.tmp

:: Delete previously generated file
DEL "%outheader%"
IF %errorlevel% neq 0 (
	ECHO No Previous vcsrev_%3.h found, generating header...
) ELSE (
	ECHO Deleting vcsrev_%3.h, generating new header...
)

:: Write to header file
ECHO // This is an automated generated file for project %3, please do not edit> %outheader%
ECHO // Generated: %date% @%time%>> %outheader%
ECHO.>> %outheader%
ECHO #define VCSREV_%3 "%3: %name% proj%vcsrev% / repo%updrev%">> %outheader%

:: Display informations
CALL :SEP
%windir%\system32\findstr "#define.*" %outheader%
CALL :SEP


::::::::::::::::::::::::
:: RESTORE CTX & EXIT ::
::::::::::::::::::::::::
:END
ENDLOCAL
GOTO :EOF

:::::::::::::::::
:: End of file ::
:::::::::::::::::
:EOF
