# Avancement de Mohammed ELFADLAOUI

Point au 24 novembre 2026. Je suis chargé de la virtualisation et des systèmes pour la maquette hybride du groupe G5.

## Oracle Cloud

- J’ai démarré l’instance Ubuntu ARM64 existante `ocinstance` à Casablanca. Pour libérer de la capacité pour VM2, j’ai ramené la configuration de 2 OCPU et 12 Go à 1 OCPU et 6 Go. Après redémarrage, la console OCI indique `Running`. Sur Ubuntu, `nproc` renvoie 1 et `free -h` affiche environ 5,8 Gio.
- J’ai relevé les sous-réseaux du VCN existant `myvcn`. Les plages observées sont `10.0.0.0/24` pour le sous-réseau public et `10.0.1.0/24` pour le sous-réseau privé. Le tableau d’architecture du README décrit les plages prévues dans le dépôt.
- J’ai tenté de créer la VM2 Ubuntu sur Ampere A1 dans le sous-réseau privé, sans IPv4 publique. OCI a renvoyé `Out of capacity` sur `AD-1`. La VM2 reste à déployer.
- J’ai vérifié mon accès SSH depuis Kali et Windows et créé trois comptes SSH nominatifs avec une clé individuelle. Les trois membres ont confirmé leur connexion. L’accès administrateur leur a été ouvert pour la durée du projet.

## Site VMware

| Réseau VMware | Interface OPNsense | Usage et adressage observés |
|---|---|---|
| `VMnet8` (NAT) | WAN `em0` | Adresse obtenue par DHCP VMware |
| `VMnet2` | LAN `em1` | OPNsense `192.168.10.1/24`, ADMIN-SITE `192.168.10.10/24` |
| `VMnet3` | OPT1 `em2` | OPNsense `192.168.20.1/24`, zone Données |

J’ai créé les deux réseaux Host-only sans DHCP VMware, installé OPNsense sur le disque virtuel et identifié les interfaces à partir des adresses MAC. J’ai ensuite installé Xubuntu sur `ADMIN-SITE`, relié cette VM à `VMnet2` et appliqué son IPv4 statique.

Depuis `ADMIN-SITE`, le ping vers `192.168.10.1` a donné trois réponses sur trois. Firefox a affiché la page de connexion OPNsense après l’alerte liée au certificat autosigné. Le test confirme l’accès au LAN et la disponibilité de la page de connexion.

## Reste à faire

- Installer `SRV-DATA` sur `VMnet3`, lui attribuer `192.168.20.10/24` et tester la liaison avec OPNsense.
- Relancer le déploiement de VM2 OCI selon la capacité Ampere disponible.
- Mettre en place le secours VMware prévu pour la partie cloud et vérifier son démarrage.

Les preuves sont répertoriées dans [l’index des captures](../preuves/README.md#contribution-de-mohammed-elfadlaoui).
