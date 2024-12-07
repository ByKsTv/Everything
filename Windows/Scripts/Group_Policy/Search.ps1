$SearchDirectory = "$env:windir\PolicyDefinitions"
$SearchText = "*ConnectedSearchUseWeb*"
$Files = Get-ChildItem -Path $SearchDirectory -Recurse -File
foreach ($File in $Files) {
    try {
        $FileContent = Get-Content -Path $File.FullName -ErrorAction Stop
        if ($FileContent -like $SearchText) {
            Write-Host "Found '$SearchText' in file: $($File.FullName)" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "Error reading file: $($File.FullName)" -ForegroundColor Red
    }
}