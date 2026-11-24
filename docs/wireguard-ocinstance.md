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
# Colle ici le contenu de ton fichier /etc/wireguard/wg0.conf (sans la clé privée !)
```

## 5. Vérification
```bash
sudo wg show
```
