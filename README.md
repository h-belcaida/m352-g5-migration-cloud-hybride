# Migration sécurisée vers une architecture Cloud hybride

Projet du module M352 "Sécurité de la virtualisation et du Cloud Computing" (ENSIASD), groupe G5, sous-groupe A, sujet 6.
Migration progressive d'un SI local vers Oracle Cloud, avec les données sensibles gardées sur site et un tunnel WireGuard chiffré entre les deux.

## Architecture cible

![Architecture](docs/architecture.png)

- Côté Oracle Cloud : un VCN avec un sous-réseau public (VM1) et un sous-réseau privé (VM2).
- Côté site (VMware) : OPNsense protège la zone données où se trouve SRV-DATA.
- Le tunnel WireGuard (VM1 10.99.0.1 <-> OPNsense 10.99.0.2, UDP 51820) est le seul lien entre le site et le cloud.
- Seuls les ports 80 et 51820 sont ouverts sur Internet ; SSH est autorisé uniquement depuis l'IP de l'administrateur.

## Machines prévues

| Nom | Emplacement | Rôle |
|-----|-------------|------|
| VM1 edge | Oracle, sous-réseau public 10.0.1.0/24 | Nginx + serveur WireGuard, seule IP publique |
| VM2 app-int | Oracle, sous-réseau privé 10.0.2.0/24 | Intranet, pas d'IP publique |
| OPNsense | VMware | Pare-feu du site + client WireGuard |
| SRV-DATA | VMware, 192.168.20.10 | PostgreSQL, disque chiffré LUKS |

## Plan de migration

1. Vague 1 : les services exposés passent sur VM1.
2. Vague 2 : les services internes passent sur VM2.
3. Vague 3 : les données sensibles restent sur site, accessibles uniquement depuis VM2 via le tunnel (port 5432).

Solution de secours : si Oracle Cloud est indisponible, VM1 et VM2 sont recréées dans VMware.

## Avancement de la virtualisation et des systèmes

Au 24 novembre, VM1 OCI est en service et le site VMware permet d’atteindre la page de connexion OPNsense depuis ADMIN-SITE. La création de VM2 OCI est bloquée par la capacité Ampere A1. SRV-DATA et le secours VMware restent à préparer.

[Travaux de Mohammed ELFADLAOUI et écarts d’adressage](docs/avancement-mohammed.md) · [Index des preuves](preuves/README.md#contribution-de-mohammed-elfadlaoui)

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

Dépôt public : aucune clé, aucune IP réelle, uniquement des valeurs fictives (`<PRIVATE_KEY>`, `<VM1_PUBLIC_IP>`, etc.).
