# vcsrevheader

Version Control Sytem rev to header file

## SCRIPT PARAMETERS

- %1 = VCS local copy path
- %2 = VCS local copy include path
- %3 = project name

In eclipse project, set a new builder

- Location: "${workspace_loc:/${project_name}/vcsrevheader.bat}"
- Working dir: ${workspace_loc:/${project_name}}
- Arguments: "${workspace_loc:/${project_name}}" "${workspace_loc:/${project_name}/Inc}" ${project_name}
- Refresh the project containing the selected resource
- Run the builder after a clean, during manual and auto builds

## Known Compatibility Issues

- May cause issues if msys toolset is found in windows path (when launched using cmd as described below)

## Known Issues

- Only for local copies, if trying to launch the script from a full repository (including different projects), it won't work


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