# vcsrevheader

Version Control Sytem rev to header file

## SCRIPT PARAMETERS

- %1 = VCS local copy path
- %2 = VCS local copy include path
- %3 = project name

In eclipse project, you can set a new builder (from an external tool for re-use)

- Location: "${workspace_loc:/${project_name}/vcsrevheader.bat}"
- Working dir: ${workspace_loc:/${project_name}}
- Arguments: "${workspace_loc:/${project_name}}" "${workspace_loc:/${project_name}/Inc}" ${project_name}
- Refresh the project containing the selected resource
- Run the builder after a clean, during manual and auto builds

## Known Compatibility Issues

- May cause issues if msys toolset is found in windows path (when launched using cmd as described below)

## Known Issues

- Only for local copies, if trying to launch the script from a full repository (including different projects), it won't work

- Not implemented for GIT yet

## Release Notes

v1.2:

- Ensure find & findstr commands are windows ones

v1.1:

- Refactored script:
  - not using different app name than set (-1 var)
  - using common variable for output header
  - subroutine for separator
  - Console displayed blank lines
  - %3 param shall never have space in name (never using %~3)
  - delete/generate output header after getting infos (lets the possibility to keep the latest file in place in some cases: eg. no connection with repo)
- svnversion is not used anymore, yet more informations gather
- variables for other VCS app generated accordingly
- Displaying all defines from generated header before exit

V1.0:

- initial release using svnversion (for subversion if executable found)

## Misc

Feel free to share your thoughts @ xgarmanboziax@gmail.com about:

- issues encountered (might also raise issue on github directly)
- optimisations
- improvements & new functionalities

## License

The MIT License (MIT)

Copyright (c) 2017 SMFSW (Sebastien Bizien)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.