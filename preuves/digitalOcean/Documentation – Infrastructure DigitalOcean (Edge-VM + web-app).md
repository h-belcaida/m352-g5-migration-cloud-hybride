# Documentation – Infrastructure DigitalOcean (Edge-VM + web-app)

Documentation technique de la configuration réseau de deux Droplets DigitalOcean dans la région SFO2, reliés par un VPC privé et un tunnel WireGuard.

## 1. Vue d'ensemble

L'infrastructure se compose de deux machines virtuelles (Droplets) déployées dans le même VPC `default-sfo2` :

- **Edge-VM** : machine de bordure (edge), seule à posséder une adresse IP publique. Elle sert de point d'entrée.
- **web-app** : machine applicative, accessible uniquement depuis le réseau privé (« Private-only »). Elle n'est pas exposée directement sur Internet.

Cette architecture suit le principe classique d'un **bastion / reverse proxy** : seule la machine de bordure est exposée, et elle relaie le trafic vers le serveur applicatif via le réseau privé.

## 2. Schéma d'architecture

```
                    Internet
                       |
            157.230.154.180 (IP publique)
                       |
              +--------+---------+
              |     Edge-VM      |
              |  eth0  publique  |
              |  eth1  10.120.0.2|
              |  wg0   10.8.0.1  |
              +--------+---------+
                       |
        VPC default-sfo2 : 10.120.0.0/20
                       |
              +--------+---------+
              |     web-app      |
              |  eth0  10.120.0.3|
              |  wg0   10.8.0.3  |
              |  (aucune IP pub.)|
              +------------------+

   Tunnel WireGuard : 10.8.0.0/24 (Edge-VM <-> web-app)
```

## 3. Les Droplets

| Paramètre | Edge-VM | web-app |
| --- | --- | --- |
| Statut | Active | Active |
| RAM | 1 Go | 512 Mo |
| Disque | 25 Go | 10 Go |
| Région | SFO2 (San Francisco) | SFO2 (San Francisco) |
| Accès public | Oui | Non (Private-only) |
| Rôle | Passerelle / point d'entrée | Serveur applicatif |

## 4. Plan d'adressage réseau

### 4.1 Réseaux utilisés

| Réseau | Plage | Usage |
| --- | --- | --- |
| Réseau public DigitalOcean | 157.230.144.0/20 | Accès Internet de l'Edge-VM |
| VPC `default-sfo2` | 10.120.0.0/20 | Réseau privé entre les Droplets |
| Tunnel WireGuard | 10.8.0.0/24 | Réseau chiffré entre les machines |

### 4.2 Interfaces de l'Edge-VM

| Interface | Adresse | Rôle |
| --- | --- | --- |
| lo | 127.0.0.1/8 | Boucle locale |
| eth0 | 157.230.154.180/20 | IP publique (IPv4) |
| eth0 | 10.46.0.5/16 | Seconde adresse privée sur eth0 (voir remarque ci-dessous) |
| eth1 | 10.120.0.2/20 | IP privée dans le VPC |
| wg0 | 10.8.0.1/24 | Interface WireGuard |

Paramètres du réseau public :

- IP publique : `157.230.154.180`
- Passerelle publique : `157.230.144.1`
- Masque : `255.255.240.0` (/20)

### 4.3 Interfaces de web-app

| Interface | Adresse | Rôle |
| --- | --- | --- |
| lo | 127.0.0.1/8 | Boucle locale |
| eth0 | 10.120.0.3/20 | IP privée dans le VPC (seule interface réseau) |
| wg0 | 10.8.0.3/24 | Interface WireGuard |

web-app ne possède **aucune adresse publique** : son unique interface physique (eth0) est directement connectée au VPC.

## 5. VPC `default-sfo2`

- Plage IP : `10.120.0.0/20`, soit 4096 adresses (10.120.0.0 à 10.120.15.255).
- Seuls les membres du même VPC peuvent joindre un Droplet via son adresse privée.
- Adresses attribuées :
  - `10.120.0.2` : Edge-VM
  - `10.120.0.3` : web-app

## 6. Tunnel WireGuard

Les deux machines disposent d'une interface `wg0` (type point-à-point, MTU 1420) dans le sous-réseau `10.8.0.0/24` :

| Machine | Adresse WireGuard |
| --- | --- |
| Edge-VM | 10.8.0.1/24 |
| web-app | 10.8.0.3/24 |

Edge-VM est le serveur wireguard.

## 7. Connectivité entre les machines

Un test `ping web` lancé depuis l'Edge-VM confirme la communication via le VPC :

- Le nom `web` est résolu en `10.120.0.3` (adresse privée de web-app). Cette résolution provient d'une entrée dans `/etc/hosts`&#32;
- 3 paquets envoyés, 3 réponses reçues, sans perte.
- TTL = 64 : les machines sont sur le même réseau, sans routeur intermédiaire.
- Latence : de 0,39 ms à 2,31 ms (le premier paquet est plus lent, effet normal de la résolution ARP).

## 8. Accès sortant et entrant de web-app

La page réseau de web-app indique deux points importants :

- **Sortie vers Internet** : aucune *NAT Gateway* n'est configurée. Par conséquent, web-app n'a **pas d'accès sortant direct** à Internet (mises à jour `apt`, téléchargement de paquets, appels à des API externes).

## 9. Flux de trafic

1. Un client sur Internet contacte `157.230.154.180` (Edge-VM).
2. L'Edge-VM relaie la requête vers `10.120.0.3` (web-app) via le VPC, ou via le tunnel WireGuard `10.8.0.0/24`.
3. web-app répond à l'Edge-VM, qui renvoie la réponse au client.

La mise en place du relais (reverse proxy, redirection de ports, etc.) n'étant pas visible dans les captures, elle reste à documenter.

## 10. Commandes de vérification

```bash
# Nom de la machine et interfaces réseau
hostname && ip addr

# Test de connectivité vers web-app depuis l'Edge-VM
ping web
ping 10.120.0.3

# État du tunnel WireGuard
sudo wg show

# Table de routage
ip route
```

## 11. Points d'attention

- **Accès à web-app** : comme elle n'a pas d'IP publique, l'administration passe par l'Edge-VM (rebond SSH) ou par la console DigitalOcean.

## 12. Récapitulatif

| Élément | Valeur |
| --- | --- |
| Fournisseur / région | DigitalOcean, SFO2 |
| VPC | default-sfo2, 10.120.0.0/20 |
| IP publique Edge-VM | 157.230.154.180 |
| Passerelle publique | 157.230.144.1 |
| IP privée Edge-VM | 10.120.0.2 |
| IP privée web-app | 10.120.0.3 |
| WireGuard Edge-VM | 10.8.0.1/24 |
| WireGuard web-app | 10.8.0.3/24 |
| Test de connectivité | ping Edge-VM vers web-app : OK, moins de 3 ms |
