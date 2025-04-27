# Windows admin jegyzet

## CMD parancsok

hostname - computer name<br>
whoami - name of the logged-in user<br>
set - check your path from the command line. Shows the path where MS Windows will execute commands.<br>
ver - OS version<br>
systeminfo - System Informations in details<br>
cls - Clears the Command Prompt screen.<br>
ipconfig /all /renew /release /displaydns /flushdns <br>
tracert example.com<br>
nslookup google.com - looks up a host or domain and returns its IP address<br>
netstat - displays current network connections and listening ports. A basic netstat command with no arguments will show you established connections<br>
  -a displays all established connections and listening ports<br>
  -b shows the program associated with each listening port and established connection<br>
  -o reveals the process ID (PID) associated with the connection<br>
  -n uses a numerical form for addresses and port numbers<br>
dir /a - Displays hidden and system files as well.<br>
dir /s - Displays files in the current directory and all subdirectories.<br>
tree - visually represent the child directories and subdirectories.<br>
mkdir directory_name - create a directory<br>
rmdir directory_name - delete a directory<br>
type - show the contents of the text file on the screen<br>
more - show long text<br>
tasklist - list the running processes<br>
  - tasklist /FI "imagename eq sshd.exe"  -  set the filter image name equals sshd.exe<br>
taskkill /PID target_pid  - kill the process with PID 4567, the command: taskkill /PID 4567<br>
net user - list users<br>
  - net user ujfelhasznalo<br>
  - net user ujfelhasznalo jelszo /add<br>
net localgroup administrators  - list users in admin group<br>
  - net localgroup administrators ujfelhasznalo /add<br>
net group /domain  - list all group in domain<br>
  - net group "CsoportNeve" /domain  - list group members<br>
  - net group "CsoportNeve" felhasznalonev /add /domain  - add user to group<br>
  - net group "CsoportNeve" felhasznalonev /delete /domain  -delete user from group<br>
  - net group "UjCsoport" /add /domain  - new group<br>
  - net group "CsoportNeve" /delete /domain  - delete group<br>
