# 16x9cropZoomTo16x10
A PowerShell script to zoom locked 16:9 games to fit onto a 16:10 display.
It uses Windows Magnifier to achieve the effect, and then launches whatever game this script is modified to launch.
The mouse cursor is temporarily locked to the center of the display to ensure a perfectly-centered zoom.

## Instructions
  - Save the script somewhere.
  - Right-click your desktop (or any place really) > New > Shortcut.
  - Input the following when asked for the location. Mind the script path at the end as well.
```
%systemroot%\system32\windowspowershell\v1.0\powershell.exe -ExecutionPolicy RemoteSigned -File "C:\16x9cropZoomTo16x10.ps1"
```
  - Right-click the newly created shortcut > Properties > Advanced > check **"Run As Administrator"** (needed to temporarily lock the mouse to the center)

You should edit the script so that it launches your game instead. Read the provided comments in the script file for instructions.
