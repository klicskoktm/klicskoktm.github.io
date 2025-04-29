# Windows admin jegyzet

[To do list (pdf)](./to_do_list.pdf) <br>
[DFIR parancsok(pdf)](./DFIR.pdf) <br>
[GPO import script](./importGPOs.ps1) <br>
[PS Script ellenőrző parancsok incident report](./incident_report.ps1) <br>

Az ellenőrző parancsokat egyszerre lefuttatja a fenti srcipt. <br>
Használata:<br>
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass <br>
cd $env:USERPROFILE\Desktop <br>
.\incident_report.ps1 <br>
<br>

## Egy Windows Server esetén az alábbi területeket kell figyelni:

Terület	Miért fontos? <br>
Eseménynaplók	- Rendszeresemények, bejelentkezések, hibák <br>
Folyamatok és memória	- Futó/indított programok <br>
Hálózati aktivitás	- Gyanús kapcsolatok, adatkiáramlás <br>
Fájlrendszer változások	- Új fájlok, módosított binárisok <br>
Felhasználói fiókok, jogosultságok	- Új admin fiókok, jogosultságemelés <br>
Állandósítás jelei (persistence)	- Scheduled Task, Registry módosítások <br>
Malware nyomok	- Ismeretlen binárisok, rejtett folyamatok <br>
<br>

## Rosszindulatú folyamatok azonosítása

Keressen olyan folyamatokat, amelyek: <br>
Rossz szülői folyamattal indultak (lsass.exe a szülőfolyamat explorer.exe-vel <br>
Rosszul írt vagy furcsán elnevezett folyamatok (pl. lssass.exe, scvhost.exe) <br>
A vártnál több példány (az smss.exe folyamat 2 példánya fut) <br>
A futtatható folyamat rossz útvonalról fut (a services.exe a temp mappából fut) <br>
Rossz felhasználói fiók alatt futó folyamatok (az lsass.exe folyamat a felhasználó fiókja alatt fut <br>
Szokatlan indítási idejű folyamatok (pl. az lssass.exe folyamat 5 órával a rendszerindítás után indult el) <br>
Nyitott kapcsolatok és portok <br>
Futtatott folyamatok/szolgáltatások/feladatok <br>
Web browser history, E-mails, Outlook <br>
A nyitott portok és a kapcsolódó folyamatok és programok korrelációja <br>
Nyitott fájlok vizsgálata; hozzárendelt meghajtók és megosztások azonosítása <br>
A parancssori előzmények vizsgálata <br>
Ellenőrizze a jogosulatlan fiókokat, csoportokat, megosztásokat és egyéb rendszererőforrásokat, és konfigurációkat a "net" parancs használatával <br>
Az ütemezett feladatok meghatározása <br>
<br>

## Parancsok

**msconfig** : System Configuration utility, Rendszerkonfiguráció <br>
- Tools <br>
Windows névjegy <br>
UAC beállítás <br>
Biztonság és karbantartás <br>
Windows hibaelhárítás <br>
Számítógép kezelés - Computer management <br>
**compmgmt** - Task Scheduler - Event Viewer - Local Users and Groups - **lusrmgr.msc**  <br>
Rendszerinformáció - System Information <br>
**msinfo32** - Szoftverkörnyezet/Software Envireonment - Környezeti változók/Environment Variables - TEMP <br>
Control Panel > System and Security > System > Advanced system settings > Environment Variables  <br>
OR Settings > System > About > system info > Advanced system settings > Environment Variables. <br>
Eseménynapló <br>
Programok telepítése törlése <br>
Rendszer tulajdonságai <br>
Erőforrás figyelő / Resource monitor - Hálózati kapcsolatkok figyelésére - **resmon** <br>
Registry Editor/Beállításszerkesztő - **regedit** <br>
<br>

## Windows Server Parancsok

[GPOk letöltése: Microsoft Security Compliance Toolkit 1.0](https://www.microsoft.com/en-us/download/details.aspx?id=55319) <br>
[GPO import script](./importGPOs.ps1) <br>
Resultant Set of Policy (RSoP) – **rsop.msc** <br>
Group Policy Management Console (GPMC) – **gpmc.msc** <br>
 - Group Policy Objects: Itt látod az összes definiált GPO-t.<br>
Jobb klikk egy GPO-ra → Edit → nézd meg a konfigurációkat:<br>
Computer Configuration → Policies → Windows Settings → Security Settings<br>
GPO hatásosságának ellenőrzése (melyik GPO aktív egy gépen): **gpresult /H eredmeny.html**<br>
Automatikus riportkészítés: Ha sok GPO-t akarsz egyszerre kiexportálni: Powershell scriptet használhatsz, pl.:<br>

 - Get-GPO -All | ForEach-Object {<br>
    (tab)Get-GPOReport -Guid $_.Id -ReportType Html -Path "C:\GPOReports\$($_.DisplayName).html"<br>
}<br>
- Összes GPO kiexportálása PowerShell-lel:<br>
Backup-GPO -All -Path "C:\GPO_Backups"<br>
- GPO importálása GPMC-ben: <br>
Kattints Group Policy Objects részre.<br>
Új GPO-t kell létrehoznod → New (üres GPO).<br>
Az új GPO-n jobb klikk → Import Settings...<br>
Válaszd ki a mentett backup mappát.<br>
Kövesd a varázslót → Importálás.<br>
Fontos: a régi GPO-t nem lehet közvetlenül felülírni egy importálással – először vagy törlöd a régit, vagy új üres GPO-ba importálod és újralinkeled az OU-ra, Domain-re stb.<br>
<br>


## CMD parancsok

**hostname** - computer name<br>
**whoami** - name of the logged-in user<br>
**set** - check your path from the command line. Shows the path where MS Windows will execute commands.<br>
**ver** - OS version<br>
**systeminfo** - System Informations in details<br>
**cls** - Clears the Command Prompt screen.<br>
**ipconfig** /all /renew /release /displaydns /flushdns <br>
**tracert** example.com<br>
**nslookup** google.com - looks up a host or domain and returns its IP address<br>
**netstat** - displays current network connections and listening ports. A basic netstat command with no arguments will show you established connections<br>
  -a displays all established connections and listening ports<br>
  -b shows the program associated with each listening port and established connection <br>
  -o reveals the process ID (PID) associated with the connection<br>
  -n uses a numerical form for addresses and port numbers<br>
**dir** /a - Displays hidden and system files as well.<br>
**dir** /s - Displays files in the current directory and all subdirectories.<br>
**tree** - visually represent the child directories and subdirectories.<br>
**mkdir** directory_name - create a directory<br>
**rmdir** directory_name - delete a directory<br>
**type** - show the contents of the text file on the screen<br>
**more** : show long text<br>
**tasklist** - list the running processes<br>
-- tasklist /FI "imagename eq sshd.exe"  -  set the filter image name equals sshd.exe<br>
**taskkill** /PID target_pid  - kill the process with PID 4567, the command: taskkill /PID 4567<br>
**net user** : list users<br>
-- net user ujfelhasznalo<br>
-- net user ujfelhasznalo jelszo /add<br>
**net localgroup** administrators  : list users in admin group<br>
-- net localgroup administrators ujfelhasznalo /add<br>
**net group** /domain  - list all group in domain<br>
-- net group "CsoportNeve" /domain  - list group members<br>
-- net group "CsoportNeve" felhasznalonev /add /domain  - add user to group<br>
-- net group "CsoportNeve" felhasznalonev /delete /domain  -delete user from group<br>
-- net group "UjCsoport" /add /domain  - new group<br>
-- net group "CsoportNeve" /delete /domain  - delete group<br>
**dir** C:\secret.txt /s /p  : /s recursive search in subfolders, /p pauses after screen is full.<br>
-- /O : List by files in sorted order. sortorder:  |  N  By name (alphabetic)  | S  By size (smallest first) |  E  By extension (alphabetic)<br>
-- D  By date/time (oldest first) |  G  Group directories first  |  - (minus) Prefix to reverse order<br>
<br>

## PowerShell parancsok

**Get-FileHash** FILE  --- (Linux) $ sha256sum FILE  --- $ md5sum FILE<br>
-- Get-FileHash -Algorithm MD5 FILE<br>
-- Get-FileHash -Algorithm SHA256 FILE<br>
**Measure-Object** [-Property] <string> [-Sum] [-Average] [-Minimum] [-Maximum] [-InputObject <PSObject>] <br>
-- Get-Content C:\path\to\file.txt | Measure-Object -Line  ---  szövegfájl sorainak megszámolása <br>
**Get-ChildItem** C:\path\to\logs\*.log | Measure-Object -Property Length -Sum  --- egy mappában lévő összes .log fájl méretének kiszámolása <br>
Get-Process | Select-Object Name, Id, Path, StartTime  ---  Összes futó folyamat kilistázása <br>
Get-WmiObject Win32_Process | Select-Object ProcessId, ParentProcessId, Name, CommandLine  --- Gyanús parent-child folyamat kapcsolatok <br>
Get-Process | Where-Object { $_.Path -and !(Get-AuthenticodeSignature $_.Path).Status -eq 'Valid' }  --- Olyan futó processzek, amelyek NEM digitálisan aláírtak <br>
Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, OwningProcess  ---  Aktív hálózati kapcsolatok kilistázása <br>
Get-NetTCPConnection | ForEach-Object {<br>
    $_ | Add-Member -MemberType NoteProperty -Name "ProcessName" -Value (Get-Process -Id $_.OwningProcess).Name -Force <br>
    $_<br>
} | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, ProcessName<br>
Get-LocalUser | Where-Object { $_.WhenCreated -gt (Get-Date).AddDays(-7) }  ---   helyi felhasználók, akik az elmúlt 7 napban lettek létrehozva <br>
Get-LocalGroupMember -Group "Administrators" <br>
Get-ChildItem -Path "C:\Windows\System32" -Recurse | Where-Object { $_.LastWriteTime -gt (Get-Date).AddDays(-3) }  --- Fájlrendszer gyanús változásai: Új vagy frissített fájlok keresése a rendszerkönyvtárban <br>
Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4625} -MaxEvents 20 | Format-Table TimeCreated, Message  ---  Sikertelen login kísérletek → brute-force próbálkozás jele. <br>
Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4688} -MaxEvents 20 | Format-Table TimeCreated, Message  ---  Új process indítások listázása a Security logból. <br>
Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" | Format-Table TimeCreated, Message -AutoSize  --- PowerShell parancsok futtatásának naplózása <br>
Get-ScheduledTask | Where-Object {$_.State -eq 'Ready'} | Select-Object TaskName, TaskPath, Actions  --- Scheduled Tasks kilistázása <br>
Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" <br>
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"  --- Registry "Run" kulcsok vizsgálata, Automatikusan induló programok nyomai. <br>
<br>

## Sysinternals

[Letöltés](https://learn.microsoft.com/en-us/sysinternals/downloads/sysinternals-suite)

- **Sigcheck** : command-line utility that shows file version number, timestamp information, and digital signature details, including certificate chains. It also includes an option to check a file’s status on VirusTotal<br>
Use Case: Check for unsigned files in C:\Windows\System32 <br>
Command: sigcheck -u -e C:\Windows\System32 <br>
- **Streams** C:\path\to\file.txt or streams -s C:\path\to\folder  : NTFS alternatív adatfolyamok (ADS) kimutatására; :hiddenstream:$DATA 1234 <br>
:hiddenstream → az alternatív adatfolyam neve; 1234 → az adatfolyam mérete bájtban <br>
Get-Item -Path .\file.txt -stream * <br>
Get-Content -Path .\file.txt -stream includedfile.txt <br>
- [TCPView](./tcpview.pdf) <br>
- **Strings** .\file.exe | findstr /i zoom*  --- kilistáz minden olvasható karakterláncot (ASCII és opcionálisan Unicode) megkeresi azokat a sorokat, amelyek tartalmazzák a zoom szót, /i → kis- és nagybetű érzéketlen keresés <br>
findstr /i /c:"zoom meeting"  --- /c:"szöveg"	Pontos szöveg keresése (szóközös keresésnél hasznos) <br>
strings .\payload.exe | findstr /i "http https ftp" --- Keresni minden gyanús URL-t egy binárisban <br>
strings .\payload.exe | findstr /r "[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*" --- Keresni IP-cím mintákat <br>
- **Process Explorer**
- **Process Monitor**
- **Process Hacker**
