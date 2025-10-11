################ Définir les variables => EDIT $url & $zipFile ################

$destinationFolder = "C:\install"

#EDIT#
$url = "ftp://10.100.1.109:21/edupack.zip"
$zipFile = "$destinationFolder\edupack.zip"
#EDIT#

# Créer le dossier de destination s'il n'existe pas déjà
if (-not (Test-Path -Path $destinationFolder)) {
    New-Item -ItemType Directory -Path $destinationFolder | Out-Null
}




################ Configuration de la requête FTP & Download & Decompression ################

$ftpRequest = [System.Net.FtpWebRequest]::Create($url)
$ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::DownloadFile
$ftpRequest.UseBinary = $true
$ftpRequest.UsePassive = $true   # Essayez $false si problème de connexion
$ftpRequest.KeepAlive = $false

# Décommentez et adaptez si authentification nécessaire :
# $ftpRequest.Credentials = New-Object System.Net.NetworkCredential("nom_utilisateur", "mot_de_passe")

# Télécharger le fichier ZIP
try {
    $response = $ftpRequest.GetResponse()
    $responseStream = $response.GetResponseStream()
    $fileStream = [System.IO.File]::Create($zipFile)
    $buffer = New-Object byte[] 8192
    do {
        $read = $responseStream.Read($buffer, 0, $buffer.Length)
        if ($read -gt 0) {
            $fileStream.Write($buffer, 0, $read)
        }
    } while ($read -gt 0)
    $fileStream.Close()
    $responseStream.Close()
    $response.Close()
    Write-Host "Téléchargement terminé : $zipFile"
}
catch {
    Write-Error "Erreur lors du téléchargement : $_"
    exit 1
}

# Décompresser l'archive ZIP dans le dossier de destination
try {
    Expand-Archive -Path $zipFile -DestinationPath $destinationFolder -Force
    Write-Host "Extraction terminée."
    Remove-Item -Path $zipFile
} catch {
    Write-Error "Erreur lors de l'extraction : $_"
}




################ Installation silencieuse => EDIT "setup.exe -silent" ################

#EDIT
c:\install\setup.exe -silent -licserverinfo 2325:1055:pcmath12
#EDIT



################ Temporisation éventuelle avant suppression (Décommenter si besoin) ################

Start-Sleep -Seconds 600




################ Suppression du dossier C:\install ################

$folderPath = "C:\install"

# Vérifie si le dossier existe
if (Test-Path $folderPath) {
    # Supprime le dossier et son contenu
    Remove-Item -Path $folderPath -Recurse -Force
    Write-Host "Le dossier $folderPath a été supprimé avec succès."
} else {
    Write-Host "Le dossier $folderPath n'existe pas."
}




################ Mise a jour & Arret ################

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

# Arrêter la machine
Stop-Computer -Force