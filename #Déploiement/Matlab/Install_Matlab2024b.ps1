# Script PowerShell 64 bits corrigé pour installation silencieuse MATLAB 2024b
$setupPath = "C:\install\setup.exe"
$configPath = "C:\install\installer_input.txt"

# Correction de la condition avec parenthèses autour de chaque Test-Path
if ((Test-Path $setupPath) -and (Test-Path $configPath)) {
    # Ajout des guillemets échappés pour les chemins avec espaces
    Start-Process -FilePath $setupPath -ArgumentList "-inputFile `"$configPath`"" -Wait
} else {
    Write-Error "Fichiers d'installation manquants"
}