# Migration sécurisée vers une architecture Cloud hybride

Projet du module M352 "Sécurité de la virtualisation et du Cloud Computing" (ENSIASD), groupe G5, sous-groupe A, sujet 6.
Migration progressive d'un SI local vers Oracle Cloud, avec les données sensibles gardées sur site et un tunnel WireGuard chiffré entre les deux.

## Architecture cible

![Architecture](docs/architecture.png)

- Côté Oracle Cloud : un VCN avec un sous-réseau public (VM1) et un sous-réseau privé (VM2).
- Côté site (VMware) : OPNsense protège la zone Utilisateurs (ADMIN-SITE) et la zone Données (SRV-DATA).
- Le tunnel WireGuard (réseau `10.8.0.0/24`, serveur VM1 `10.8.0.1`, client OPNsense `10.8.0.2`, UDP 51820) est le seul lien entre le site et le cloud.
- Ports ouverts sur Internet : 443 (HTTPS, le port 80 redirige vers 443) et 51820/udp. SSH uniquement depuis l'IP de l'administrateur.

Le schéma montre les plages prévues au départ. Les plages réellement utilisées sont celles du tableau ci-dessous.

## Machines

| Nom | Emplacement | Adressage | Rôle | État |
|-----|-------------|-----------|------|------|
| VM1 edge (`ocinstance`) | Oracle, sous-réseau public | `10.0.0.0/24` | Nginx + serveur WireGuard, seule IP publique | En service |
| VM2 app-int | Oracle, sous-réseau privé | `10.0.1.0/24` | Intranet, pas d'IP publique | Bloquée (capacité Ampere A1) |
| OPNsense | VMware | LAN `192.168.10.1`, Données `192.168.20.1` | Pare-feu du site + client WireGuard | En service |
| ADMIN-SITE | VMware, zone Utilisateurs | `192.168.10.10` | Poste d'administration (Xubuntu) | En service |
| SRV-DATA | VMware, zone Données | `192.168.20.10` | PostgreSQL, disque chiffré LUKS | À installer |

## Plan de migration

1. Vague 1 : les services exposés passent sur VM1.
2. Vague 2 : les services internes passent sur VM2.
3. Vague 3 : les données sensibles restent sur site, accessibles uniquement depuis VM2 via le tunnel (port 5432).

Solution de secours : si Oracle Cloud est indisponible, VM1 et VM2 sont recréées dans VMware.

## Avancement

Point au 24 novembre 2026. Détails dans [docs/avancement.md](docs/avancement.md), captures dans [preuves/](preuves/README.md).

| Partie | État |
|--------|------|
| Machines | VM1 OCI et site VMware (OPNsense, ADMIN-SITE) en service ; VM2 bloquée par la capacité OCI |
| Réseau | Sous-réseaux OCI et réseaux VMware en place ; ADMIN-SITE atteint OPNsense |
| WireGuard | Serveur et pairs configurés sur un environnement de test, à porter sur OCI |
| Données | SRV-DATA à installer |
| Services exposés | Nginx en HTTPS (certificat autosigné) devant une application web Python, sur l'environnement de test |

## Contenu du dépôt

| Dossier | Contenu |
|---------|---------|
| [configs/](configs/) | Configurations Nginx, WireGuard, service systemd et données fictives |
| [docs/](docs/) | Schéma d'architecture, avancement, procédures WireGuard |
| [preuves/](preuves/README.md) | Captures d'écran rangées par partie |
| [tests/](tests/tests.md) | Tests à réaliser et résultats attendus |

## Technologies

Oracle Cloud, VMware, OPNsense, WireGuard, Nginx, PostgreSQL, LUKS.

## Équipe

| Membre | Rôle |
|--------|------|
| Haitam BELCAIDA (coordinateur) | Coordination et architecture, choix des outils et technologies, rapport, présentation, dépôt Git |
| Mohammed ELFADLAOUI | Création des VM (Oracle Cloud et VMware) |
| Issam ELBAY | PostgreSQL et chiffrement LUKS sur SRV-DATA |
| Marouane BEKKAOUI | VCN, sous-réseaux, Security Lists, règles OPNsense |
| Abderemane ABDALLAH | Tunnel WireGuard |
| Hajar LAQLIB | Tests et preuves |

## Sécurité du dépôt

Dépôt public : aucune clé privée, aucune IP publique réelle, uniquement des valeurs fictives (`<PRIVATE_KEY>`, `<VM1_PUBLIC_IP>`, etc.).
