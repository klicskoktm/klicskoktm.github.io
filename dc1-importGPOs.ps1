New-ADOrganizationalUnit -Name "Win10" -Path "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -description Parent -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "Win11" -Path "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -description Parent -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "DomainServers" -Path "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -description Parent -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "ADFS" -Path "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -description Parent -ProtectedFromAccidentalDeletion $false


$pcwin10 = Get-ADComputer -Filter {OperatingSystem -Like "Windows 10*"}
$pcwin11 = Get-ADComputer -Filter {OperatingSystem -Like "Windows 11*"}
$pcw2022 = Get-ADComputer -Filter {OperatingSystem -Like "Windows Server*"}

# Osszes DC lekerdezése – ok mindig az OU=Domain Controllers-ben vannak
$dcAccounts = Get-ADComputer -SearchBase "OU=Domain Controllers,DC=int,DC=beg,DC=01,dc=berylia,dc=org" -Filter * | Select-Object -ExpandProperty SamAccountName

# Win10 gepek athelyezese
foreach ($item in $pcwin10) {
    Move-ADObject -Identity $item -TargetPath 'OU=Win10,DC=int,DC=beg,DC=01,dc=berylia,dc=org'
}

# Win11 gepek athelyezése
foreach ($item in $pcwin11) {
    Move-ADObject -Identity $item -TargetPath 'OU=Win11,DC=int,DC=beg,DC=01,dc=berylia,dc=org'
}

# Csak nem-DC szerverek athelyezese
foreach ($item in $pcw2022) {
    if ($dcAccounts -notcontains $item.SamAccountName) {
        Move-ADObject -Identity $item -TargetPath 'OU=DomainServers,DC=int,DC=beg,DC=01,dc=berylia,dc=org'
    } else {
        Write-Host "Kihagyva DC gep: $($item.Name)"
    }
}
New-GPO -Name "GPO-DefaultDomainPolicy"
New-GPO -Name "GPO-DefaultDomainControllerPolicy"
New-GPO -Name "GPO-OutBond_FW_ALL"
New-GPO -Name "GPO-DC-FW"
New-GPO -Name "GPO-HUN-ADFS-FW"
New-GPO -Name "GPO-EG-Applocker-10"
New-GPO -Name "GPO-EG-Applocker-11"
New-GPO -Name "GPO-EG-Applocker-DS"
New-GPO -Name "GPO-MemberServerPolicy"
New-GPO -Name "GPO-User-W10-11"
New-GPO -Name "GPO-W10-11"
New-GPO -Name "GPO-edge"
New-GPO -Name "GPO-chrome"
New-GPO -Name "GPO-office-Access"
New-GPO -Name "GPO-office-excel"
New-GPO -Name "GPO-office-outlook"
New-GPO -Name "GPO-office-powerpoint"
New-GPO -Name "GPO-office-project"
New-GPO -Name "GPO-office-publisher"
New-GPO -Name "GPO-office-visio"
New-GPO -Name "GPO-office-word"
New-GPO -Name "GPO-office-onedrive-c"
New-GPO -Name "GPO-office-onedrive-u"
New-GPO -Name "GPO-office-skype-c"
New-GPO -Name "GPO-office-c"
New-GPO -Name "GPO-office-u"
New-GPO -Name "GPO-IE-u"
New-GPO -Name "GPO-IE-c"
New-GPO -Name "GPO-Adobe-u"
New-GPO -Name "GPO-Adobe-c"

$domain="int.beg.01.berylia.org"
$utvonal = "C:\GPOs"

Import-GPO -TargetName "GPO-DefaultDomainPolicy"  -BackupGpoName "GPO-DefaultDomainPolicy" -Path $utvonal
Import-GPO -TargetName "GPO-DefaultDomainControllerPolicy"  -BackupGpoName "GPO-DefaultDomainControllerPolicy" -Path $utvonal

Import-GPO -TargetName "GPO-OutBond_FW_ALL" -BackupGpoName "GPO-OutBond_FW_ALL" -Path $utvonal
Import-GPO -TargetName "GPO-DC-FW" -BackupGpoName "GPO-DC-FW" -Path $utvonal
#Import-GPO -TargetName "GPO-WAP-FW" -BackupGpoName "GPO-WAP-FW" -Path $utvonal
#Import-GPO -TargetName "GPO-ADFS-FW" -BackupGpoName "GPO-ADFS-FW" -Path $utvonal
Import-GPO -TargetName "GPO-EG-Applocker-10"  -BackupGpoName "GPO-EG-Applocker-10" -Path $utvonal
Import-GPO -TargetName "GPO-EG-Applocker-11"  -BackupGpoName "GPO-EG-Applocker-11" -Path $utvonal
Import-GPO -TargetName "GPO-EG-Applocker-DS"  -BackupGpoName "GPO-EG-Applocker-DS" -Path $utvonal
Import-GPO -TargetName "GPO-MemberServerPolicy" -BackupGpoName "GPO-MemberServerPolicy" -Path $utvonal
Import-GPO -TargetName "GPO-W10-11"  -BackupGpoName "GPO-W10-11" -Path $utvonal
Import-GPO -TargetName "GPO-User-W10-11" -BackupGpoName "GPO-User-W10-11" -Path $utvonal

Import-GPO -TargetName "GPO-edge"  -BackupGpoName "GPO-edge" -Path $utvonal
Import-GPO -TargetName "GPO-chrome"  -BackupGpoName "GPO-chrome" -Path $utvonal
Import-GPO -TargetName "GPO-office-Access"  -BackupGpoName "GPO-office-Access" -Path $utvonal
Import-GPO -TargetName "GPO-office-excel"  -BackupGpoName "GPO-office-excel" -Path $utvonal
Import-GPO -TargetName "GPO-office-outlook"  -BackupGpoName "GPO-office-outlook" -Path $utvonal
Import-GPO -TargetName "GPO-office-powerpoint"  -BackupGpoName "GPO-office-powerpoint" -Path $utvonal
Import-GPO -TargetName "GPO-office-project"  -BackupGpoName "GPO-office-project" -Path $utvonal
Import-GPO -TargetName "GPO-office-publisher"  -BackupGpoName "GPO-office-publisher" -Path $utvonal
Import-GPO -TargetName "GPO-office-visio"  -BackupGpoName "GPO-office-visio" -Path $utvonal
Import-GPO -TargetName "GPO-office-word"  -BackupGpoName "GPO-office-word" -Path $utvonal
Import-GPO -TargetName "GPO-office-onedrive-c"  -BackupGpoName "GPO-office-onedrive-c" -Path $utvonal
Import-GPO -TargetName "GPO-office-onedrive-u"  -BackupGpoName "GPO-office-onedrive-u" -Path $utvonal
Import-GPO -TargetName "GPO-office-skype-c"  -BackupGpoName "GPO-office-skype-c" -Path $utvonal
Import-GPO -TargetName "GPO-office-u"  -BackupGpoName "GPO-office-u" -Path $utvonal
Import-GPO -TargetName "GPO-office-c"  -BackupGpoName "GPO-office-c" -Path $utvonal
Import-GPO -TargetName "GPO-Adobe-c"  -BackupGpoName "GPO-Adobe-c" -Path $utvonal
Import-GPO -TargetName "GPO-Adobe-u"  -BackupGpoName "GPO-Adobe-u" -Path $utvonal
Import-GPO -TargetName "GPO-IE-u"  -BackupGpoName "GPO-IE-u" -Path $utvonal
Import-GPO -TargetName "GPO-IE-c"  -BackupGpoName "GPO-IE-c" -Path $utvonal

New-GPLink -Name "GPO-DefaultDomainPolicy" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes -Order 1
New-GPLink -Name "GPO-OutBond_FW_ALL" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes -Order 1
New-GPLink -Name "GPO-DC-FW" -Domain $domain -Target "ou=Domain Controllers,DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
#New-GPLink -Name "GPO-WAP-FW-beg" -Domain $domain -Target "ou=WAP,DC=int,DC=beg,DC=22,dc=berylia,dc=org" -LinkEnabled yes
#New-GPLink -Name "GPO-ADFS-FW-beg" -Domain $domain -Target "ou=ADFS,DC=int,DC=beg,DC=22,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-DefaultDomainControllerPolicy" -Domain $domain -Target "OU=Domain Controllers,DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes -Order 1
New-GPLink -Name "GPO-EG-Applocker-10" -Domain $domain -Target "ou=win10,DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-EG-Applocker-11" -Domain $domain -Target "ou=win11,DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-EG-Applocker-DS" -Domain $domain -Target "ou=Domain Controllers,DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-MemberServerPolicy" -Domain $domain -Target "ou=DomainServers,DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
#New-GPLink -Name "GPO-MemberServerPolicy" -Domain $domain -Target "ou=DMZservers,DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-User-W10-11" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-W10-11" -Domain $domain -Target "ou=win10,DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-W10-11" -Domain $domain -Target "ou=win11,DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes

New-GPLink -Name "GPO-edge" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-chrome" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-office-Access" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-office-excel" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-office-outlook" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-office-powerpoint" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-office-project" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-office-publisher" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-office-visio" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-office-word" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-office-onedrive-c" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-office-onedrive-u" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-office-skype-c" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-office-c" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-office-u" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-IE-u" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-IE-c" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-Adobe-u" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes
New-GPLink -Name "GPO-Adobe-c" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled yes