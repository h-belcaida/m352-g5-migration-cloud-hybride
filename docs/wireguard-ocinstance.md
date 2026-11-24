# Configuration VPN WireGuard - Oracle Cloud (`ocinstance`)

## 1. Installation de WireGuard
```bash
sudo apt update && sudo apt install wireguard -y
```

## 2. Génération des clés (Publique & Privée)
```bash
wg genkey | sudo tee /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key
sudo chmod 600 /etc/wireguard/private.key
```

## 3. Activation du routage IP (IP Forwarding)
```bash
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

## 4. Configuration de l'interface `/etc/wireguard/wg0.conf`
```ini
[Interface]
Address = xxxxxxx.xxxxxxxx.xxxxxxx.1/24
ListenPort = x18xxxxxxxxx
PrivateKey = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxlpe3qb1E=
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o wg0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o wg0 -j MASQUERADE

[Peer]
# OPNsense-SITE
PublicKey = En attente ....
AllowedIPs = x.99.x.x/32, 192.xxxx.xx.x/24
```

## 5. Vérification
```bash
sudo wg show
```
