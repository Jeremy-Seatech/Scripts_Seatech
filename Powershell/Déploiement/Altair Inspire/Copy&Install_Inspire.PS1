################ Définir les variables => EDIT $url & $zipFile ################

$destinationFolder = "C:\install"

#EDIT#
$url = "ftp://10.100.1.109:21/AltairInspire2025.1_win64.zip"
$zipFile = "$destinationFolder\AltairInspire2025.1_win64.zip"
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
c:\install\AltairInspire2025.1_win64.exe -i silent -DACCEPT_EULA=YES -DUNINSTALL_EXISTING_INSTALLATION=YES
#EDIT


