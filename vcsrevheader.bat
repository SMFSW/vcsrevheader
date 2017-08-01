:: name: vcsrevheader.bat
:: author: SMFSW
:: copyright: MIT (c) 2017 SMFSW

:: SCRIPT PARAMETERS
:: %1 = VCS local copy path
:: %2 = VCS local copy include path
:: %3 = project name

:: In eclipse project, set a new builder
:: Location: "${workspace_loc:/${project_name}/vcsrevheader.bat}"
:: Working dir: ${workspace_loc:/${project_name}}
:: Arguments: "${workspace_loc:/${project_name}}" "${workspace_loc:/${project_name}/Inc}" ${project_name}
:: Refresh the project containing the selected resource
:: Run the builder after a clean, during manual and auto builds

:: Known Compatibility Issues:
:: - May cause issues if msys toolset is found in windows path (when launched using cmd as described below)

:: Known Issues:
:: - Only for local copies, if trying to launch the script from a full repository (including different projects), it won't work


:: TODO:
:: - Add some defaults (missing) when launched without parameters


@ECHO off
TITLE VCS revision to header (SMFSW)
COLOR 0a
ECHO Running "%~0"

SETLOCAL
ECHO.

::::::::::::::::::::::
:: START ENV & INIT ::
::::::::::::::::::::::
:START
:: Set root path and display it for reference ::
CD "%~1"
ECHO Starting folder: %~1

:: SET LOCAL GLOBAL VARIBLES ::
:: VCS application with path var
SET VCS=
:: Displayed app name var
SET name=
:: Executable name var
SET exe=
:: Output VCS revision var
SET vcsrev=

:: Delete previously generated file
DEL "%~2\VCSREV_%~3.h"
IF %errorlevel% neq 0 (
	ECHO No Previous VCSVER_%3.h found, generating header...
) ELSE (
	ECHO Deleting VCSVER_%3.h, generating new header...
)

:: Go to the beginning of main script
GOTO :BEGIN


:::::::::::::::::
:: SUBROUTINES ::
:::::::::::::::::
:: Search for VCS app in path (subbroutine)
:SEEK_VCS
FOR %%e IN (%PATHEXT%) DO (
	FOR %%X IN (%exe%%%e) DO (
		IF NOT DEFINED VCS (
			SET VCS=%%~$PATH:X
		)
	)
)
rem :TEST_VCS
EXIT /B

:: Test if VCS var is defined
:TEST_VCS
IF NOT DEFINED VCS ( GOTO :ERROR_APP )
EXIT /B


:::::::::::::::::::::
:: ERRORS HANDLING ::
:::::::::::::::::::::
:: Called when no VCS folder has been found in local copy
:ERROR_LOCAL
ECHO ---------------------------
ECHO %~1% is not a VCS local copy
ECHO Exiting
ECHO ---------------------------
GOTO :END

:: Called when VCS app has not been found in windows path
:ERROR_APP
ECHO ---------------------------
ECHO PLEASE INSTALL %name% (or maybe add it to your path environment variable)
ECHO Exiting
ECHO ---------------------------
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
	SET exe=svnversion
	ECHO Subversion found in local copy...
) ELSE IF EXIST ".git" (
	:: Test for GIT
	SET name=git
	SET exe=git
	ECHO GIT found in local copy...
) ELSE IF EXIST ".hg" (
	:: Test for MERCURIAL
	SET name=hg
	SET exe=hg
	ECHO Mercurial found in local copy...
) ELSE GOTO :ERROR_LOCAL


CALL :SEEK_VCS
:: TODO: may be done in SEEK_VCS directly
IF "%name%"=="svn" (
	IF %errorlevel% neq 0 ( SET exe=svn && CALL :SEEK_VCS )
	IF %errorlevel% neq 0 ( GOTO :ERROR_APP )
) ELSE IF %errorlevel% neq 0 ( GOTO :ERROR_APP )


:: Retrieve informations from local copy
IF "%name%"=="svn" (
	IF %exe%=="svn" (
		"%VCS%" info -r BASE > vcsrev.tmp
		findstr ".*Rev:.*" vcsrev.tmp > revision.tmp
		IF %errorlevel% neq 0 ( ECHO Did not found revision from SVN infos! )
	) ELSE ( svnversion > revision.tmp )
	SET /p vcsrev= < revision.tmp
) ELSE IF "%name%"=="git" (
	ECHO needs to be implemented for GIT
	GOTO :END
) ELSE IF "%name%"=="hg" (
	:: Get infos from MERCURIAL
	"%VCS%" -R "%~1" identify -n -i -t > vcsrev.tmp
	SET /p vcsrev= < vcsrev.tmp
)

:: Remove temporary files
DEL *.tmp


:: Write to header and display informations
ECHO ---------------------------
ECHO #define VCSREV_%~3 "%~3 %name%: %vcsrev%" > "%~2\VCSREV_%~3.h"
ECHO %~3: %name% %vcsrev%
ECHO ---------------------------


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
