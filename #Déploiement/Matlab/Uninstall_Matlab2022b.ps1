$matlabRoot = "C:\Program Files\MATLAB\R2022b"
$uninstallExe = "$matlabRoot\uninstall\bin\win64\uninstall.exe"
$tempFolder = "C:\temp"
$inputFile = "$tempFolder\my_uninstall.txt"

# Créer le dossier temporaire s'il n'existe pas
if (-not (Test-Path -Path $tempFolder -PathType Container)) {
    New-Item -Path $tempFolder -ItemType Directory -Force
}

# Copier le fichier de configuration
Copy-Item "$matlabRoot\uninstall\uninstaller_input.txt" $inputFile -Force

# Modifier le fichier de configuration
Set-Content -Path $inputFile -Value @"
mode=silent
outputFile=$tempFolder\matlab_uninstall.log
"@

# Lancer la désinstallation silencieuse
Start-Process -FilePath $uninstallExe -ArgumentList "-inputFile $inputFile" -Wait

# Nettoyage final
Start-Sleep -Seconds 5
if (Test-Path $matlabRoot) {
    Remove-Item -Path $matlabRoot -Recurse -Force -ErrorAction SilentlyContinue
}