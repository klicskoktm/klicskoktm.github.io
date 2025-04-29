# Windows Incident Response Mini-Script
# Szerzo: ChatGPT & Tamas

# Riport fajl neve
$timestamp = (Get-Date -Format "yyyyMMdd_HHmmss")
$reportPath = "$env:USERPROFILE\Desktop\Windows_IR_Report_$timestamp.txt"

# Riport kezdese
"Windows Incident Response Gyors Riport" | Set-Content -Path $reportPath -Encoding utf8
"Datum: $(Get-Date)" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath


# Folyamatok

"" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
"# Folyamatok listazasa" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
Get-Process | ForEach-Object {
    "$($_.Name) - $($_.Id) - $($_.Path) - $($_.StartTime)"
} | Add-Content -Path $reportPath


"" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
"# Szulo-Gyermek folyamatok" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
Get-WmiObject Win32_Process | ForEach-Object {
    "$($_.ProcessId) - $($_.ParentProcessId) - $($_.Name) - $($_.CommandLine)"
} | Add-Content -Path $reportPath


"" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
"# Alairatlan folyamatok" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
Get-Process | Where-Object { $_.Path -and (Get-AuthenticodeSignature $_.Path).Status -ne 'Valid' } | ForEach-Object {
    "$($_.Name) - $($_.Path)"
} | Add-Content -Path $reportPath


# Halozati kapcsolatok

"" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
"# Halozati kapcsolatok" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
Get-NetTCPConnection | ForEach-Object {
    "$($_.LocalAddress):$($_.LocalPort) -> $($_.RemoteAddress):$($_.RemotePort) [$($_.State)]"
} | Add-Content -Path $reportPath


# Felhasznaloi fiokok

"" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
"# Felhasznalok az Administrators csoportban" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
Get-LocalGroupMember -Group "Administrators" | ForEach-Object {
    "$($_.Name) - $($_.ObjectClass)"
} | Add-Content -Path $reportPath


"" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
"# Uj felhasznalok az elmult 7 napban" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
Get-LocalUser | Where-Object { $_.WhenCreated -gt (Get-Date).AddDays(-7) } | ForEach-Object {
    "$($_.Name) - $($_.Enabled) - $($_.WhenCreated)"
} | Add-Content -Path $reportPath


# Fajlrendszer ellenorzes

"" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
"# Friss fajlmodositasok a System32-ben (utolso 3 nap)" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
Get-ChildItem -Path "C:\Windows\System32" -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -gt (Get-Date).AddDays(-3) } | ForEach-Object {
    "$($_.FullName) - $($_.LastWriteTime)"
} | Add-Content -Path $reportPath


# Esemenynaplok

"" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
"# Sikertelen bejelentkezesek (4625)" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4625} -MaxEvents 20 | ForEach-Object {
    "$($_.TimeCreated) - $($_.Message)"
} | Add-Content -Path $reportPath


"" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
"# Folyamatinditasok (4688)" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4688} -MaxEvents 20 | ForEach-Object {
    "$($_.TimeCreated) - $($_.Message)"
} | Add-Content -Path $reportPath


"" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
"# PowerShell futtatasi esemenyek" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" -MaxEvents 20 | ForEach-Object {
    "$($_.TimeCreated) - $($_.Message)"
} | Add-Content -Path $reportPath


# Scheduled Tasks

"" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
"# Scheduled Tasks" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
Get-ScheduledTask | Where-Object {$_.State -eq 'Ready'} | ForEach-Object {
    "$($_.TaskName) - $($_.TaskPath)"
} | Add-Content -Path $reportPath


# Registry Run kulcsok

"" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
"# Registry Run kulcsok (HKLM)" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
(Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -ErrorAction SilentlyContinue).PSObject.Properties | ForEach-Object {
    "$($_.Name) - $($_.Value)"
} | Add-Content -Path $reportPath


"" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
"# Registry Run kulcsok (HKCU)" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
(Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -ErrorAction SilentlyContinue).PSObject.Properties | ForEach-Object {
    "$($_.Name) - $($_.Value)"
} | Add-Content -Path $reportPath


# Megosztasok listazasa

"" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
"# Megosztasok listazasa" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
Get-SmbShare | ForEach-Object {
    "$($_.Name) - $($_.Path) - $($_.Description)"
} | Add-Content -Path $reportPath


# Hosts fajl ellenorzese

"" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
"# Hosts fajl tartalma" | Add-Content -Path $reportPath
"---" | Add-Content -Path $reportPath
Get-Content -Path "C:\Windows\System32\drivers\etc\hosts" | ForEach-Object {
    $_
} | Add-Content -Path $reportPath


# Vegen ertesites

Write-Output "Riport kesz: $reportPath"
Start-Process notepad.exe $reportPath