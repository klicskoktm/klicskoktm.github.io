# Windows admin jegyzet

## Parancsok

**msconfig** - System Configuration utility - Rendszerkonfiguráció <br>
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
  -b shows the program associated with each listening port and established connection<br>
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

## PowerShell parancsok

**Get-FileHash** FILE  --- (Linux) $ sha256sum FILE  --- $ md5sum FILE<br>
-- Get-FileHash -Algorithm MD5 FILE<br>
-- Get-FileHash -Algorithm SHA256 FILE<br>
**Measure-Object** [-Property] <string> [-Sum] [-Average] [-Minimum] [-Maximum] [-InputObject <PSObject>] <br>
-- Get-Content C:\path\to\file.txt | Measure-Object -Line  ---  szövegfájl sorainak megszámolása <br>
Get-ChildItem C:\path\to\logs\*.log | Measure-Object -Property Length -Sum  --- egy mappában lévő összes .log fájl méretének kiszámolása <br>

## Sysinternals

[Letöltés](https://learn.microsoft.com/en-us/sysinternals/downloads/sysinternals-suite)

- **Sigcheck** : command-line utility that shows file version number, timestamp information, and digital signature details, including certificate chains. It also includes an option to check a file’s status on VirusTotal<br>
Use Case: Check for unsigned files in C:\Windows\System32 <br>
Command: sigcheck -u -e C:\Windows\System32 <br>
- **Streams** C:\path\to\file.txt or streams -s C:\path\to\folder  : NTFS alternatív adatfolyamok (ADS) kimutatására; :hiddenstream:$DATA 1234 <br>
:hiddenstream → az alternatív adatfolyam neve; 1234 → az adatfolyam mérete bájtban <br>
Get-Item -Path .\file.txt -stream * <br>
Get-Content -Path .\file.txt -stream includedfile.txt <br>
- [TCPView](./tcpview.html)
