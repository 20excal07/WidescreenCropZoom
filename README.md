# WidescreenCropZoom
A PowerShell script to crop-zoom games that are locked to a wider aspect ratio than your current display.
It uses Windows Magnifier to achieve the effect, and then launches whatever game this script is modified to launch.
The mouse cursor is temporarily locked to the center of the display to ensure a perfectly-centered zoom.
The script only works if the game's aspect ratio is wider than your display's (usually 16:9).

## Instructions
  - Save the script somewhere.
  - Right-click your desktop (or any place really) > New > Shortcut.
  - Input the following when asked for the location. Mind the script path at the end as well.
```
%systemroot%\system32\windowspowershell\v1.0\powershell.exe -windowstyle hidden -noexit -ExecutionPolicy RemoteSigned -File "C:\WidescreenCropZoom.ps1"
```
  - Right-click the newly created shortcut > Properties > Advanced > check **"Run As Administrator"** (needed to temporarily lock the mouse to the center and configure the Magnifier through its registry)

You should edit the script so that it launches your game instead. Read the provided comments in the script file for additional instructions.
