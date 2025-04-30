=== BACKUP EREDETI DEFAULT GPO-K ===
$backupOriginalPath = "C:\GPOs_Original_Backup"
New-Item -ItemType Directory -Path $backupOriginalPath -Force | Out-Null

Write-Host "Backup: Default Domain Policy"
Backup-GPO -Name "Default Domain Policy" -Path $backupOriginalPath

Write-Host "Backup: Default Domain Controllers Policy"
Backup-GPO -Name "Default Domain Controllers Policy" -Path $backupOriginalPath

# === BASELINE RESTORE ===
$baselinePath = "C:\GPOs\Defaults"

Write-Host "Restoring Default Domain Policy from baseline"
Restore-GPO -Name "Default Domain Policy" -Path "$baselinePath\DefaultDomainPolicy"

Write-Host "Restoring Default Domain Controllers Policy from baseline"
Restore-GPO -Name "Default Domain Controllers Policy" -Path "$baselinePath\DefaultDomainControllersPolicy"



$utvonal = "C:\GPOs"


New-ADOrganizationalUnit -Name "Win10" -Path "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -description Parent -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "Win11" -Path "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -description Parent -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "DomainServers" -Path "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -description Parent -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "ADFS" -Path "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -description Parent -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "WAP" -Path "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -description Parent -ProtectedFromAccidentalDeletion $false


$pcwin10 = Get-ADComputer -Filter {operatingsystem -Like "Windows 10*"}
$pcwin11 = Get-ADComputer -Filter {operatingsystem -Like "Windows 11*"}
$pcw2022 = Get-ADComputer -Filter {operatingsystem -Like "Windows Server*"}


foreach($item in $pcwin10)
{
 move-ADObject -Identity $item -TargetPath 'OU=Win10,DC=int,DC=beg,DC=01,dc=berylia,dc=org'
}

foreach($item in $pcwin11)
{
 move-ADObject -Identity $item -TargetPath 'OU=Win11,DC=int,DC=beg,DC=01,dc=berylia,dc=org'
}

foreach($item in $pcw2022)
{
move-ADObject -Identity $item -TargetPath 'OU=DomainServers,DC=int,DC=beg,DC=01,dc=berylia,dc=org'
}

#$wap=get-adcomputer -filter {(dnshostname -like "*WAP*")}

#$adfs=get-adcomputer -filter {(dnshostname -like "*ADFS*")}


#foreach($item in $wap)
#{move-adobject -identity $item -targetpath 'OU=wap,DC=int,DC=beg,DC=01,dc=berylia,dc=org'}

#foreach($item in $adfs)
#{move-adobject -identity $item -targetpath 'OU=adfs,DC=int,DC=beg,DC=01,dc=berylia,dc=org'}

$dc = Get-ADComputer -Filter {dNSHostName -Like "DC*"}

foreach($item in $dc)
{
  move-ADObject -Identity $item -TargetPath 'OU=Domain Controllers,DC=int,DC=beg,DC=01,dc=berylia,dc=org'
}

New-GPO -Name "GPO-OutBond_FW_ALL"
New-GPO -Name "GPO-DC-FW-beg"
#New-GPO -Name "GPO-WAP-FW-beg"
#New-GPO -Name "GPO-ADFS-FW-beg"
#New-GPO -Name "GPO-DefaultDomainControllerPolicy"
#New-GPO -Name "GPO-DefaultDomainPolicy-beg"
New-GPO -Name "GPO-EG-Applocker-10-beg"
New-GPO -Name "GPO-EG-Applocker-11-beg"
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


$domain="berylia.org"

Import-GPO -TargetName "GPO-OutBond_FW_ALL" -BackupGpoName "GPO-OutBond_FW_ALL" -Path $utvonal\GPO-OutBond_FW_ALL
Import-GPO -TargetName "GPO-DC-FW-beg" -BackupGpoName "GPO-DC-FW-beg" -Path $utvonal\GPO-DC-FW-beg
#Import-GPO -TargetName "GPO-WAP-FW-beg" -BackupGpoName "GPO-WAP-FW-beg" -Path $utvonal\GPO-WAP-FW-beg
#Import-GPO -TargetName "GPO-ADFS-FW-beg" -BackupGpoName "GPO-ADFS-FW-beg" -Path $utvonal\GPO-ADFS-FW-beg
Import-GPO -TargetName "GPO-DefaultDomainControllerPolicy"  -BackupGpoName "GPO-DefaultDomainControllerPolicy" -Path $utvonal\GPO-DefaultDomainControllerPolicy
Import-GPO -TargetName "GPO-DefaultDomainPolicy-beg"  -BackupGpoName "GPO-DefaultDomainPolicy-beg" -Path $utvonal\GPO-DefaultDomainPolicy-beg
Import-GPO -TargetName "GPO-EG-Applocker-10-beg"  -BackupGpoName "GPO-EG-Applocker-10-beg" -Path $utvonal\GPO-EG-Applocker-10-beg
Import-GPO -TargetName "GPO-EG-Applocker-11-beg"  -BackupGpoName "GPO-EG-Applocker-11-beg" -Path $utvonal\GPO-EG-Applocker-11-beg
Import-GPO -TargetName "GPO-EG-Applocker-DS"  -BackupGpoName "GPO-EG-Applocker-DS" -Path $utvonal\GPO-EG-Applocker-DS
Import-GPO -TargetName "GPO-W10-11"  -BackupGpoName "GPO-W10-11" -Path $utvonal\GPO-W10-11
Import-GPO -TargetName "GPO-User-W10-11" -BackupGpoName "GPO-User-W10-11" -Path $utvonal\GPO-User-W10-11
Import-GPO -TargetName "GPO-MemberServerPolicy" -BackupGpoName "GPO-MemberServerPolicy" -Path $utvonal\GPO-MemberServerPolicy

Import-GPO -TargetName "GPO-edge"  -BackupGpoName "DoD Microsoft Edge STIG Computer v1r1" -Path $utvonal\GPO-edge
Import-GPO -TargetName "GPO-chrome"  -BackupGpoName "DoD Google Chrome STIG Computer v2r2" -Path $utvonal\GPO-chrome
Import-GPO -TargetName "GPO-office-Access"  -BackupGpoName "DoD Access 2016 STIG User v1r1" -Path $utvonal\GPO-office-Access
Import-GPO -TargetName "GPO-office-excel"  -BackupGpoName "DoD Excel 2016 STIG User v1r2" -Path $utvonal\GPO-office-excel
Import-GPO -TargetName "GPO-office-outlook"  -BackupGpoName "DoD Outlook 2016 STIG User v2r1" -Path $utvonal\GPO-office-outlook
Import-GPO -TargetName "GPO-office-powerpoint"  -BackupGpoName "DoD PowerPoint 2016 STIG User v1r1" -Path $utvonal\GPO-office-powerpoint
Import-GPO -TargetName "GPO-office-project"  -BackupGpoName "DoD Project 2016 STIG User v1r1" -Path $utvonal\GPO-office-project
Import-GPO -TargetName "GPO-office-publisher"  -BackupGpoName "DoD Publisher 2016 STIG User v1r3" -Path $utvonal\GPO-office-publisher
Import-GPO -TargetName "GPO-office-visio"  -BackupGpoName "DoD Visio 2016 STIG User v1r1" -Path $utvonal\GPO-office-visio
Import-GPO -TargetName "GPO-office-word"  -BackupGpoName "DoD Word 2016 STIG User v1r1" -Path $utvonal\GPO-office-word
Import-GPO -TargetName "GPO-office-onedrive-c"  -BackupGpoName "DoD OneDrive for Business 2016 STIG Computer v2r1" -Path $utvonal\GPO-office-onedrive-c
Import-GPO -TargetName "GPO-office-onedrive-u"  -BackupGpoName "DoD OneDrive for Business 2016 STIG User v2r1" -Path $utvonal\GPO-office-onedrive-u
Import-GPO -TargetName "GPO-office-skype-c"  -BackupGpoName "DoD Skype for Business 2016 STIG Computer v1r1" -Path $utvonal\GPO-office-skype-c
Import-GPO -TargetName "GPO-office-u"  -BackupGpoName "DoD Office System 2016 STIG User v1r1" -Path $utvonal\GPO-office-u
Import-GPO -TargetName "GPO-office-c"  -BackupGpoName "DoD Office System 2016 STIG Computer v1r1" -Path $utvonal\GPO-office-c
Import-GPO -TargetName "GPO-Adobe-c"  -BackupGpoName "DoD Adobe Acrobat Pro DC Classic STIG Computer v1r3" -Path $utvonal\GPO-Adobe-c
Import-GPO -TargetName "GPO-Adobe-u"  -BackupGpoName "DoD Adobe Acrobat Pro DC Classic STIG User v1r3" -Path $utvonal\GPO-Adobe-u
Import-GPO -TargetName "GPO-IE-u"  -BackupGpoName "DoD Internet Explorer 11 STIG User v1r19" -Path $utvonal\GPO-IE-u
Import-GPO -TargetName "GPO-IE-c"  -BackupGpoName "DoD Internet Explorer 11 STIG Computer v1r19" -Path $utvonal\GPO-IE-c


New-GPLink -Name "GPO-OutBond_FW_ALL" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no -Order 1
New-GPLink -Name "GPO-DC-FW-beg" -Domain $domain -Target "ou=Domain Controllers,DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
#New-GPLink -Name "GPO-WAP-FW-beg" -Domain $domain -Target "ou=WAP,DC=int,DC=beg,DC=22,dc=berylia,dc=org" -LinkEnabled no
#New-GPLink -Name "GPO-ADFS-FW-beg" -Domain $domain -Target "ou=ADFS,DC=int,DC=beg,DC=22,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-DefaultDomainControllerPolicy" -Domain $domain -Target "OU=Domain Controllers,DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no -Order 1
New-GPLink -Name "GPO-DefaultDomainPolicy-beg" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no -Order 1
New-GPLink -Name "GPO-EG-Applocker-10-beg" -Domain $domain -Target "ou=win10,DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-EG-Applocker-11-beg" -Domain $domain -Target "ou=win11,DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-EG-Applocker-DS" -Domain $domain -Target "ou=Domain Controllers,DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-MemberServerPolicy" -Domain $domain -Target "ou=DomainServers,DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
#New-GPLink -Name "GPO-MemberServerPolicy" -Domain $domain -Target "ou=DMZservers,DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-User-W10-11" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-W10-11" -Domain $domain -Target "ou=win10,DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-W10-11" -Domain $domain -Target "ou=win11,DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no

New-GPLink -Name "GPO-edge" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-chrome" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-office-Access" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-office-excel" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-office-outlook" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-office-powerpoint" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-office-project" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-office-publisher" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-office-visio" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-office-word" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-office-onedrive-c" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-office-onedrive-u" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-office-skype-c" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-office-c" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-office-u" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-IE-u" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-IE-c" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-Adobe-u" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no
New-GPLink -Name "GPO-Adobe-c" -Domain $domain -Target "DC=int,DC=beg,DC=01,dc=berylia,dc=org" -LinkEnabled no