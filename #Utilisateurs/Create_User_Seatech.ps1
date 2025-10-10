$Nom = "seatech"
$MotDePasse = "seatech" | ConvertTo-SecureString -AsPlainText -Force
$Description = "Utilisateur limité seatech créé"

New-LocalUser -Name $Nom -Password $MotDePasse -Description $Description -UserMayNotChangePassword
Add-LocalGroupMember -Group "Utilisateurs" -Member $Nom