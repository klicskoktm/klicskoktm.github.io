# A GPO backup főmappa helye
$BackupPath = "C:\GPOs"

# Minden backup almappát feldolgoz
Get-ChildItem -Path $BackupPath -Directory | ForEach-Object {
    $GpoBackupFolder = $_.FullName
    $GpreportPath = Join-Path $GpoBackupFolder "gpreport.xml"

    if (Test-Path $GpreportPath) {
        try {
            [xml]$xml = Get-Content $GpreportPath
            $GpoName = $xml.GPO.Name

            if (![string]::IsNullOrWhiteSpace($GpoName)) {
                Write-Host "Importalas: $GpoName"
                Import-GPO -BackupGpoName $GpoName -Path $BackupPath -TargetName $GpoName -CreateIfNeeded
                Write-Host "Sikeres importalas: $GpoName"
            } else {
                Write-Host "Ures GPO nev: $GpreportPath"
            }
        } catch {
            Write-Host "Hiba tortént a feldolgozás soran: $_"
        }
    } else {
        Write-Host "Nem talalhato gpreport.xml: $GpoBackupFolder"
    }
}
