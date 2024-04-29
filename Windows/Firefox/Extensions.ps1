Add-Type -AssemblyName System.Windows.Forms
$CurrentFireFoxProfilePath0 = Get-ChildItem -Directory -Path "$env:APPDATA\Mozilla\Firefox\Profiles" -Filter '*.default-release'
$CurrentFireFoxProfilePath = "$env:APPDATA\Mozilla\Firefox\Profiles\$CurrentFireFoxProfilePath0"
if ((Test-Path -LiteralPath $CurrentFireFoxProfilePath) -eq $true) {
    Write-Host 'Firefox Extensions Setup' -ForegroundColor green -BackgroundColor black
    Write-Host 'Scale 100%' -ForegroundColor green -BackgroundColor black
    explorer ms-settings:display
    Start-Sleep 3
    Start-Sleep 1
    [System.Windows.Forms.SendKeys]::SendWait('{TAB 2}{UP 5}')
    Start-Sleep 1
    [System.Windows.Forms.SendKeys]::SendWait('%{F4}')
    Write-Host 'Set-Window Function' -ForegroundColor green -BackgroundColor black
    Function Set-Window {
        <#
    .SYNOPSIS
    Retrieve/Set the window size and coordinates of a process window.
     
    .DESCRIPTION
    Retrieve/Set the size (height,width) and coordinates (x,y)
    of a process window.
     
    .PARAMETER ProcessName
     
    .PARAMETER Id
     
    .PARAMETER X
     
    .PARAMETER Y
     
    .PARAMETER Width
     
    .PARAMETER Height
      
    .PARAMETER Passthru
     
    .NOTES
    Name: Set-Window
    Author: Boe Prox
    Version History:
        1.0//Boe Prox - 11/24/2015 - Initial build
        1.1//JosefZ - 19.05.2018 - Treats more process instances
                                     of supplied process name properly
        1.2//JosefZ - 21.02.2019 - Parameter Id
    Link: https://superuser.com/questions/1324007/setting-window-size-and-position-in-powershell-5-and-6
 
    .OUTPUTS
    None
    System.Management.Automation.PSCustomObject
    System.Object
     
    .EXAMPLE
    Get-Process powershell | Set-Window -X 20 -Y 40 -Passthru -Verbose
    VERBOSE: powershell (Id=11140, Handle=132410)
     
    Id : 11140
    ProcessName : powershell
    Size : 1134,781
    TopLeft : 20,40
    BottomRight : 1154,821
     
    Description: Set the coordinates on the window for the process PowerShell.exe
     
    .EXAMPLE
    $windowArray = Set-Window -Passthru
    WARNING: cmd (1096) is minimized! Coordinates will not be accurate.
     
        PS C:\>$windowArray | Format-Table -AutoSize
     
      Id ProcessName Size TopLeft BottomRight
      -- ----------- ---- ------- -----------
    1096 cmd 199,34 -32000,-32000 -31801,-31966
    4088 explorer 1280,50 0,974 1280,1024
    6880 powershell 1280,974 0,0 1280,974
     
    Description: Get the coordinates of all visible windows and save them into the $windowArray variable. Then, display them in a table view.
     
    .EXAMPLE
    Set-Window -Id $PID -Passthru | Format-Table
    ​‌‍
      Id ProcessName Size TopLeft BottomRight
      -- ----------- ---- ------- -----------
    7840 pwsh 1024,638 0,0 1024,638
     
    Description: Display the coordinates of the window for the current
                 PowerShell session in a table view.
    #>
        [CmdletBinding(PositionalBinding = $True, DefaultParameterSetName = 'Name')]

        Param (

            [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True, ParameterSetName = 'Name', HelpMessage = 'Name of the process to determine the window characteristics. (All processes if omitted).')]
            [String]$ProcessName = '*',

            [Parameter(Mandatory = $True, ValueFromPipeline = $False, ParameterSetName = 'Id', HelpMessage = 'Id of the process to determine the window characteristics. ')]
            [Int]$Id,

            [Parameter(HelpMessage = 'Set the position of the window in pixels from the left.')]
            [Int]$X,

            [Parameter(HelpMessage = 'Set the position of the window in pixels from the top.')]
            [Int]$Y,

            [Parameter(HelpMessage = 'Set the width of the window.')]
            [Int]$Width,

            [Parameter(HelpMessage = 'Set the height of the window.')]
            [Int]$Height,

            [Parameter(HelpMessage = 'Returns the output object of the window.')]
            [Switch]$Passthru
        )
    
        Begin {
            Try { 
                [Void][Window]
            }
            Catch {
                Add-Type @'
    using System;
    using System.Runtime.InteropServices;
    public class Window {
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool GetWindowRect(
        IntPtr hWnd, out RECT lpRect);
 
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public extern static bool MoveWindow(
        IntPtr handle, int x, int y, int width, int height, bool redraw);
 
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool ShowWindow(
        IntPtr handle, int state);
    }
    public struct RECT
    {
    public int Left; // x position of upper-left corner
    public int Top; // y position of upper-left corner
    public int Right; // x position of lower-right corner
    public int Bottom; // y position of lower-right corner
    }
'@
            }
        }

        Process {

            $Rectangle = New-Object RECT

            If ( $PSBoundParameters.ContainsKey('Id') ) {
                $Processes = Get-Process -Id $Id -ErrorAction SilentlyContinue
            }
            Else {
                $Processes = Get-Process -Name "$ProcessName" -ErrorAction SilentlyContinue
            }

            If ( $null -eq $Processes ) {
                If ( $PSBoundParameters['Passthru'] ) {
                    Write-Warning 'No process match criteria specified'
                }
            }
            Else {
                $Processes | ForEach-Object {
                    $Handle = $_.MainWindowHandle
                    Write-Verbose "$($_.ProcessName) `(Id=$($_.Id), Handle=$Handle`)"
                    If ( $Handle -eq [System.IntPtr]::Zero ) { Return }
                    $Return = [Window]::GetWindowRect($Handle, [ref]$Rectangle)
                    If (-NOT $PSBoundParameters.ContainsKey('X')) {
                        $X = $Rectangle.Left            
                    }
                    If (-NOT $PSBoundParameters.ContainsKey('Y')) {
                        $Y = $Rectangle.Top
                    }
                    If (-NOT $PSBoundParameters.ContainsKey('Width')) {
                        $Width = $Rectangle.Right - $Rectangle.Left
                    }
                    If (-NOT $PSBoundParameters.ContainsKey('Height')) {
                        $Height = $Rectangle.Bottom - $Rectangle.Top
                    }
                    If ( $Return ) {
                        $Return = [Window]::MoveWindow($Handle, $x, $y, $Width, $Height, $True)
                    }
                    If ( $PSBoundParameters['Passthru'] ) {
                        $Rectangle = New-Object RECT
                        $Return = [Window]::GetWindowRect($Handle, [ref]$Rectangle)
                        If ( $Return ) {
                            $Height = $Rectangle.Bottom - $Rectangle.Top
                            $Width = $Rectangle.Right - $Rectangle.Left
                            $Size = New-Object System.Management.Automation.Host.Size -ArgumentList $Width, $Height
                            $TopLeft = New-Object System.Management.Automation.Host.Coordinates -ArgumentList $Rectangle.Left , $Rectangle.Top
                            $BottomRight = New-Object System.Management.Automation.Host.Coordinates -ArgumentList $Rectangle.Right, $Rectangle.Bottom
                            If ($Rectangle.Top -lt 0 -AND 
                                $Rectangle.Bottom -lt 0 -AND
                                $Rectangle.Left -lt 0 -AND
                                $Rectangle.Right -lt 0) {
                                Write-Warning "$($_.ProcessName) `($($_.Id)`) is minimized! Coordinates will not be accurate."
                            }
                            $Object = [PSCustomObject]@{
                                Id          = $_.Id
                                ProcessName = $_.ProcessName
                                Size        = $Size
                                TopLeft     = $TopLeft
                                BottomRight = $BottomRight
                            }
                            $Object
                        }
                    }
                }
            }
        }
    }
    Write-Host '[Clicker] Function' -ForegroundColor green -BackgroundColor black
    $cSource = @'
using System;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;

public class Clicker
{
    // https://learn.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-input
    [StructLayout(LayoutKind.Sequential)]
    struct INPUT
    { 
        public int        type; // 0 = INPUT_MOUSE
                                // 1 = INPUT_KEYBOARD
                                // 2 = INPUT_HARDWARE
        public MOUSEINPUT mi;
    }

    // https://learn.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-mouseinput
    [StructLayout(LayoutKind.Sequential)]
    struct MOUSEINPUT
    {
        public int    dx;
        public int    dy;
        public int    mouseData;
        public int    dwFlags;
        public int    time;
        public IntPtr dwExtraInfo;
    }

    // This covers most use cases although complex mice may have additional buttons.
    // There are additional constants you can use for those cases, see the MSDN page.
    const int MOUSEEVENTF_MOVE       = 0x0001;
    const int MOUSEEVENTF_LEFTDOWN   = 0x0002;
    const int MOUSEEVENTF_LEFTUP     = 0x0004;
    const int MOUSEEVENTF_RIGHTDOWN  = 0x0008;
    const int MOUSEEVENTF_RIGHTUP    = 0x0010;
    const int MOUSEEVENTF_MIDDLEDOWN = 0x0020;
    const int MOUSEEVENTF_MIDDLEUP   = 0x0040;
    const int MOUSEEVENTF_WHEEL      = 0x0080;
    const int MOUSEEVENTF_XDOWN      = 0x0100;
    const int MOUSEEVENTF_XUP        = 0x0200;
    const int MOUSEEVENTF_ABSOLUTE   = 0x8000;

    const int screen_length = 0x10000;

    // https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-sendinput
    [System.Runtime.InteropServices.DllImport("user32.dll")]
    extern static uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);

    public static void LeftClickAtPoint(int x, int y)
    {
        // Move the mouse
        INPUT[] input = new INPUT[3];

        input[0].mi.dx = x * (65535 / System.Windows.Forms.Screen.PrimaryScreen.Bounds.Width);
        input[0].mi.dy = y * (65535 / System.Windows.Forms.Screen.PrimaryScreen.Bounds.Height);
        input[0].mi.dwFlags = MOUSEEVENTF_MOVE | MOUSEEVENTF_ABSOLUTE;

        // Left mouse button down
        input[1].mi.dwFlags = MOUSEEVENTF_LEFTDOWN;

        // Left mouse button up
        input[2].mi.dwFlags = MOUSEEVENTF_LEFTUP;

        SendInput(3, input, Marshal.SizeOf(input[0]));
    }
}
'@

    Add-Type -TypeDefinition $cSource -ReferencedAssemblies System.Windows.Forms, System.Drawing
    $OpenWithFirefox = New-Object System.Diagnostics.Process
    $OpenWithFirefox.StartInfo.Filename = 'firefox.exe'
    Invoke-WebRequest -Uri https://addons.mozilla.org/firefox/downloads/file/4261710/ublock_origin-1.57.2.xpi -OutFile $env:TEMP\ublock_origin.xpi
    $DesktopFolder = [Environment]::GetFolderPath('Desktop')
    Write-Host 'uBlock Origin' -ForegroundColor green -BackgroundColor black
    Invoke-WebRequest -Uri https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/uBlock_Origin/Backup.txt -OutFile $DesktopFolder\uBlock_Origin_Backup.txt
    $OpenWithFirefox.StartInfo.Arguments = "$env:TEMP\ublock_origin.xpi"
    $OpenWithFirefox.start()
    Start-Sleep 2
    Get-Process firefox | Set-Window -x 0 -y 0 -Width 500 -Height 400
    Start-Sleep 2
    Write-Host 'uBlock Origin > Add (If not previously installed)' -ForegroundColor green -BackgroundColor black
    [Clicker]::LeftClickAtPoint(300, 240)
    Write-Host 'uBlock Origin > Add (If previously installed)' -ForegroundColor green -BackgroundColor black
    [Clicker]::LeftClickAtPoint(350, 240)
    Start-Sleep 5
    Write-Host 'uBlock Origin > Icon' -ForegroundColor green -BackgroundColor black
    [Clicker]::LeftClickAtPoint(430, 60)
    Start-Sleep 5
    Write-Host 'uBlock Origin > Open the dashboard' -ForegroundColor green -BackgroundColor black
    [System.Windows.Forms.SendKeys]::SendWait('+{TAB}')
    Start-Sleep 1
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    Start-Sleep 3
    Write-Host 'uBlock Origin > Settings.html' -ForegroundColor green -BackgroundColor black
    [System.Windows.Forms.SendKeys]::SendWait('{F6}') 
    Start-Sleep 1
    [System.Windows.Forms.SendKeys]::SendWait('^{c}')
    Start-Sleep 1
    $ublockhtml = 'dashboard.html.*'
    (Get-Clipboard) -replace $ublockhtml, 'dashboard.html#settings.html' | Set-Clipboard
    Start-Sleep 1
    [System.Windows.Forms.SendKeys]::SendWait('^{v}')
    Start-Sleep 1
    [System.Windows.Forms.SendKeys]::SendWait('^{ENTER}')
    Start-Sleep 1
    Write-Host 'uBlock Origin > Restore from file' -ForegroundColor green -BackgroundColor black
    [System.Windows.Forms.SendKeys]::SendWait('+{TAB 2}')
    Start-Sleep 1
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    Start-Sleep 1
    Write-Host 'uBlock Origin > Restore from file > Select folder' -ForegroundColor green -BackgroundColor black
    [System.Windows.Forms.SendKeys]::SendWait('{F4}')
    Start-Sleep 1
    [System.Windows.Forms.SendKeys]::SendWait('^a')
    Start-Sleep 1
    Write-Host "uBlock Origin > Restore from file > Select folder > $DesktopFolder" -ForegroundColor green -BackgroundColor black
    [System.Windows.Forms.SendKeys]::SendWait($DesktopFolder)
    Start-Sleep 1
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    Start-Sleep 1
    [System.Windows.Forms.SendKeys]::SendWait('%n')
    Start-Sleep 1
    Write-Host "uBlock Origin > Restore from file > $DesktopFolder > uBlock_Origin_Backup.txt" -ForegroundColor green -BackgroundColor black
    [System.Windows.Forms.SendKeys]::SendWait('uBlock_Origin_Backup.txt')
    Start-Sleep 1
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    Start-Sleep 1
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    Start-Sleep 1
    [System.Windows.Forms.SendKeys]::SendWait('^w')
    Start-Sleep 1
    if ((Test-Path -LiteralPath "$DesktopFolder\uBlock_Origin_Backup.txt") -eq $true) {
        Remove-Item -Path ("$DesktopFolder\uBlock_Origin_Backup.txt") -Force -Recurse
    }
    Write-Host 'ClearURLs' -ForegroundColor green -BackgroundColor black
    Invoke-WebRequest -Uri https://addons.mozilla.org/firefox/downloads/file/4064884/clearurls-1.26.1.xpi -OutFile $env:TEMP\clearurls.xpi
    $OpenWithFirefox.StartInfo.Arguments = "$env:TEMP\clearurls.xpi"
    $OpenWithFirefox.start()
    Start-Sleep 5
    Get-Process firefox | Set-Window -x 0 -y 0 -Width 500 -Height 400
    Start-Sleep 1
    Write-Host 'ClearURLs > Add' -ForegroundColor green -BackgroundColor black
    [Clicker]::LeftClickAtPoint(305, 263)
    Start-Sleep 2
    Write-Host 'Im not robot captcha clicker' -ForegroundColor green -BackgroundColor black
    Invoke-WebRequest -Uri https://addons.mozilla.org/firefox/downloads/file/3897119/i_m_not_robot_captcha_clicker-1.3.1.xpi -OutFile $env:TEMP\i_m_not_robot_captcha_clicker.xpi
    $OpenWithFirefox.StartInfo.Arguments = "$env:TEMP\i_m_not_robot_captcha_clicker.xpi"
    [System.Windows.Forms.SendKeys]::SendWait('^w')
    Start-Sleep 1
    $OpenWithFirefox.start()
    Start-Sleep 5
    Get-Process firefox | Set-Window -x 0 -y 0 -Width 500 -Height 400
    Start-Sleep 1
    Write-Host 'Im not robot captcha clicker > Add' -ForegroundColor green -BackgroundColor black
    [Clicker]::LeftClickAtPoint(306, 215)
    Start-Sleep 2
    Write-Host 'Buster' -ForegroundColor green -BackgroundColor black
    $OpenWithFirefox.StartInfo.Arguments = "$env:TEMP\buster_captcha_solver.xpi"
    Invoke-WebRequest -Uri https://addons.mozilla.org/firefox/downloads/file/4044701/buster_captcha_solver-2.0.1.xpi -OutFile $env:TEMP\buster_captcha_solver.xpi
    [System.Windows.Forms.SendKeys]::SendWait('^w')
    Start-Sleep 1
    $OpenWithFirefox.start()
    Start-Sleep 5
    Get-Process firefox | Set-Window -x 0 -y 0 -Width 500 -Height 400
    Start-Sleep 1
    Write-Host 'Buster > Add' -ForegroundColor green -BackgroundColor black
    [Clicker]::LeftClickAtPoint(310, 263)
    Start-Sleep 2
    Write-Host 'Camelizer' -ForegroundColor green -BackgroundColor black
    Invoke-WebRequest -Uri https://addons.mozilla.org/firefox/downloads/file/4075638/the_camelizer_price_history_ch-3.0.15.xpi -OutFile $env:TEMP\the_camelizer_price_history_ch.xpi
    $OpenWithFirefox.StartInfo.Arguments = "$env:TEMP\the_camelizer_price_history_ch.xpi"
    [System.Windows.Forms.SendKeys]::SendWait('^w')
    Start-Sleep 1
    $OpenWithFirefox.start()
    Start-Sleep 5
    Get-Process firefox | Set-Window -x 0 -y 0 -Width 500 -Height 400
    Start-Sleep 1
    Write-Host 'Camelizer > Add' -ForegroundColor green -BackgroundColor black
    [Clicker]::LeftClickAtPoint(310, 294)
    Start-Sleep 2
    Write-Host 'Tampermonkey' -ForegroundColor green -BackgroundColor black
    Invoke-WebRequest -Uri https://addons.mozilla.org/firefox/downloads/file/4250678/tampermonkey-5.1.0.xpi -OutFile $env:TEMP\tampermonkey.xpi
    $OpenWithFirefox.StartInfo.Arguments = "$env:TEMP\tampermonkey.xpi"
    [System.Windows.Forms.SendKeys]::SendWait('^w 2')
    Start-Sleep 1
    $OpenWithFirefox.start()
    Start-Sleep 5
    Get-Process firefox | Set-Window -x 0 -y 0 -Width 500 -Height 400
    Start-Sleep 1
    Write-Host 'Tampermonkey > Add' -ForegroundColor green -BackgroundColor black
    [Clicker]::LeftClickAtPoint(310, 297)
    Start-Sleep 15
    Write-Host 'AdsBypasser' -ForegroundColor green -BackgroundColor black
    $OpenWithFirefox.StartInfo.Arguments = 'https://adsbypasser.github.io/releases/adsbypasser.full.es7.user.js'
    [System.Windows.Forms.SendKeys]::SendWait('^w 2')
    $OpenWithFirefox.start()
    Start-Sleep 15
    Get-Process firefox | Set-Window -x 0 -y 0 -Width 500 -Height 400
    Start-Sleep 1
    Write-Host 'Tampermonkey > AdsBypasser > Install' -ForegroundColor green -BackgroundColor black
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
}