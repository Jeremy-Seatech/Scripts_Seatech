# Script PowerShell 64 bits - Supprime les profils locaux issus du domaine "CAMPUS"
# � ex�cuter en tant qu'administrateur

# Remplace cette valeur par le SID racine trouv� � l'�tape pr�c�dente
$DomainSID = "S-1-5-21-495494928-1333678342-1936946330"

Get-CimInstance Win32_UserProfile | Where-Object {
    $_.SID -like "$DomainSID-*" -and -not $_.Special -and -not $_.Loaded
} | ForEach-Object {
    try {
        $_ | Remove-CimInstance
        Write-Host "Profil supprim� : $($_.LocalPath) ($($_.SID))" -ForegroundColor Green
    } catch {
        Write-Warning "Impossible de supprimer le profil : $($_.LocalPath) ($($_.SID)) - $($_.Exception.Message)"
    }
}