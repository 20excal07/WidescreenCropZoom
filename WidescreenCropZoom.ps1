Add-Type -AssemblyName System.Windows.Forms
$AspectRatio_GameX=16    # Specify the game's locked aspect ratio here... (width)
$AspectRatio_GameY=9     # ... and here (height)
# you can also just specify the resolution you're using, and the math below will do the rest

$bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds

$AspectRatio_X=$bounds.Width
$AspectRatio_Y=$bounds.Height

$DisplayRatio=$AspectRatio_X/$AspectRatio_Y
$GameRatio=$AspectRatio_GameX/$AspectRatio_GameY

$factor=$AspectRatio_GameX/$AspectRatio_X

$zoom = [math]::Round((($AspectRatio_Y*$factor)/$AspectRatio_GameY) * 100)

$code = @"
    [DllImport("user32.dll")]
    public static extern bool BlockInput(bool fBlockIt);
"@

if(!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){
    [System.Windows.Forms.MessageBox]::Show(
        "This script needs administrator privileges to work!`r`n`r`nPlease make sure to run this script as administrator.",
        "Woops!",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Exclamation
    )
    exit
}

if($zoom -le 100){
    [System.Windows.Forms.MessageBox]::Show(
        "It doesn't look like the game's aspect ratio is any wider than your screen's.

Your current display resolution is: $AspectRatio_X x $AspectRatio_Y
which has a ratio of $DisplayRatio : 1

You defined the game as having a locked $AspectRatio_GameX : $AspectRatio_GameY aspect ratio
which is equal to $GameRatio : 1

There is no need to zoom and you may launch your game directly instead. This program will now close.",
        "Sorry!",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
    exit
}

$userInput = Add-Type -MemberDefinition $code -Name UserInput -Namespace UserInput -PassThru

$userInput::BlockInput($true)

[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | out-null
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | out-null
$center = $bounds.Location
$center.X += $bounds.Width / 2
$center.Y += $bounds.Height / 2
[System.Windows.Forms.Cursor]::Position = $center

$registryPath = "HKCU:\SOFTWARE\Microsoft\ScreenMagnifier\"
Set-ItemProperty -path $registryPath -name "UseBitmapSmoothing" -Value 0           # "Smooth edges of images and text [off]"
Set-ItemProperty -path $registryPath -name "Invert" -Value 0                       # "Invert colours [off]"
Set-ItemProperty -path $registryPath -name "MagnificationMode" -Value 2            # "Change Magnifier view: [Full Screen]"

                                                                                   # "Enable Magnifier to follow..."
Set-ItemProperty -path $registryPath -name "FollowMouse" -Value 0                  # - Mouse pointer   [off]
Set-ItemProperty -path $registryPath -name "FollowFocus" -Value 0                  # - Keyboard focus  [off]
Set-ItemProperty -path $registryPath -name "FollowCaret" -Value 0                  # - Text cursor     [off]
Set-ItemProperty -path $registryPath -name "FollowNarrator" -Value 0               # - Narrator cursor [off]

Set-ItemProperty -path $registryPath -name "FullScreenTrackingMode" -Value 0       # "Keep the mouse pointer: [Within the edges of the screen]"
Set-ItemProperty -path $registryPath -name "CenterTextInsertionPoint" -Value 0     # "Keep the text cursor:   [Within the edges of the screen]"

Set-ItemProperty -path $registryPath -name "MagnifierUIWindowMinimized" -Value 1   # Start minimized
Set-ItemProperty -path $registryPath -name "Magnification" -Value $zoom            # Magnification level @ 111%
Set-ItemProperty -path $registryPath -name "ZoomIncrement" -Value 1                # Allow 1% zoom increments
Set-ItemProperty -path $registryPath -name "DisableAudio" -Value 1                 # Disable narrator audio, just in case

start-process magnify
Start-Sleep -s 1

$userInput::BlockInput($false)

<#
    Uncomment one of the lines below this comment block and change the ID to the game of your choosing.
    You can visit { https://steamdb.info } to find the ID for your game.
    Alternatively, provide a full path to your game's executable instead of "explorer steam://" if it's non-Steam.
#>
#start-process explorer steam://rungameid/738540
#start-process C:\Path\To\Executable.exe -Wait
#start-process C:\Path\To\Executable.exe -Wait -ArgumentList "--arg1 --arg2 --etc"

<# DELETE EVERYTHING BETWEEN THIS #>
[System.Windows.Forms.MessageBox]::Show(
    "If you are seeing this message, the script works as intended!`r`n`r`nYou can now go ahead and edit this script to make it launch a Steam game of your choosing. Read the comments for instructions.",
    "It works!",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
)
<# DELETE EVERYTHING BETWEEN THIS #>

# Delete this part if you're using "steam://", or Magnifier will close immediately after launching
Stop-Process -Name "magnify"
