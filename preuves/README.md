# Preuves

Mettez chaque capture d'écran dans le dossier de la partie concernée et floutez les IP publiques.

| Dossier | Partie |
|---------|--------|
| `1-machines/` | Création des VM (Oracle Cloud et VMware) |
| `2-reseau/` | VCN, sous-réseaux, Security Lists, règles OPNsense |
| `3-wireguard/` | Tunnel WireGuard |
| `4-donnees/` | PostgreSQL et chiffrement LUKS sur SRV-DATA |
| `5-tests/` | Résultats des tests de `tests/tests.md` |

## Contribution de Mohammed ELFADLAOUI

Captures du 22 au 24 novembre 2026. Les adresses d’instance OCI, les clés SSH, les noms des comptes de l’équipe et le chemin local Windows ont été masqués ou recadrés dans les captures concernées. Les plages de la maquette restent visibles pour comprendre les tests.

| Vérification | Captures |
|---|---|
| VM1 OCI avant et après redimensionnement | [2 OCPU / 12 Go](1-machines/oci-vm1-avant.png), [1 OCPU / 6 Go et état Running](1-machines/oci-vm1-apres.png), [contrôle sous Ubuntu](1-machines/oci-vm1-controle-ubuntu.png) |
| VM2 OCI | [Erreur de capacité Ampere A1](1-machines/oci-vm2-capacite.png) |
| Préparation des accès OCI | [Session SSH depuis Windows](1-machines/oci-ssh-windows.png), [création des trois comptes](1-machines/oci-comptes-equipe.png) |
| Machines VMware | [paramètres OPNsense](1-machines/opnsense-vmware.png), [démarrage depuis le disque](1-machines/opnsense-demarrage-disque.png), [bureau ADMIN-SITE](1-machines/admin-site-xubuntu.png) |
| Réseaux OCI et VMware | [sous-réseaux OCI](2-reseau/oci-sous-reseaux.png), [réseaux virtuels VMware](2-reseau/vmware-vmnet.png) |
| Affectation et adressage | [affectation OPNsense](2-reseau/opnsense-affectation.png), [adresses OPNsense](2-reseau/opnsense-adressage.png), [adresse ADMIN-SITE](2-reseau/admin-site-ipv4.png) |
| Accès local à OPNsense | [ping réussi](5-tests/admin-site-ping-opnsense.png), [page de connexion HTTPS](5-tests/admin-site-https-opnsense.png) |
