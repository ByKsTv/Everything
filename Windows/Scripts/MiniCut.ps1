Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Xaml
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName WindowsFormsIntegration

$MpvCommand = Get-Command mpv.exe -ErrorAction SilentlyContinue
$FfmpegCommand = Get-Command ffmpeg.exe -ErrorAction SilentlyContinue

if ($null -eq $MpvCommand) {
    [System.Windows.MessageBox]::Show('mpv.exe was not found in PATH.', 'MiniCut')
    return
}

if ($null -eq $FfmpegCommand) {
    [System.Windows.MessageBox]::Show('ffmpeg.exe was not found in PATH.', 'MiniCut')
    return
}

$OpenDialog = New-Object System.Windows.Forms.OpenFileDialog
$OpenDialog.Title = 'Choose a video'
$OpenDialog.Filter = 'All files|*.*|MP4|*.mp4|MPEG-TS|*.ts|Matroska|*.mkv|QuickTime|*.mov|AVI|*.avi|WebM|*.webm'

if ($OpenDialog.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) {
    return
}

$script:InputPath = $OpenDialog.FileName
$script:OutputPath = $null
$script:Duration = 0.0
$script:Position = 0.0
$script:InPoint = 0.0
$script:OutPoint = 0.0
$script:Seeking = $false
$script:SetOutOnDuration = $true
$script:PipeName = "MiniCut_$PID"
$script:Pipe = $null
$script:PipeReader = $null
$script:PipeWriter = $null
$script:ReadTask = $null
$script:Mpv = $null
$script:ExportJob = $null

[xml]$Xaml = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="MiniCut"
    Width="1050"
    Height="780"
    MinWidth="850"
    MinHeight="650"
    WindowStartupLocation="CenterScreen"
    Background="#101010"
    Foreground="WhiteSmoke"
    FontFamily="Segoe UI">
    <Window.Resources>
        <Style TargetType="Button">
            <Setter Property="Background" Value="#263238"/>
            <Setter Property="Foreground" Value="WhiteSmoke"/>
            <Setter Property="BorderBrush" Value="#455A64"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="14,8"/>
            <Setter Property="Margin" Value="4"/>
            <Setter Property="Cursor" Value="Hand"/>
        </Style>

        <Style TargetType="TextBox">
            <Setter Property="Background" Value="#292929"/>
            <Setter Property="Foreground" Value="WhiteSmoke"/>
            <Setter Property="BorderBrush" Value="#455A64"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="8"/>
        </Style>

        <Style TargetType="CheckBox">
            <Setter Property="Foreground" Value="WhiteSmoke"/>
        </Style>

        <Style TargetType="Thumb">
            <Setter Property="Cursor" Value="SizeWE"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Thumb">
                        <Border
                            Background="{TemplateBinding Background}"
                            CornerRadius="3"
                            BorderBrush="#DDFFFFFF"
                            BorderThickness="1">
                            <TextBlock
                                Text="{TemplateBinding Tag}"
                                Foreground="Black"
                                FontWeight="Bold"
                                FontSize="9"
                                HorizontalAlignment="Center"
                                VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>

    <Grid Margin="18">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <Grid Grid.Row="0" Margin="0,0,0,12">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>

            <TextBox
                x:Name="SourceBox"
                IsReadOnly="True"
                VerticalContentAlignment="Center"/>

            <Button
                x:Name="OpenButton"
                Grid.Column="1"
                Content="Open Video"/>
        </Grid>

        <Border
            Grid.Row="1"
            Background="Black"
            BorderBrush="#455A64"
            BorderThickness="1"
            CornerRadius="7">
            <Grid x:Name="VideoContainer"/>
        </Border>

        <Grid Grid.Row="2" Margin="0,12,0,0">
            <Grid.RowDefinitions>
                <RowDefinition Height="48"/>
                <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>

            <Grid x:Name="TimelineGrid">
                <Slider
                    x:Name="Seek"
                    Minimum="0"
                    Maximum="1"
                    VerticalAlignment="Center"
                    IsMoveToPointEnabled="True"
                    Margin="7,0"/>

                <Canvas
                    x:Name="TimelineOverlay"
                    Background="{x:Null}"
                    Margin="7,0">

                    <Rectangle
                        x:Name="SelectionBar"
                        Height="10"
                        Fill="#88FFC107"
                        RadiusX="4"
                        RadiusY="4"
                        Canvas.Top="19"
                        IsHitTestVisible="False"/>

                    <Thumb
                        x:Name="InThumb"
                        Tag="IN"
                        Width="18"
                        Height="44"
                        Background="#FFC107"
                        Canvas.Top="2"
                        Canvas.Left="-9"/>

                    <Thumb
                        x:Name="OutThumb"
                        Tag="OUT"
                        Width="24"
                        Height="44"
                        Background="#FF7043"
                        Canvas.Top="2"
                        Canvas.Left="-12"/>
                </Canvas>
            </Grid>

            <Grid Grid.Row="1">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>

                <TextBlock
                    x:Name="InMarkerText"
                    Foreground="#FFC107"
                    Text="IN 00:00:00.000"
                    HorizontalAlignment="Left"/>

                <TextBlock
                    x:Name="TimeText"
                    Grid.Column="1"
                    Text="00:00:00.000 / 00:00:00.000"
                    HorizontalAlignment="Center"/>

                <TextBlock
                    x:Name="OutMarkerText"
                    Grid.Column="2"
                    Foreground="#FF7043"
                    Text="OUT 00:00:00.000"
                    HorizontalAlignment="Right"/>
            </Grid>
        </Grid>

        <Grid Grid.Row="3" Margin="0,8,0,0">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="140"/>
                <ColumnDefinition Width="50"/>
            </Grid.ColumnDefinitions>

            <Button
                x:Name="BackButton"
                Content="-5 s"/>

            <Button
                x:Name="BackFrameButton"
                Grid.Column="1"
                Content="◀ Frame"/>

            <Button
                x:Name="PlayButton"
                Grid.Column="2"
                Content="Play"
                MinWidth="85"/>

            <Button
                x:Name="NextFrameButton"
                Grid.Column="3"
                Content="Frame ▶"/>

            <Button
                x:Name="ForwardButton"
                Grid.Column="4"
                Content="+5 s"/>

            <Button
                x:Name="MuteButton"
                Grid.Column="5"
                Content="Mute"/>

            <TextBlock
                Grid.Column="6"
                Text="Volume"
                HorizontalAlignment="Right"
                VerticalAlignment="Center"
                Margin="10,0"/>

            <Slider
                x:Name="Volume"
                Grid.Column="7"
                Minimum="0"
                Maximum="100"
                Value="70"
                VerticalAlignment="Center"/>

            <TextBlock
                x:Name="VolumeText"
                Grid.Column="8"
                Text="70%"
                VerticalAlignment="Center"
                TextAlignment="Right"/>
        </Grid>

        <Grid Grid.Row="4" Margin="0,12,0,0">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="190"/>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="190"/>
                <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>

            <TextBlock
                Text="From"
                Foreground="#FFC107"
                VerticalAlignment="Center"
                Margin="4"/>

            <TextBox
                x:Name="InBox"
                Grid.Column="1"
                Text="00:00:00.000"
                VerticalContentAlignment="Center"/>

            <Button
                x:Name="InButton"
                Grid.Column="2"
                Content="Set In"/>

            <TextBlock
                Grid.Column="3"
                Text="To"
                Foreground="#FF7043"
                VerticalAlignment="Center"
                Margin="18,4,4,4"/>

            <TextBox
                x:Name="OutBox"
                Grid.Column="4"
                Text="00:00:00.000"
                VerticalContentAlignment="Center"/>

            <Button
                x:Name="OutButton"
                Grid.Column="5"
                Content="Set Out"/>
        </Grid>

        <Grid Grid.Row="5" Margin="0,12,0,0">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>

            <TextBox
                x:Name="OutputBox"
                IsReadOnly="True"
                VerticalContentAlignment="Center"/>

            <Button
                x:Name="SaveButton"
                Grid.Column="1"
                Content="Save As"/>
        </Grid>

        <Grid Grid.Row="6" Margin="0,12,0,0">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>

            <CheckBox
                x:Name="AccurateBox"
                Content="Accurate cut (re-encode)"
                VerticalAlignment="Center"
                Margin="5"/>

            <TextBlock
                x:Name="StatusText"
                Grid.Column="1"
                Text="Starting mpv"
                VerticalAlignment="Center"
                HorizontalAlignment="Center"/>

            <Button
                x:Name="ExportButton"
                Grid.Column="2"
                Content="Export"
                Padding="30,10"/>
        </Grid>
    </Grid>
</Window>
'@

$XmlReader = New-Object System.Xml.XmlNodeReader $Xaml
$Window = [System.Windows.Markup.XamlReader]::Load($XmlReader)

$VideoContainer = $Window.FindName('VideoContainer')
$SourceBox = $Window.FindName('SourceBox')
$OpenButton = $Window.FindName('OpenButton')
$Seek = $Window.FindName('Seek')
$TimelineOverlay = $Window.FindName('TimelineOverlay')
$SelectionBar = $Window.FindName('SelectionBar')
$InThumb = $Window.FindName('InThumb')
$OutThumb = $Window.FindName('OutThumb')
$InMarkerText = $Window.FindName('InMarkerText')
$OutMarkerText = $Window.FindName('OutMarkerText')
$TimeText = $Window.FindName('TimeText')
$BackButton = $Window.FindName('BackButton')
$BackFrameButton = $Window.FindName('BackFrameButton')
$PlayButton = $Window.FindName('PlayButton')
$NextFrameButton = $Window.FindName('NextFrameButton')
$ForwardButton = $Window.FindName('ForwardButton')
$MuteButton = $Window.FindName('MuteButton')
$Volume = $Window.FindName('Volume')
$VolumeText = $Window.FindName('VolumeText')
$InBox = $Window.FindName('InBox')
$OutBox = $Window.FindName('OutBox')
$InButton = $Window.FindName('InButton')
$OutButton = $Window.FindName('OutButton')
$OutputBox = $Window.FindName('OutputBox')
$SaveButton = $Window.FindName('SaveButton')
$AccurateBox = $Window.FindName('AccurateBox')
$StatusText = $Window.FindName('StatusText')
$ExportButton = $Window.FindName('ExportButton')

$VideoHost = New-Object System.Windows.Forms.Integration.WindowsFormsHost
$Panel = New-Object System.Windows.Forms.Panel
$Panel.Dock = [System.Windows.Forms.DockStyle]::Fill
$Panel.BackColor = [System.Drawing.Color]::Black
$VideoHost.Child = $Panel
$null = $VideoContainer.Children.Add($VideoHost)
$SourceBox.Text = $script:InputPath

$Timer = New-Object System.Windows.Threading.DispatcherTimer
$Timer.Interval = [TimeSpan]::FromMilliseconds(40)

$ExportTimer = New-Object System.Windows.Threading.DispatcherTimer
$ExportTimer.Interval = [TimeSpan]::FromMilliseconds(300)

$Window.Add_Loaded({
        $Handle = $Panel.Handle.ToInt64()

        $StartInfo = New-Object System.Diagnostics.ProcessStartInfo
        $StartInfo.FileName = $MpvCommand.Source
        $StartInfo.Arguments = '--no-config --idle=yes --force-window=yes --keep-open=yes --pause=yes --terminal=no --osc=no --input-default-bindings=no --hwdec=auto --volume=70 --wid=' + $Handle + ' --input-ipc-server="\\.\pipe\' + $script:PipeName + '"'
        $StartInfo.UseShellExecute = $false
        $StartInfo.CreateNoWindow = $true

        $script:Mpv = New-Object System.Diagnostics.Process
        $script:Mpv.StartInfo = $StartInfo

        try {
            $null = $script:Mpv.Start()

            $script:Pipe = New-Object System.IO.Pipes.NamedPipeClientStream('.', $script:PipeName, [System.IO.Pipes.PipeDirection]::InOut, [System.IO.Pipes.PipeOptions]::Asynchronous)
            $script:Pipe.Connect(5000)

            $Encoding = New-Object System.Text.UTF8Encoding($false)
            $script:PipeReader = New-Object System.IO.StreamReader($script:Pipe, $Encoding)
            $script:PipeWriter = New-Object System.IO.StreamWriter($script:Pipe, $Encoding)
            $script:PipeWriter.AutoFlush = $true

            $script:PipeWriter.WriteLine('{"command":["observe_property",1,"duration"]}')
            $script:PipeWriter.WriteLine('{"command":["observe_property",2,"pause"]}')
            $script:PipeWriter.WriteLine('{"command":["observe_property",3,"mute"]}')
            $script:PipeWriter.WriteLine('{"command":["observe_property",4,"time-pos"]}')

            $script:ReadTask = $script:PipeReader.ReadLineAsync()

            $JsonPath = ConvertTo-Json -InputObject $script:InputPath -Compress
            $script:PipeWriter.WriteLine('{"command":["loadfile",' + $JsonPath + ',"replace"]}')
            $script:PipeWriter.WriteLine('{"command":["set_property","pause",true]}')

            $Timer.Start()
        } catch {
            if ($null -ne $script:Mpv) {
                if ($script:Mpv.HasExited -eq $false) {
                    $script:Mpv.Kill()
                }
            }

            [System.Windows.MessageBox]::Show('MiniCut could not start or connect to mpv.', 'MiniCut')
            $Window.Close()
        }
    })

$Timer.Add_Tick({
        $ReadCount = 0

        while ($null -ne $script:ReadTask -and $script:ReadTask.IsCompleted -and $ReadCount -lt 200) {
            try {
                $Line = $script:ReadTask.GetAwaiter().GetResult()
            } catch {
                $Line = $null
            }

            if ($null -eq $Line) {
                $script:ReadTask = $null
                $StatusText.Text = 'mpv disconnected'
                break
            }

            try {
                $Message = ConvertFrom-Json -InputObject $Line -ErrorAction Stop
            } catch {
                $Message = $null
            }

            if ($null -ne $Message) {
                if ($Message.event -eq 'start-file') {
                    $StatusText.Text = 'Loading'
                }

                if ($Message.event -eq 'file-loaded') {
                    $StatusText.Text = 'Ready'
                }

                if ($Message.event -eq 'end-file' -and $Message.reason -eq 'error') {
                    $StatusText.Text = 'mpv could not decode this file'
                }

                if ($Message.event -eq 'property-change') {
                    if ($Message.name -eq 'duration' -and $null -ne $Message.data) {
                        $script:Duration = [double]$Message.data
                        $Seek.Maximum = [Math]::Max(1.0, $script:Duration)

                        if ($script:SetOutOnDuration -eq $true) {
                            $script:InPoint = 0.0
                            $script:OutPoint = $script:Duration
                            $InBox.Text = '00:00:00.000'
                            $OutBox.Text = [TimeSpan]::FromSeconds($script:OutPoint).ToString('hh\:mm\:ss\.fff')
                            $InMarkerText.Text = 'IN ' + $InBox.Text
                            $OutMarkerText.Text = 'OUT ' + $OutBox.Text
                            $script:SetOutOnDuration = $false
                        }

                        $Width = $TimelineOverlay.ActualWidth

                        if ($Width -gt 0) {
                            $InX = ($script:InPoint / $script:Duration) * $Width
                            $OutX = ($script:OutPoint / $script:Duration) * $Width

                            [System.Windows.Controls.Canvas]::SetLeft($InThumb, $InX - 9)
                            [System.Windows.Controls.Canvas]::SetLeft($OutThumb, $OutX - 12)
                            [System.Windows.Controls.Canvas]::SetLeft($SelectionBar, $InX)

                            $SelectionBar.Width = [Math]::Max(0, $OutX - $InX)
                        }
                    }

                    if ($Message.name -eq 'time-pos' -and $null -ne $Message.data) {
                        $script:Position = [double]$Message.data

                        if ($script:Seeking -eq $false) {
                            $Seek.Value = [Math]::Min($Seek.Maximum, [Math]::Max(0.0, $script:Position))
                        }

                        $CurrentText = [TimeSpan]::FromSeconds([Math]::Max(0.0, $script:Position)).ToString('hh\:mm\:ss\.fff')
                        $DurationText = [TimeSpan]::FromSeconds([Math]::Max(0.0, $script:Duration)).ToString('hh\:mm\:ss\.fff')

                        $TimeText.Text = "$CurrentText / $DurationText"
                    }

                    if ($Message.name -eq 'pause' -and $null -ne $Message.data) {
                        if ([bool]$Message.data -eq $true) {
                            $PlayButton.Content = 'Play'
                        } else {
                            $PlayButton.Content = 'Pause'
                        }
                    }

                    if ($Message.name -eq 'mute' -and $null -ne $Message.data) {
                        if ([bool]$Message.data -eq $true) {
                            $MuteButton.Content = 'Unmute'
                        } else {
                            $MuteButton.Content = 'Mute'
                        }
                    }
                }
            }

            if ($script:Pipe.IsConnected -eq $true) {
                $script:ReadTask = $script:PipeReader.ReadLineAsync()
            } else {
                $script:ReadTask = $null
            }

            $ReadCount++
        }
    })

$TimelineOverlay.Add_SizeChanged({
        if ($script:Duration -gt 0) {
            $Width = $TimelineOverlay.ActualWidth

            if ($Width -gt 0) {
                $InX = ($script:InPoint / $script:Duration) * $Width
                $OutX = ($script:OutPoint / $script:Duration) * $Width

                [System.Windows.Controls.Canvas]::SetLeft($InThumb, $InX - 9)
                [System.Windows.Controls.Canvas]::SetLeft($OutThumb, $OutX - 12)
                [System.Windows.Controls.Canvas]::SetLeft($SelectionBar, $InX)

                $SelectionBar.Width = [Math]::Max(0, $OutX - $InX)
            }
        }
    })

$Seek.Add_PreviewMouseLeftButtonDown({
        $script:Seeking = $true
    })

$Seek.Add_PreviewMouseLeftButtonUp({
        $script:Seeking = $false

        if ($null -ne $script:PipeWriter) {
            $SeekValue = ([double]$Seek.Value).ToString([System.Globalization.CultureInfo]::InvariantCulture)
            $script:PipeWriter.WriteLine('{"command":["seek",' + $SeekValue + ',"absolute+exact"]}')
        }
    })

$InThumb.Add_DragDelta({
        if ($script:Duration -gt 0) {
            $Width = $TimelineOverlay.ActualWidth

            if ($Width -gt 0) {
                $CurrentLeft = [System.Windows.Controls.Canvas]::GetLeft($InThumb)

                if ([double]::IsNaN($CurrentLeft)) {
                    $CurrentLeft = -9
                }

                $Center = $CurrentLeft + 9 + $_.HorizontalChange
                $OutX = ($script:OutPoint / $script:Duration) * $Width

                $Center = [Math]::Max(0, $Center)
                $Center = [Math]::Min($OutX, $Center)

                $script:InPoint = ($Center / $Width) * $script:Duration

                [System.Windows.Controls.Canvas]::SetLeft($InThumb, $Center - 9)
                [System.Windows.Controls.Canvas]::SetLeft($SelectionBar, $Center)

                $SelectionBar.Width = [Math]::Max(0, $OutX - $Center)

                $InBox.Text = [TimeSpan]::FromSeconds($script:InPoint).ToString('hh\:mm\:ss\.fff')
                $InMarkerText.Text = 'IN ' + $InBox.Text
                $Seek.Value = $script:InPoint
            }
        }
    })

$InThumb.Add_DragCompleted({
        if ($null -ne $script:PipeWriter) {
            $Value = $script:InPoint.ToString([System.Globalization.CultureInfo]::InvariantCulture)
            $script:PipeWriter.WriteLine('{"command":["set_property","pause",true]}')
            $script:PipeWriter.WriteLine('{"command":["seek",' + $Value + ',"absolute+exact"]}')
        }
    })

$OutThumb.Add_DragDelta({
        if ($script:Duration -gt 0) {
            $Width = $TimelineOverlay.ActualWidth

            if ($Width -gt 0) {
                $CurrentLeft = [System.Windows.Controls.Canvas]::GetLeft($OutThumb)

                if ([double]::IsNaN($CurrentLeft)) {
                    $CurrentLeft = $Width - 12
                }

                $Center = $CurrentLeft + 12 + $_.HorizontalChange
                $InX = ($script:InPoint / $script:Duration) * $Width

                $Center = [Math]::Min($Width, $Center)
                $Center = [Math]::Max($InX, $Center)

                $script:OutPoint = ($Center / $Width) * $script:Duration

                [System.Windows.Controls.Canvas]::SetLeft($OutThumb, $Center - 12)

                $SelectionBar.Width = [Math]::Max(0, $Center - $InX)

                $OutBox.Text = [TimeSpan]::FromSeconds($script:OutPoint).ToString('hh\:mm\:ss\.fff')
                $OutMarkerText.Text = 'OUT ' + $OutBox.Text
                $Seek.Value = $script:OutPoint
            }
        }
    })

$OutThumb.Add_DragCompleted({
        if ($null -ne $script:PipeWriter) {
            $Value = $script:OutPoint.ToString([System.Globalization.CultureInfo]::InvariantCulture)
            $script:PipeWriter.WriteLine('{"command":["set_property","pause",true]}')
            $script:PipeWriter.WriteLine('{"command":["seek",' + $Value + ',"absolute+exact"]}')
        }
    })

$PlayButton.Add_Click({
        if ($null -ne $script:PipeWriter) {
            $script:PipeWriter.WriteLine('{"command":["cycle","pause"]}')
        }
    })

$MuteButton.Add_Click({
        if ($null -ne $script:PipeWriter) {
            $script:PipeWriter.WriteLine('{"command":["cycle","mute"]}')
        }
    })

$BackButton.Add_Click({
        if ($null -ne $script:PipeWriter) {
            $script:PipeWriter.WriteLine('{"command":["seek",-5,"relative+exact"]}')
        }
    })

$ForwardButton.Add_Click({
        if ($null -ne $script:PipeWriter) {
            $script:PipeWriter.WriteLine('{"command":["seek",5,"relative+exact"]}')
        }
    })

$BackFrameButton.Add_Click({
        if ($null -ne $script:PipeWriter) {
            $script:PipeWriter.WriteLine('{"command":["frame-back-step"]}')
        }
    })

$NextFrameButton.Add_Click({
        if ($null -ne $script:PipeWriter) {
            $script:PipeWriter.WriteLine('{"command":["frame-step"]}')
        }
    })

$Volume.Add_ValueChanged({
        $VolumeText.Text = "$([int]$Volume.Value)%"

        if ($null -ne $script:PipeWriter) {
            $VolumeValue = [int]$Volume.Value
            $script:PipeWriter.WriteLine('{"command":["set_property","volume",' + $VolumeValue + ']}')
        }
    })

$InButton.Add_Click({
        if ($script:Duration -gt 0) {
            $script:InPoint = [Math]::Min($script:Duration, [Math]::Max(0.0, $script:Position))

            if ($script:InPoint -gt $script:OutPoint) {
                $script:OutPoint = $script:InPoint
                $OutBox.Text = [TimeSpan]::FromSeconds($script:OutPoint).ToString('hh\:mm\:ss\.fff')
                $OutMarkerText.Text = 'OUT ' + $OutBox.Text
            }

            $InBox.Text = [TimeSpan]::FromSeconds($script:InPoint).ToString('hh\:mm\:ss\.fff')
            $InMarkerText.Text = 'IN ' + $InBox.Text

            $Width = $TimelineOverlay.ActualWidth

            if ($Width -gt 0) {
                $InX = ($script:InPoint / $script:Duration) * $Width
                $OutX = ($script:OutPoint / $script:Duration) * $Width

                [System.Windows.Controls.Canvas]::SetLeft($InThumb, $InX - 9)
                [System.Windows.Controls.Canvas]::SetLeft($OutThumb, $OutX - 12)
                [System.Windows.Controls.Canvas]::SetLeft($SelectionBar, $InX)

                $SelectionBar.Width = [Math]::Max(0, $OutX - $InX)
            }
        }
    })

$OutButton.Add_Click({
        if ($script:Duration -gt 0) {
            $script:OutPoint = [Math]::Min($script:Duration, [Math]::Max(0.0, $script:Position))

            if ($script:OutPoint -lt $script:InPoint) {
                $script:InPoint = $script:OutPoint
                $InBox.Text = [TimeSpan]::FromSeconds($script:InPoint).ToString('hh\:mm\:ss\.fff')
                $InMarkerText.Text = 'IN ' + $InBox.Text
            }

            $OutBox.Text = [TimeSpan]::FromSeconds($script:OutPoint).ToString('hh\:mm\:ss\.fff')
            $OutMarkerText.Text = 'OUT ' + $OutBox.Text

            $Width = $TimelineOverlay.ActualWidth

            if ($Width -gt 0) {
                $InX = ($script:InPoint / $script:Duration) * $Width
                $OutX = ($script:OutPoint / $script:Duration) * $Width

                [System.Windows.Controls.Canvas]::SetLeft($InThumb, $InX - 9)
                [System.Windows.Controls.Canvas]::SetLeft($OutThumb, $OutX - 12)
                [System.Windows.Controls.Canvas]::SetLeft($SelectionBar, $InX)

                $SelectionBar.Width = [Math]::Max(0, $OutX - $InX)
            }
        }
    })

$InBox.Add_LostKeyboardFocus({
        $Value = [TimeSpan]::Zero

        if ([TimeSpan]::TryParse($InBox.Text, [ref]$Value)) {
            $Seconds = [Math]::Max(0.0, $Value.TotalSeconds)

            if ($script:Duration -gt 0) {
                $Seconds = [Math]::Min($script:Duration, $Seconds)
            }

            if ($Seconds -le $script:OutPoint) {
                $script:InPoint = $Seconds
                $InBox.Text = [TimeSpan]::FromSeconds($script:InPoint).ToString('hh\:mm\:ss\.fff')
                $InMarkerText.Text = 'IN ' + $InBox.Text

                $Width = $TimelineOverlay.ActualWidth

                if ($script:Duration -gt 0 -and $Width -gt 0) {
                    $InX = ($script:InPoint / $script:Duration) * $Width
                    $OutX = ($script:OutPoint / $script:Duration) * $Width

                    [System.Windows.Controls.Canvas]::SetLeft($InThumb, $InX - 9)
                    [System.Windows.Controls.Canvas]::SetLeft($SelectionBar, $InX)

                    $SelectionBar.Width = [Math]::Max(0, $OutX - $InX)
                }
            }
        }
    })

$OutBox.Add_LostKeyboardFocus({
        $Value = [TimeSpan]::Zero

        if ([TimeSpan]::TryParse($OutBox.Text, [ref]$Value)) {
            $Seconds = [Math]::Max(0.0, $Value.TotalSeconds)

            if ($script:Duration -gt 0) {
                $Seconds = [Math]::Min($script:Duration, $Seconds)
            }

            if ($Seconds -ge $script:InPoint) {
                $script:OutPoint = $Seconds
                $OutBox.Text = [TimeSpan]::FromSeconds($script:OutPoint).ToString('hh\:mm\:ss\.fff')
                $OutMarkerText.Text = 'OUT ' + $OutBox.Text

                $Width = $TimelineOverlay.ActualWidth

                if ($script:Duration -gt 0 -and $Width -gt 0) {
                    $InX = ($script:InPoint / $script:Duration) * $Width
                    $OutX = ($script:OutPoint / $script:Duration) * $Width

                    [System.Windows.Controls.Canvas]::SetLeft($OutThumb, $OutX - 12)
                    [System.Windows.Controls.Canvas]::SetLeft($SelectionBar, $InX)

                    $SelectionBar.Width = [Math]::Max(0, $OutX - $InX)
                }
            }
        }
    })

$OpenButton.Add_Click({
        if ($OpenDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            $script:InputPath = $OpenDialog.FileName
            $script:OutputPath = $null
            $script:Duration = 0.0
            $script:Position = 0.0
            $script:InPoint = 0.0
            $script:OutPoint = 0.0
            $script:SetOutOnDuration = $true

            $SourceBox.Text = $script:InputPath
            $OutputBox.Text = ''
            $InBox.Text = '00:00:00.000'
            $OutBox.Text = '00:00:00.000'
            $InMarkerText.Text = 'IN 00:00:00.000'
            $OutMarkerText.Text = 'OUT 00:00:00.000'
            $Seek.Maximum = 1
            $Seek.Value = 0
            $SelectionBar.Width = 0

            [System.Windows.Controls.Canvas]::SetLeft($InThumb, -9)
            [System.Windows.Controls.Canvas]::SetLeft($OutThumb, -12)

            if ($null -ne $script:PipeWriter) {
                $JsonPath = ConvertTo-Json -InputObject $script:InputPath -Compress
                $script:PipeWriter.WriteLine('{"command":["loadfile",' + $JsonPath + ',"replace"]}')
                $script:PipeWriter.WriteLine('{"command":["set_property","pause",true]}')
            }
        }
    })

$SaveButton.Add_Click({
        $SaveDialog = New-Object System.Windows.Forms.SaveFileDialog
        $SaveDialog.Title = 'Save cut video'
        $SaveDialog.Filter = 'MP4|*.mp4|Matroska|*.mkv|QuickTime|*.mov|MPEG-TS|*.ts'
        $SaveDialog.DefaultExt = 'mp4'
        $SaveDialog.AddExtension = $true
        $SaveDialog.FileName = [IO.Path]::GetFileNameWithoutExtension($script:InputPath) + '_cut'
        $SaveDialog.InitialDirectory = [IO.Path]::GetDirectoryName($script:InputPath)

        if ($SaveDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            $script:OutputPath = $SaveDialog.FileName
            $OutputBox.Text = $script:OutputPath
        }
    })

$ExportButton.Add_Click({
        if ([string]::IsNullOrWhiteSpace($script:OutputPath)) {
            [System.Windows.MessageBox]::Show('Choose where to save the video first.', 'MiniCut')
            return
        }

        if ([string]::Equals([IO.Path]::GetFullPath($script:InputPath), [IO.Path]::GetFullPath($script:OutputPath), [System.StringComparison]::OrdinalIgnoreCase)) {
            [System.Windows.MessageBox]::Show('The output file must be different from the source file.', 'MiniCut')
            return
        }

        $Start = [TimeSpan]::FromSeconds($script:InPoint)
        $End = [TimeSpan]::FromSeconds($script:OutPoint)

        if ($End -le $Start) {
            [System.Windows.MessageBox]::Show('The OUT point must be after the IN point.', 'MiniCut')
            return
        }

        $Length = $End - $Start
        $StartText = $Start.ToString('hh\:mm\:ss\.fff')
        $LengthText = $Length.ToString('hh\:mm\:ss\.fff')
        $Accurate = $AccurateBox.IsChecked -eq $true

        $ExportButton.IsEnabled = $false
        $StatusText.Text = 'Exporting'

        $script:ExportJob = Start-Job -ArgumentList $script:InputPath, $StartText, $LengthText, $script:OutputPath, $Accurate -ScriptBlock {
            param($InputPath, $StartValue, $LengthValue, $OutputPath, $AccurateValue)

            if ($AccurateValue -eq $true) {
                & ffmpeg.exe -y -ss $StartValue -i $InputPath -t $LengthValue -c:v libx264 -preset medium -crf 18 -c:a aac -b:a 192k $OutputPath 2>$null
            } else {
                & ffmpeg.exe -y -ss $StartValue -i $InputPath -t $LengthValue -c copy $OutputPath 2>$null
            }

            $LASTEXITCODE
        }

        $ExportTimer.Start()
    })

$ExportTimer.Add_Tick({
        if ($null -ne $script:ExportJob) {
            if ($script:ExportJob.State -match 'Completed|Failed|Stopped') {
                $ExportTimer.Stop()

                $Result = @(Receive-Job -Job $script:ExportJob -ErrorAction SilentlyContinue)
                $ExitCode = 1

                if ($Result.Count -gt 0) {
                    $ExitCode = [int]$Result[$Result.Count - 1]
                }

                Remove-Job -Job $script:ExportJob

                $script:ExportJob = $null
                $ExportButton.IsEnabled = $true

                if ($ExitCode -eq 0) {
                    $StatusText.Text = 'Finished'
                    [System.Windows.MessageBox]::Show('Video exported successfully.', 'MiniCut')
                } else {
                    $StatusText.Text = 'Export failed'
                    [System.Windows.MessageBox]::Show('ffmpeg could not export the video.', 'MiniCut')
                }
            }
        }
    })

$Window.Add_Closing({
        $Timer.Stop()
        $ExportTimer.Stop()

        if ($null -ne $script:ExportJob) {
            Stop-Job -Job $script:ExportJob
            Remove-Job -Job $script:ExportJob
            $script:ExportJob = $null
        }

        if ($null -ne $script:PipeWriter) {
            try {
                $script:PipeWriter.WriteLine('{"command":["quit"]}')
            } catch {
            }
        }

        if ($null -ne $script:PipeWriter) {
            $script:PipeWriter.Dispose()
        }

        if ($null -ne $script:PipeReader) {
            $script:PipeReader.Dispose()
        }

        if ($null -ne $script:Pipe) {
            $script:Pipe.Dispose()
        }

        if ($null -ne $script:Mpv) {
            if ($script:Mpv.HasExited -eq $false) {
                $script:Mpv.Kill()
            }

            $script:Mpv.Dispose()
        }
    })

$null = $Window.ShowDialog()
