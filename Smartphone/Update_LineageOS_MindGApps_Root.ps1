<#
.SYNOPSIS
    Guides and automates the LineageOS + MindTheGapps + Magisk root install process.

.DESCRIPTION
    Combines ADB/fastboot automation with manual-confirmation pauses for the steps
    that cannot be driven programmatically (Magisk app UI, stock/TWRP recovery menu
    navigation while ADB is unavailable).

    Run this from a PowerShell window where adb.exe and fastboot.exe are on PATH,
    or edit $AdbExecutable / $FastbootExecutable below to point at your platform-tools folder.
#>

# ----------------------------------------------------------------------------
# Configuration
# ----------------------------------------------------------------------------

$AdbExecutable = 'adb.exe'
$FastbootExecutable = 'fastboot.exe'
$DeviceDownloadPath = '/storage/emulated/0/Download'

# ----------------------------------------------------------------------------
# Output helpers
# ----------------------------------------------------------------------------

function Write-StatusLine {
    param(
        [Parameter(Mandatory = $true)][string]$StatusMessage,
        [string]$StatusColor = 'Yellow'
    )
    [Console]::BackgroundColor = 'Black'
    [Console]::ForegroundColor = 'Green'
    [Console]::Write('Status: ')
    [Console]::ForegroundColor = $StatusColor
    [Console]::Write($StatusMessage)
    [Console]::ResetColor()
    [Console]::WriteLine()
}

function Write-StepHeader {
    param([Parameter(Mandatory = $true)][string]$StepDescription)
    Write-Host ''
    Write-Host '==================================================================' -ForegroundColor Cyan
    Write-Host $StepDescription -ForegroundColor Cyan
    Write-Host '==================================================================' -ForegroundColor Cyan
}

function Wait-ForManualConfirmation {
    param([Parameter(Mandatory = $true)][string]$InstructionMessage)
    Write-StatusLine -StatusMessage $InstructionMessage -StatusColor 'Magenta'
    Write-Host 'Press Enter once you have completed this step on the device...' -ForegroundColor DarkGray
    Read-Host | Out-Null
}

function Get-SingleMatchingFile {
    <#
        Finds exactly one file in $SearchDirectory matching $IncludePattern,
        optionally excluding files matching $ExcludePattern.
        Exits the script with a clear error if zero or multiple matches are found.
    #>
    param(
        [Parameter(Mandatory = $true)][string]$SearchDirectory,
        [Parameter(Mandatory = $true)][string]$IncludePattern,
        [string]$ExcludePattern,
        [Parameter(Mandatory = $true)][string]$FileDescription
    )

    $matchingFiles = Get-ChildItem -Path $SearchDirectory -Filter $IncludePattern -File -ErrorAction SilentlyContinue

    if ($ExcludePattern) {
        $matchingFiles = $matchingFiles | Where-Object { $_.Name -notlike $ExcludePattern }
    }

    if (-not $matchingFiles -or $matchingFiles.Count -eq 0) {
        Write-StatusLine -StatusMessage "No $FileDescription found in '$SearchDirectory' matching '$IncludePattern'." -StatusColor 'Red'
        exit 1
    }

    if ($matchingFiles.Count -gt 1) {
        Write-StatusLine -StatusMessage "Multiple $FileDescription found in '$SearchDirectory'. Please leave only one:" -StatusColor 'Red'
        $matchingFiles | ForEach-Object { Write-Host "  - $($_.Name)" -ForegroundColor Red }
        exit 1
    }

    return $matchingFiles[0]
}

function Invoke-AdbSideloadWithManualPrompt {
    <#
        Runs "adb sideload" for the given zip and waits for it to finish on its own -
        no forced "press Enter" gate, since most sideloads complete without any
        on-device prompt at all. Some installs DO pop up an on-device prompt mid-
        install (e.g. "reboot to recovery to install additional packages?" after the
        ROM zip, or "Signature verification failed, install anyway?" for unofficial
        gapps zips), which blocks "adb sideload" on the PC until answered on the
        phone. If the process is still running after a short while, we print a
        one-time reminder about that possible prompt, but keep waiting either way -
        the process exiting on its own is what actually tells us it's done.

        Uses a raw System.Diagnostics.Process (rather than the Start-Process cmdlet's
        -PassThru object) because that cmdlet's .ExitCode has been unreliable here,
        coming back blank even on a normal, non-rebooting completion. A plain Process
        object with UseShellExecute = $false reads the real exit code correctly.

        IMPORTANT: "adb sideload" only performs the file transfer - "Total xfer: 1.00x"
        means the transfer finished successfully. Actual installation continues in a
        script running on the device, independent of the adb process on the PC. If
        that on-device step ends by rebooting the device (e.g. "reboot to recovery to
        install additional packages?"), the connection is severed abnormally and
        adb.exe's own exit code can become meaningless - it may come back non-zero
        even though everything actually succeeded. Pass -ExpectDeviceReboot for
        sideloads where the device is known to reboot itself away afterward, so a bad
        exit code is treated as a warning instead of a hard failure.
    #>
    param(
        [Parameter(Mandatory = $true)][string]$ZipFilePath,
        [Parameter(Mandatory = $true)][string]$ManualPromptInstruction,
        [switch]$ExpectDeviceReboot
    )

    $processStartInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processStartInfo.FileName = $AdbExecutable
    $processStartInfo.Arguments = "sideload `"$ZipFilePath`""
    $processStartInfo.UseShellExecute = $false

    $sideloadProcess = New-Object System.Diagnostics.Process
    $sideloadProcess.StartInfo = $processStartInfo
    $sideloadProcess.Start() | Out-Null

    $secondsWaited = 0
    $promptReminderShown = $false
    $promptReminderThresholdSeconds = 15

    while (-not $sideloadProcess.HasExited) {
        Start-Sleep -Seconds 1
        $secondsWaited++

        if (-not $promptReminderShown -and $secondsWaited -ge $promptReminderThresholdSeconds) {
            Write-StatusLine -StatusMessage $ManualPromptInstruction -StatusColor 'Magenta'
            $promptReminderShown = $true
        }
    }

    $sideloadProcess.WaitForExit()
    $sideloadExitCode = $sideloadProcess.ExitCode
    $sideloadSucceeded = ($sideloadExitCode -eq 0)

    if (-not $sideloadSucceeded) {
        if ($ExpectDeviceReboot) {
            Write-StatusLine -StatusMessage "adb reported exit code $sideloadExitCode, but the device was expected to reboot itself away right after this transfer, which normally makes adb's exit code unreliable. Treating this as OK based on the transfer output above." -StatusColor 'Yellow'
        } else {
            Write-StatusLine -StatusMessage "Sideload failed (adb exit code $sideloadExitCode). See adb output above for details." -StatusColor 'Red'
            exit 1
        }
    } else {
        Write-StatusLine -StatusMessage 'adb sideload finished successfully' -StatusColor 'Green'
    }
}

# ----------------------------------------------------------------------------
# Step 1: Confirm device is connected via ADB
# ----------------------------------------------------------------------------

function Wait-ForAdbDevice {
    Write-StepHeader -StepDescription 'Step 1: Waiting for ADB device connection'

    while ($true) {
        $connectedDevices = & $AdbExecutable devices 2>$null | Out-String
        if ($connectedDevices -match '(?m)^.+\s+device\s*$') {
            break
        }
        Write-StatusLine -StatusMessage 'Waiting for a connected device...'
        Start-Sleep -Seconds 2
    }

    Write-StatusLine -StatusMessage 'Device connected' -StatusColor 'Green'
}

# ----------------------------------------------------------------------------
# Step 2: Ask the user for the folder containing the install files
# ----------------------------------------------------------------------------

function Select-InstallFilesFolder {
    Write-StepHeader -StepDescription 'Step 2: Select folder containing LineageOS zip, boot.img, and MindTheGapps'

    Add-Type -AssemblyName PresentationFramework

    $folderDialog = New-Object Microsoft.Win32.OpenFileDialog
    $folderDialog.Title = 'Select the folder containing the APK/ROM files'
    $folderDialog.CheckFileExists = $false
    $folderDialog.CheckPathExists = $true
    $folderDialog.ValidateNames = $false
    $folderDialog.FileName = 'Select Folder'

    if ($folderDialog.ShowDialog() -ne $true) {
        Write-StatusLine -StatusMessage 'No folder selected. Exiting.' -StatusColor 'Red'
        exit 1
    }

    $selectedFolderPath = [IO.Path]::GetDirectoryName($folderDialog.FileName)
    Write-StatusLine -StatusMessage "Selected folder: $selectedFolderPath" -StatusColor 'Green'

    return $selectedFolderPath
}

# ----------------------------------------------------------------------------
# Step 3: Push boot.img to the device
# ----------------------------------------------------------------------------

function Push-BootImageToDevice {
    param([Parameter(Mandatory = $true)][string]$InstallFilesFolder)

    Write-StepHeader -StepDescription 'Step 3: Push boot.img to device'

    $bootImageFile = Get-SingleMatchingFile -SearchDirectory $InstallFilesFolder -IncludePattern 'boot.img' -FileDescription 'boot.img file'

    Write-StatusLine -StatusMessage "Pushing $($bootImageFile.Name) to $DeviceDownloadPath ..."
    & $AdbExecutable push $bootImageFile.FullName $DeviceDownloadPath

    if ($LASTEXITCODE -ne 0) {
        Write-StatusLine -StatusMessage 'Failed to push boot.img to device.' -StatusColor 'Red'
        exit 1
    }

    Write-StatusLine -StatusMessage 'boot.img pushed successfully' -StatusColor 'Green'
}

# ----------------------------------------------------------------------------
# Step 4: Patch boot.img using the Magisk app (manual - no ADB automation available)
# ----------------------------------------------------------------------------

function Invoke-MagiskPatchStep {
    Write-StepHeader -StepDescription 'Step 4: Patch boot.img with Magisk'

    Wait-ForManualConfirmation -InstructionMessage `
        "On the device, open Magisk -> Install -> Select and Patch a File -> choose boot.img (in Downloads) -> Let's Go. Wait until patching completes."
}

# ----------------------------------------------------------------------------
# Step 5: Pull the patched boot image from the device
# ----------------------------------------------------------------------------

function Get-PatchedBootImageFromDevice {
    param([Parameter(Mandatory = $true)][string]$LocalDestinationFolder)

    Write-StepHeader -StepDescription 'Step 5: Pull patched boot image from device'

    Write-StatusLine -StatusMessage 'Looking for magisk_patched-*.img on device...'

    # Use "ls -t" so the device sorts matches newest-first; this lets us pick the most
    # recently patched file when the script has been run before and older patched
    # images are still sitting in Downloads.
    $deviceListing = & $AdbExecutable shell "ls -t $DeviceDownloadPath/magisk_patched-*.img" 2>$null | Out-String
    $patchedFilePaths = $deviceListing -split "`r?`n" | Where-Object { $_.Trim() -like '*magisk_patched-*.img' } | ForEach-Object { $_.Trim() }

    if (-not $patchedFilePaths -or $patchedFilePaths.Count -eq 0) {
        Write-StatusLine -StatusMessage 'No magisk_patched-*.img file found on device. Was patching completed?' -StatusColor 'Red'
        exit 1
    }

    if ($patchedFilePaths.Count -gt 1) {
        Write-StatusLine -StatusMessage 'Multiple magisk_patched-*.img files found on device (likely from a previous run). Using the most recently modified one:' -StatusColor 'Yellow'
        $patchedFilePaths | ForEach-Object { Write-Host "  - $_" -ForegroundColor DarkGray }
    }

    $devicePatchedFilePath = $patchedFilePaths[0]
    $patchedFileName = ($devicePatchedFilePath -split '/')[-1]
    Write-StatusLine -StatusMessage "Using: $patchedFileName" -StatusColor 'Green'

    Write-StatusLine -StatusMessage "Pulling $patchedFileName to $LocalDestinationFolder ..."
    & $AdbExecutable pull $devicePatchedFilePath $LocalDestinationFolder

    if ($LASTEXITCODE -ne 0) {
        Write-StatusLine -StatusMessage 'Failed to pull patched boot image from device.' -StatusColor 'Red'
        exit 1
    }

    $localPatchedFilePath = Join-Path $LocalDestinationFolder $patchedFileName
    Write-StatusLine -StatusMessage "Patched boot image saved: $localPatchedFilePath" -StatusColor 'Green'

    return $localPatchedFilePath
}

# ----------------------------------------------------------------------------
# Step 6: Reboot to sideload and confirm state
# ----------------------------------------------------------------------------

function Wait-ForSideloadMode {
    Write-StepHeader -StepDescription 'Step 6: Reboot to sideload mode'

    Write-StatusLine -StatusMessage 'Rebooting device into sideload mode...'
    & $AdbExecutable reboot sideload

    while ($true) {
        $deviceListing = & $AdbExecutable devices 2>$null | Out-String
        if ($deviceListing -match '(?m)^.+\s+sideload\s*$') {
            break
        }
        Write-StatusLine -StatusMessage 'Waiting for device to enter sideload mode...'
        Start-Sleep -Seconds 2
    }

    Write-StatusLine -StatusMessage 'Device is in sideload mode' -StatusColor 'Green'
}

# ----------------------------------------------------------------------------
# Step 7: Sideload the LineageOS zip
# ----------------------------------------------------------------------------

function Install-LineageOsZip {
    param([Parameter(Mandatory = $true)][string]$InstallFilesFolder)

    Write-StepHeader -StepDescription 'Step 7: Sideload LineageOS zip'

    $lineageZipFile = Get-SingleMatchingFile -SearchDirectory $InstallFilesFolder -IncludePattern 'lineage-*.zip' -FileDescription 'LineageOS zip file'

    Write-StatusLine -StatusMessage "Starting sideload of $($lineageZipFile.Name) ... this can take several minutes."

    Invoke-AdbSideloadWithManualPrompt -ZipFilePath $lineageZipFile.FullName -ExpectDeviceReboot -ManualPromptInstruction `
        "This is taking a bit long - check the device screen. If it's asking to reboot to recovery to install additional packages, select Yes. The device will disconnect and reboot after that, which is expected; the script will keep waiting."

    Write-StatusLine -StatusMessage 'LineageOS sideload complete' -StatusColor 'Green'
}

# ----------------------------------------------------------------------------
# Step 8: Enable ADB sideload from recovery (manual - ADB is unavailable until
# re-enabled). Step numbering skips from 7 straight to 8: the plain "reboot to
# recovery" step is not separate here because it already happens as part of
# confirming the prompt at the end of step 7.
# ----------------------------------------------------------------------------

function Invoke-EnableAdbSideloadStep {
    Write-StepHeader -StepDescription 'Step 8: Enable ADB sideload from recovery'

    Wait-ForManualConfirmation -InstructionMessage `
        'On the device, navigate Advanced -> Enable ADB (if present) -> Apply Update -> Apply from ADB, so it is waiting for a sideload.'
}

# ----------------------------------------------------------------------------
# Steps 9 & 10: Sideload MindTheGapps (excluding ATV builds) and handle the
# "Signature verification failed, install anyway?" prompt.
#
# NOTE: These two steps are combined because "adb sideload" blocks on the PC
# side for the entire duration of the on-device install, including while the
# signature-verification prompt is up. The prompt must be confirmed on the
# phone WHILE the sideload command is still running, not after it returns.
# We start the sideload as a background process so we can prompt the user
# for the phone-side tap without the console being blocked, then wait for
# the process to exit and check its real exit code to confirm the install
# actually completed successfully.
# ----------------------------------------------------------------------------

function Install-MindTheGappsZip {
    param([Parameter(Mandatory = $true)][string]$InstallFilesFolder)

    Write-StepHeader -StepDescription 'Step 9-10: Sideload MindTheGapps zip and confirm signature prompt'

    # Devices waiting on "Apply from ADB" show up in state "sideload", not the
    # regular "device" state, so we must wait for that state specifically here
    # rather than reusing Wait-ForAdbDevice (which only matches "device" and
    # would loop forever while the phone sits in the recovery sideload screen).
    Write-StatusLine -StatusMessage 'Waiting for device to be ready for sideload (Apply from ADB)...'
    while ($true) {
        $sideloadState = & $AdbExecutable devices 2>$null | Out-String
        if ($sideloadState -match '(?m)^.+\s+sideload\s*$') {
            break
        }
        Write-StatusLine -StatusMessage 'Waiting for device to enter sideload mode...'
        Start-Sleep -Seconds 2
    }
    Write-StatusLine -StatusMessage 'Device is ready for sideload' -StatusColor 'Green'

    $gappsZipFile = Get-SingleMatchingFile -SearchDirectory $InstallFilesFolder -IncludePattern 'MindTheGapps-*.zip' -ExcludePattern '*ATV*' -FileDescription 'MindTheGapps zip file (non-ATV)'

    Write-StatusLine -StatusMessage "Starting sideload of $($gappsZipFile.Name) ..."

    Invoke-AdbSideloadWithManualPrompt -ZipFilePath $gappsZipFile.FullName -ManualPromptInstruction `
        "This is taking a bit long - check the device screen. If it shows 'Signature verification failed, install anyway?', select Yes. The script will keep waiting until the install finishes."

    Write-StatusLine -StatusMessage 'MindTheGapps sideload complete' -StatusColor 'Green'
}

# ----------------------------------------------------------------------------
# Step 11: Reboot to bootloader and confirm fastboot state
# ----------------------------------------------------------------------------

function Wait-ForFastbootDevice {
    Write-StepHeader -StepDescription 'Step 11: Reboot to bootloader (confirm fastboot detects device)'

    # Right after a sideload install finishes, adb can briefly report "error: closed"
    # if we send a command immediately - the transport hasn't settled yet. Rather than
    # firing "adb reboot bootloader" once and giving up, wait for adb to show the
    # device in a known state again, then retry the reboot command itself a few times
    # before falling back to fastboot polling.
    Write-StatusLine -StatusMessage 'Waiting for adb to detect the device after the MindTheGapps install...'
    $adbSeenAfterInstall = $false
    for ($secondsWaited = 0; $secondsWaited -lt 60; $secondsWaited += 2) {
        $deviceListing = & $AdbExecutable devices 2>$null | Out-String
        if ($deviceListing -match '(?m)^\S+\s+(device|recovery|sideload)\s*$') {
            $adbSeenAfterInstall = $true
            break
        }
        Start-Sleep -Seconds 2
    }

    if (-not $adbSeenAfterInstall) {
        Write-StatusLine -StatusMessage 'adb has not seen the device reappear yet - will still try to reboot to bootloader.' -StatusColor 'Yellow'
    }

    $maxRebootAttempts = 5
    $rebootSucceeded = $false
    for ($attempt = 1; $attempt -le $maxRebootAttempts; $attempt++) {
        Write-StatusLine -StatusMessage "Rebooting device into bootloader mode (attempt $attempt of $maxRebootAttempts)..."
        $rebootOutput = & $AdbExecutable reboot bootloader 2>&1 | Out-String

        if ($LASTEXITCODE -eq 0) {
            $rebootSucceeded = $true
            break
        }

        Write-StatusLine -StatusMessage "adb reboot bootloader did not succeed yet ($($rebootOutput.Trim())). Retrying shortly..." -StatusColor 'Yellow'
        Start-Sleep -Seconds 3
    }

    if (-not $rebootSucceeded) {
        Write-StatusLine -StatusMessage "adb reboot bootloader never returned success after $maxRebootAttempts attempts. Will keep polling fastboot anyway in case the device rebooted despite the reported error." -StatusColor 'Yellow'
    }

    while ($true) {
        $fastbootDevices = & $FastbootExecutable devices 2>$null | Out-String
        if ($fastbootDevices -match '(?m)^\S+\s+fastboot\s*$') {
            break
        }
        Write-StatusLine -StatusMessage 'Waiting for device to enter bootloader/fastboot mode...'
        Start-Sleep -Seconds 2
    }

    Write-StatusLine -StatusMessage 'Device detected in bootloader mode' -StatusColor 'Green'
}

# ----------------------------------------------------------------------------
# Step 12: Flash the patched boot image
# ----------------------------------------------------------------------------

function Install-PatchedBootImage {
    param([Parameter(Mandatory = $true)][string]$PatchedBootImagePath)

    Write-StepHeader -StepDescription 'Step 12: Flash patched boot image'

    if (-not (Test-Path -Path $PatchedBootImagePath)) {
        Write-StatusLine -StatusMessage "Patched boot image not found at '$PatchedBootImagePath'." -StatusColor 'Red'
        exit 1
    }

    Write-StatusLine -StatusMessage "Flashing $(Split-Path $PatchedBootImagePath -Leaf) to boot partition..."
    & $FastbootExecutable flash boot $PatchedBootImagePath

    if ($LASTEXITCODE -ne 0) {
        Write-StatusLine -StatusMessage 'Flashing patched boot image failed.' -StatusColor 'Red'
        exit 1
    }

    Write-StatusLine -StatusMessage 'Patched boot image flashed successfully' -StatusColor 'Green'
}

# ----------------------------------------------------------------------------
# Step 13: Reboot to system
# ----------------------------------------------------------------------------

function Invoke-RebootToSystem {
    Write-StepHeader -StepDescription 'Step 13: Reboot to system'

    Write-StatusLine -StatusMessage 'Rebooting device to system...'
    & $FastbootExecutable reboot

    Write-StatusLine -StatusMessage 'Done. Device is rebooting into LineageOS with root.' -StatusColor 'Green'
}

# ----------------------------------------------------------------------------
# Main flow
# ----------------------------------------------------------------------------

function Invoke-LineageOsInstall {
    Wait-ForAdbDevice
    $installFilesFolder = Select-InstallFilesFolder
    Push-BootImageToDevice -InstallFilesFolder $installFilesFolder
    Invoke-MagiskPatchStep
    $patchedBootImagePath = Get-PatchedBootImageFromDevice -LocalDestinationFolder $installFilesFolder
    Wait-ForSideloadMode
    Install-LineageOsZip -InstallFilesFolder $installFilesFolder
    Invoke-EnableAdbSideloadStep
    Install-MindTheGappsZip -InstallFilesFolder $installFilesFolder
    Wait-ForFastbootDevice
    Install-PatchedBootImage -PatchedBootImagePath $patchedBootImagePath
    Invoke-RebootToSystem
}

Invoke-LineageOsInstall
