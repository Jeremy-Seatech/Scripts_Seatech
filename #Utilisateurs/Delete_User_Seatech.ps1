# Vérifie si l'utilisateur 'seatech' existe avant suppression
if (Get-LocalUser -Name "seatech" -ErrorAction SilentlyContinue) {
    # Supprime l'utilisateur 'seatech'
    Remove-LocalUser -Name "seatech"
    # Vérifie à nouveau si l'utilisateur existe
    if (-not (Get-LocalUser -Name "seatech" -ErrorAction SilentlyContinue)) {
        Write-Host "L'utilisateur 'seatech' a bien été supprimé."
    } else {
        Write-Host "Erreur : L'utilisateur 'seatech' n'a pas pu être supprimé."
    }
} else {
    Write-Host "L'utilisateur 'seatech' n'existe pas."
}