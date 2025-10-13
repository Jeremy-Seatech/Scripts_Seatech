# Chemin vers le fichier CSV export complet de RDM
$inputCsv = "C:\Source de données locale.csv"
# Chemin vers le fichier Ansible hosts à générer
$outputFile = "C:\ansible_hosts.ini"

# Fonction récursive pour écrire les groupes hiérarchiques
function Write-Group {
    param (
        [string[]]$groups,
        [int]$index,
        [hashtable]$groupData,
        [ref]$content
    )

    $currentGroup = $groups[$index]

    # Construire la section Ansible [groupname]
    if ($index -eq ($groups.Length - 1)) {
        $content.Value += "[$currentGroup]`n"
        foreach ($entry in $groupData[$currentGroup]) {
            $line = $entry.Host
            if ($entry.PSObject.Properties.Name -contains "User" -and $entry.User) {
                $line += " ansible_user=$($entry.User)"
            }
            if ($entry.PSObject.Properties.Name -contains "Port" -and $entry.Port) {
                $line += " ansible_port=$($entry.Port)"
            }
            $content.Value += $line + "`n"
        }
        $content.Value += "`n"
    }
    else {
        # Regrouper les hôtes par sous-groupes
        $subGroups = @{}
        foreach ($entry in $groupData[$currentGroup]) {
            $subGroupName = ($entry.GroupParts)[$index + 1]
            if (-not $subGroups.ContainsKey($subGroupName)) {
                $subGroups[$subGroupName] = @()
            }
            $subGroups[$subGroupName] += $entry
        }
        foreach ($subKey in $subGroups.Keys) {
            Write-Group -groups $groups -index ($index + 1) -groupData $subGroups -content $content
        }
    }
}

# Importer le CSV
$entries = Import-Csv -Path $inputCsv

# Ajout d'une colonne groupe sous forme d'array split sur séparateur de groupe.  
# Changez le séparateur ici selon votre export, souvent "\" ou "/"
$separator = "\" 

foreach ($entry in $entries) {
    $entry | Add-Member -MemberType NoteProperty -Name GroupParts -Value ($entry.Group -split [regex]::Escape($separator))
}

# Regrouper par premier niveau de groupe
$topGroups = $entries | Group-Object -Property { ($_.GroupParts)[0] }

# Initialiser variable content
$content = ""

# Appel de la fonction pour chaque groupe racine
foreach ($tg in $topGroups) {
    $groupData = @{}
    $groupData[$tg.Name] = $tg.Group
    Write-Group -groups $tg.Name.Split($separator) -index 0 -groupData $groupData -content ([ref]$content)
}

# Écrire le contenu dans le fichier
$content | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "Fichier d'inventaire Ansible généré avec groupes hiérarchiques : $outputFile"

