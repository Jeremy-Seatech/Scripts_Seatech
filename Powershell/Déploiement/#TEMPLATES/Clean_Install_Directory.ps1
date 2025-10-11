# Script pour supprimer le dossier C:\install
$folderPath = "C:\install"

# Vérifie si le dossier existe
if (Test-Path $folderPath) {
    # Supprime le dossier et son contenu
    Remove-Item -Path $folderPath -Recurse -Force
    Write-Host "Le dossier $folderPath a été supprimé avec succès."
} else {
    Write-Host "Le dossier $folderPath n'existe pas."
}