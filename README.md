Pour activer WinRM automatiquement sur un client Windows, il existe un script PowerShell officiel recommandé par la communauté Ansible : "ConfigureRemotingForAnsible.ps1". Ce script configure tous les paramètres nécessaires pour que ta machine Windows soit accessible à distance via Ansible, incluant l’activation du service WinRM, l’ouverture des ports du pare-feu, et la modification de politiques pour accepter la connexion.​

Utilisation du script automatique

Téléchargement :
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/AlbanAndrieu/ansible-windows/master/files/ConfigureRemotingForAnsible.ps1" -OutFile "ConfigureRemotingForAnsible.ps1"


Exécution (en administrateur) :
.\ConfigureRemotingForAnsible.ps1


Vérification :
Test-WSMan

Ce script gère :
L’activation du service WinRM.

L’ajout des règles de pare-feu pour les ports 5985 (HTTP) et 5986 (HTTPS).

L’autorisation d’utilisation de comptes locaux.

La configuration SSL si besoin.

La politique d’exécution PowerShell peut aussi devoir être modifiée :

text
Set-ExecutionPolicy RemoteSigned
Ceci permet d’automatiser la préparation du client Windows pour une administration via Ansible, sans configuration manuelle fastidieuse.​
