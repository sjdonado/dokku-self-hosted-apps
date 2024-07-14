## Bit

### Setup

https://github.com/sjdonado/bit?tab=readme-ov-file#dokku

### Deploy

```bash
git remote add dokku-bit dokku@donado.co:bit
git subtree push --prefix bit dokku-bit master
```

## Dozzle server

### Setup

```bash
dokku apps:create dozzle
dokku letsencrypt:enable dozzle

dokku storage:ensure-directory dozzle-data
dokku storage:mount dozzle /var/lib/dokku/data/storage/dozzle-data:/data

dokku storage:mount dozzle /var/run/docker.sock:/var/run/docker.sock

dokku ports:add dozzle http:80:8080
dokku ports:add dozzle https:443:8080

# after first deploy
# copy and paste dozzle/data/users.yml to /var/lib/dokku/data/storage/dozzle-data/users.yml
dokku config:set dozzle DOZZLE_AUTH_PROVIDER=simple
```

### Deploy

```bash
git remote add dokku-dozzle dokku@donado.co:dozzle
git subtree push --prefix dozzle dokku-dozzle master
```

Force udpate: `git subtree split --prefix dozzle -b split-dozzle && git push dokku-dozzle split-dozzle:master --force && git branch -D split-dozzle`

## OpenVPN server

### Setup

```bash
dokku proxy:disable openvpn
dokku config:set openvpn HOST_ADDR=35.127.0.0 HOST_CONF_PORT=8080
dokku docker-options:add openvpn deploy "--cap-add=NET_ADMIN"
dokku docker-options:add openvpn deploy "-p 1194:1194/udp -p 8080:8080/tcp"
```

export HOST_ADDR=158.247.125.221 HOST_CONF_PORT=8080
docker run --rm -it --cap-add=NET_ADMIN -p 1194:1194/udp -p 8080:8080/tcp --name openvpn alekslitvinenk/openvpn:v1.12.0

### Generate new client config

```bash
dokku run openvpn ./genclient
# Config server started, download your client.ovpn config at http://35.127.0.0:8080 ...
```

### Deploy

```bash
git remote add dokku-openvpn dokku@donado.co:openvpn
git subtree push --prefix openvpn dokku-openvpn master
```

### Install MacOS client

```bash
brew install --cask openvpn-connect
```

## Bitwarden

### Setup

```bash
dokku letsencrypt:enable vaultwarden

dokku postgres:create vaultwarden
dokku postgres:link vaultwarden vaultwarden

dokku storage:ensure-directory vaultwarden
dokku storage:mount vaultwarden /var/lib/dokku/data/storage/vaultwarden:/data

dokku config:set vaultwarden DOKKU_PROXY_PORT_MAP="http:80:80 https:443:80"
dokku config:set vaultwarden \
  DOMAIN= \
  SIGNUPS_ALLOWED=false \
  ADMIN_TOKEN='$argon2id...' \
  SMTP_HOST= \
  SMTP_FROM=vaultwarden@donado.co \
  SMTP_PORT=587 \
  SMTP_SECURITY=starttls \
  SMTP_USERNAME= \
  SMTP_PASSWORD=
```

### Deploy

```bash
git remote add dokku-vaultwarden dokku@donado.co:vaultwarden
git subtree push --prefix vaultwarden dokku-vaultwarden master
```

## Uptime Kuma

### Setup

```bash
dokku letsencrypt:enable uptime-kuma

dokku storage:ensure-directory uptime-kuma
dokku storage:mount uptime-kuma /var/lib/dokku/data/storage/uptime-kuma:/app/data

dokku config:set uptime-kuma UPTIME_KUMA_PORT=5000
```

### Deploy

```bash
git remote add dokku-uptime-kuma dokku@donado.co:uptime-kuma
git subtree push --prefix uptime-kuma dokku-uptime-kuma master
```

## Actual

### Setup

```bash
dokku letsencrypt:enable actual

dokku storage:ensure-directory actual
dokku storage:mount actual /var/lib/dokku/data/storage/actual:/data

dokku config:set actual DOKKU_PROXY_PORT_MAP="http:80:5006 https:443:5006"
```

### Deploy

```bash
git remote add dokku-actual dokku@donado.co:actual
git subtree push --prefix actual dokku-actual master
```

Force udpate: `git subtree split --prefix actual -b split-actual && git push dokku-actual split-actual:master --force && git branch -D split-actual`

## Jellyfin

### Setup

```bash
dokku letsencrypt:enable jellyfin

dokku storage:ensure-directory jellyfin-config
dokku storage:mount jellyfin /var/lib/dokku/data/storage/jellyfin-config:/config

dokku storage:ensure-directory jellyfin-cache
dokku storage:mount jellyfin /var/lib/dokku/data/storage/jellyfin-cache:/cache

dokku storage:ensure-directory jellyfin-media
dokku storage:mount jellyfin /var/lib/dokku/data/storage/jellyfin-media:/media
sudo chmod a+w /var/lib/dokku/data/storage/jellyfin-media

dokku config:set jellyfin DOKKU_PROXY_PORT_MAP="http:80:8096 https:443:8096"
```

### Deploy

```bash
git remote add dokku-jellyfin dokku@donado.co:jellyfin
git subtree push --prefix jellyfin dokku-jellyfin master
```

### Upload media

```bash
rsync -avz --progress -e ssh "/path/on/local/computer" sjdonado@donado.co:/var/lib/dokku/data/storage/jellyfin-media
```

## NGINX transparent proxy

### Setup

```bash
dokku proxy:disable proxy-server
dokku docker-options:add proxy-server deploy "-p 3129:3128"
```

### Download cert

```bash
dokku run proxy-server download-cert
```

### Deploy

```bash
git remote add dokku-proxy-server dokku@donado.co:proxy-server
git subtree push --prefix proxy-server dokku-proxy-server master
```

### Test

```bash
curl https://github.com/ -sv -o/dev/null -x https://localhost:3128 --proxy-insecure
```
