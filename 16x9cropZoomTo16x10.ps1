$code = @"
    [DllImport("user32.dll")]
    public static extern bool BlockInput(bool fBlockIt);
"@

$userInput = Add-Type -MemberDefinition $code -Name UserInput -Namespace UserInput -PassThru

$userInput::BlockInput($true)

[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | out-null
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | out-null
$bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
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
Set-ItemProperty -path $registryPath -name "Magnification" -Value 111              # Magnification level @ 111%
Set-ItemProperty -path $registryPath -name "ZoomIncrement" -Value 5                # Allow 1% zoom increments
Set-ItemProperty -path $registryPath -name "DisableAudio" -Value 1                 # Disable narrator audio, just in case

start-process magnify
Start-Sleep -s 1

<# YOU CAN DELETE EVERYTHING FROM HERE... #>
$ButtonType = [System.Windows.Forms.MessageBoxButtons]::OK
$MessageIcon = [System.Windows.Forms.MessageBoxIcon]::Information
$MessageTitle = "It works!"
$MessageBody = "If you are seeing this message, the script works as intended!`r`n`r`nYou can now go ahead and edit this script to make it launch a Steam game of your choosing. Read the comments for instructions."
<# ...UNTIL HERE #>

<#
    Uncomment the line below this comment block and change the ID to the game of your choosing.
    You can visit { https://steamdb.info } to find the ID for your game.
    Alternatively, provide a full path to your game's executable instead of "explorer steam://" if it's non-Steam.
#>
#start-process explorer steam://rungameid/738540

$userInput::BlockInput($false)

<# DELETE EVERYTHING BELOW #>
$Result = [System.Windows.Forms.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
Stop-Process -Name "magnify"