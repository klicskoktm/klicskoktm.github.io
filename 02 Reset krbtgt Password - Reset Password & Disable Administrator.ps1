# This script must be run using the newly created domain admin user.

Import-Module ActiveDirectory

Add-Type -AssemblyName System.Web
$length = 32
$chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[]{}|;:,.<>?'

Add-ADGroupMember -Identity "Enterprise Admins" -Members "begdomadmhun1"
# First change of krbtgt account password
$password = -join ((1..$length) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
$securePassword = ConvertTo-SecureString -AsPlainText -Force -String $password
# Set-ADAccountPassword -Identity "krbtgt" -NewPassword $securePassword -Reset
# Set-ADAccountPassword -Identity "krbtgt" -Reset -NewPassword (ConvertTo-SecureString "Jelszo123ABC!" -AsPlainText -Force) -Server DC01
Set-ADAccountPassword -Identity "krbtgt" -Reset -NewPassword (ConvertTo-SecureString $securePassword -AsPlainText -Force) -Server DC01


# Second change of krbtgt account password
$password = -join ((1..$length) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
$securePassword = ConvertTo-SecureString -AsPlainText -Force -String $password
#Set-ADAccountPassword -Identity "krbtgt" -NewPassword $securePassword -Reset
Set-ADAccountPassword -Identity "krbtgt" -Reset -NewPassword (ConvertTo-SecureString $securePassword -AsPlainText -Force) -Server DC01


# First change of default Administrator account password
$password = -join ((1..$length) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
$securePassword = ConvertTo-SecureString -AsPlainText -Force -String $password
Set-ADAccountPassword -Identity "Administrator" -NewPassword $securePassword -Reset

# Second change of default Administrator account password
$password = -join ((1..$length) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
$securePassword = ConvertTo-SecureString -AsPlainText -Force -String $password
Set-ADAccountPassword -Identity "Administrator" -NewPassword $securePassword -Reset

# Remove Administrator account from groups
Remove-ADGroupMember -Identity "Domain Admins" -Members "Administrator" -Confirm:$false
Remove-ADGroupMember -Identity "Enterprise Admins" -Members "Administrator" -Confirm:$false
Remove-ADGroupMember -Identity "Group Policy Creator Owners" -Members "Administrator" -Confirm:$false
Remove-ADGroupMember -Identity "Schema Admins" -Members "Administrator" -Confirm:$false

# Disable Administrator account
Disable-ADAccount -Identity "Administrator"