# Avancement du projet

Point au 24 novembre 2026, organisé par partie. Les captures correspondantes sont répertoriées dans l'[index des preuves](../preuves/README.md).

## 1. Machines

### Oracle Cloud

- L'instance Ubuntu ARM64 `ocinstance` (VM1) est en service à Casablanca. Sa configuration a été ramenée de 2 OCPU / 12 Go à 1 OCPU / 6 Go pour libérer de la capacité pour VM2. Après redémarrage, la console OCI indique `Running` ; sur Ubuntu, `nproc` renvoie 1 et `free -h` affiche environ 5,8 Gio.
- La création de VM2 (Ubuntu Ampere A1, sous-réseau privé, sans IPv4 publique) a échoué avec `Out of capacity` sur `AD-1`. VM2 reste à déployer.
- L'accès SSH a été vérifié depuis Kali et Windows. Trois comptes SSH nominatifs, chacun avec sa propre clé, ont été créés et testés par les membres concernés.

### VMware (site on-premise)

- OPNsense est installé sur le disque virtuel ; ses interfaces ont été identifiées à partir des adresses MAC.
- `ADMIN-SITE` (Xubuntu) est relié à `VMnet2` avec une IPv4 statique.
- `SRV-DATA` reste à installer.

## 2. Réseau

Sous-réseaux observés dans le VCN `myvcn` : `10.0.0.0/24` (public) et `10.0.1.0/24` (privé). Ces plages diffèrent de celles du schéma d'architecture (`10.0.1.0/24` et `10.0.2.0/24`).

| Réseau VMware | Interface OPNsense | Usage et adressage |
|---|---|---|
| `VMnet8` (NAT) | WAN `em0` | Adresse obtenue par DHCP VMware |
| `VMnet2` (Host-only, sans DHCP) | LAN `em1` | OPNsense `192.168.10.1/24`, ADMIN-SITE `192.168.10.10/24` |
| `VMnet3` (Host-only, sans DHCP) | OPT1 `em2` | OPNsense `192.168.20.1/24`, zone Données |

## 3. Tunnel WireGuard

- Réseau du tunnel : `10.8.0.0/24`, port UDP 51820. Le serveur (`10.8.0.1`) déclare deux pairs : OPNsense (`10.8.0.2`) et la VM `web-app` (`10.8.0.3`). Voir [configs/wg-server.conf](../configs/wg-server.conf).
- Ce serveur et la VM `web-app` tournent actuellement sur un environnement de test DigitalOcean, pas encore sur OCI.
- Sur `ocinstance` (OCI), la procédure d'installation est documentée dans [wireguard-ocinstance.md](wireguard-ocinstance.md) ; la clé publique d'OPNsense y est encore en attente.

## 4. Données sensibles

Rien de déployé pour l'instant : `SRV-DATA` (PostgreSQL + LUKS, `192.168.20.10`) reste à installer sur `VMnet3`.

## 5. Tests

Depuis `ADMIN-SITE`, le ping vers OPNsense (`192.168.10.1`) répond 3 fois sur 3 et Firefox affiche la page de connexion OPNsense après l'alerte de certificat autosigné. L'accès au LAN du site est donc validé.

## 6. Services exposés (vague 1)

Sur la VM `Edge-VM` (environnement de test DigitalOcean) :

- Nginx écoute sur le port 80, qui redirige vers HTTPS (443) avec un certificat autosigné. Voir [configs/nginx.conf](../configs/nginx.conf).
- Nginx sert de reverse proxy vers une application web Python sur la VM `web-app` (port 5000), lancée par le service systemd `myapp`. Voir [configs/myAppService](../configs/myAppService).

## Reste à faire

- Installer `SRV-DATA` sur `VMnet3` (`192.168.20.10/24`) et tester la liaison avec OPNsense.
- Relancer le déploiement de VM2 sur OCI selon la capacité Ampere disponible.
- Porter Nginx et WireGuard de l'environnement de test vers OCI.
- Mettre en place le secours VMware pour la partie cloud et vérifier son démarrage.
