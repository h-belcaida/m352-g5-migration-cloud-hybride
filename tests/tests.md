# Tests

| # | Test | Commande | Résultat attendu |
|---|------|----------|------------------|
| 1 | Ports exposés | `nmap -sS -sU -p 22,80,443,5432,51820 <VM1_PUBLIC_IP>` (depuis l'extérieur) | Seuls 80/tcp et 51820/udp sont ouverts |
| 2 | Tunnel actif | `wg show` puis `ping 10.99.0.2` (sur VM1) | Handshake récent et ping OK |
| 3 | Accès aux données | `nc -zv 192.168.20.10 5432` | OK depuis VM2 ; bloqué depuis VM1 |
| 4 | Chiffrement du lien | `tcpdump -i <WAN> host <VM1_PUBLIC_IP>` (sur OPNsense) | Uniquement de l'UDP 51820 chiffré |
| 5 | Page publique | `curl http://<VM1_PUBLIC_IP>` | La page publique s'affiche |
