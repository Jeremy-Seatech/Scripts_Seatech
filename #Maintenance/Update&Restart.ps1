# Création de l'objet COM pour Windows Update
$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateUpdateSearcher()

# Recherche des mises à jour
Write-Host "Recherche des mises à jour..."
$SearchResult = $UpdateSearcher.Search("IsInstalled=0 and Type='Software' and IsHidden=0")

# Vérification si des mises à jour sont disponibles
if ($SearchResult.Updates.Count -eq 0) {
    Write-Host "Aucune mise à jour disponible."
    exit
}

# Affichage du nombre de mises à jour trouvées
Write-Host "Nombre de mises à jour trouvées : $($SearchResult.Updates.Count)"

# Création d'une collection pour les mises à jour à installer
$UpdatesToDownload = New-Object -ComObject Microsoft.Update.UpdateColl

# Ajout des mises à jour à la collection
foreach ($Update in $SearchResult.Updates) {
    $UpdatesToDownload.Add($Update) | Out-Null
    Write-Host "Ajout de la mise à jour : $($Update.Title)"
}

# Téléchargement des mises à jour
Write-Host "Téléchargement des mises à jour..."
$Downloader = $UpdateSession.CreateUpdateDownloader()
$Downloader.Updates = $UpdatesToDownload
$DownloadResult = $Downloader.Download()

# Installation des mises à jour
Write-Host "Installation des mises à jour..."
$Installer = $UpdateSession.CreateUpdateInstaller()
$Installer.Updates = $UpdatesToDownload
$InstallResult = $Installer.Install()

# Vérification si un redémarrage est nécessaire
if ($InstallResult.RebootRequired) {
    Write-Host "Un redémarrage est nécessaire pour terminer l'installation des mises à jour."
    # Décommentez la ligne suivante si vous voulez forcer le redémarrage
    Restart-Computer -Force
} else {
    Write-Host "Installation des mises à jour terminée. Aucun redémarrage nécessaire."
}