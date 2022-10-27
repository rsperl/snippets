import-module activedirectory
import-csv .\createusers.csv | % {New-ADUser -GivenName $_.GivenName -Surname $_.Surname -Name $_.Name -SamAccountName $_.SamAccountName -Description $_.Description -Path $_.Path -Enabled $True -UserPrincipalName $_.UPN -EmailAddress $_.UPN -AccountPassword (convertto-securestring $_.Password -AsPlainText -force) }


## where createusers.csv looks like
# Index,GivenName,Surname,Name,SamAccountName,UPN,Description,Path,Enabled,Password,PasswordNeverExpires,ChangePasswordAtLogon
# "0001","test","user0001","test user0001","user0001","test.user0001@domain.internal","test user0001","OU=Users,OU=TST,OU=SL1,DC=domain,DC=internal","$True","Orion123_","$True","$False"
# "0002","test","user0002","test user0002","user0002","test.user0002@domain.internal","test user0002","OU=Users,OU=TST,OU=SL1,DC=domain,DC=internal","$True","Orion123_","$True","$False"