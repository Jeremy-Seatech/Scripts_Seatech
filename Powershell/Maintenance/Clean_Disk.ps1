# Exécuter le nettoyage de disque silencieusement
$cleanmgr = "cleanmgr.exe"
$args = "/sagerun:1"

# Lancer le processus de nettoyage
Start-Process -FilePath $cleanmgr -ArgumentList $args -Wait

# Afficher un message de confirmation
Write-Host "Le nettoyage de disque a été effectué avec succès."
