# Preuves

Mettez chaque capture d'écran dans le dossier de la partie concernée et floutez les IP publiques, les clés et les noms de comptes.

| Dossier | Partie |
|---------|--------|
| `1-machines/` | Création des VM (Oracle Cloud et VMware) |
| `2-reseau/` | VCN, sous-réseaux, Security Lists, règles OPNsense |
| `3-wireguard/` | Tunnel WireGuard |
| `4-donnees/` | PostgreSQL et chiffrement LUKS sur SRV-DATA |
| `5-tests/` | Résultats des tests de `tests/tests.md` |
| `6-services/` | Services exposés : Nginx, HTTPS, application web |

## 1. Machines

| Vérification | Captures |
|---|---|
| VM1 OCI avant et après redimensionnement | [2 OCPU / 12 Go](1-machines/oci-vm1-avant.png), [1 OCPU / 6 Go et état Running](1-machines/oci-vm1-apres.png), [contrôle sous Ubuntu](1-machines/oci-vm1-controle-ubuntu.png) |
| VM2 OCI | [erreur de capacité Ampere A1](1-machines/oci-vm2-capacite.png) |
| Accès OCI | [session SSH depuis Windows](1-machines/oci-ssh-windows.png), [création des trois comptes](1-machines/oci-comptes-equipe.png) |
| Machines VMware | [paramètres OPNsense](1-machines/opnsense-vmware.png), [démarrage depuis le disque](1-machines/opnsense-demarrage-disque.png), [bureau ADMIN-SITE](1-machines/admin-site-xubuntu.png) |

## 2. Réseau

| Vérification | Captures |
|---|---|
| Réseaux OCI et VMware | [sous-réseaux OCI](2-reseau/oci-sous-reseaux.png), [réseaux virtuels VMware](2-reseau/vmware-vmnet.png) |
| Affectation et adressage | [affectation OPNsense](2-reseau/opnsense-affectation.png), [adresses OPNsense](2-reseau/opnsense-adressage.png), [adresse ADMIN-SITE](2-reseau/admin-site-ipv4.png) |

## 3. Tunnel WireGuard

| Vérification | Captures |
|---|---|
| WireGuard activé sur `web-app` | [service `wg-quick@wg0` activé et ping du pair](3-wireguard/enabling-wireguard-on-web-vm.png) |

## 4. Données sensibles

Aucune capture pour l'instant (SRV-DATA à installer).

## 5. Tests

| Vérification | Captures |
|---|---|
| Accès local à OPNsense depuis ADMIN-SITE | [ping réussi](5-tests/admin-site-ping-opnsense.png), [page de connexion HTTPS](5-tests/admin-site-https-opnsense.png) |

## 6. Services exposés

| Vérification | Captures |
|---|---|
| Installation et démarrage de Nginx | [installation](6-services/nginx-install.png), [Nginx à l'écoute sur le port 80](6-services/nginx-port-80.png), [page d'accueil](6-services/nginx-welcome.png) |
| HTTPS | [génération du certificat autosigné](6-services/selfSignedCert.png) |
| Application web | [service systemd `myapp` actif](6-services/myappservice.png) |
