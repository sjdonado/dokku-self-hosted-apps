## Chisel server

### Setup
```bash
dokku apps:create chisel
dokku domains:set chisel tunnel.sjdonado.de
dokku letsencrypt:enable chisel

dokku config:set chisel CHISEL_AUTH=user:pass

dokku ports:add chisel http:80:8080
dokku ports:add chisel https:443:8080
```

### Deploy
```bash
git remote add dokku-chisel dokku@sjdonado.de:chisel
git subtree push --prefix chisel dokku-chisel master
```

## OpenVPN server

### Setup
```bash
dokku proxy:disable openvpn
dokku config:set openvpn HOST_ADDR=35.127.0.0 HOST_CONF_PORT=8080
dokku docker-options:add openvpn deploy "--cap-add=NET_ADMIN"
dokku docker-options:add openvpn deploy "-p 1194:1194/udp -p 8080:8080/tcp"
```

### Generate new client config
```bash
dokku run openvpn ./genclient
# Config server started, download your client.ovpn config at http://35.127.0.0:8080 ...
```

### Deploy
```bash
git remote add dokku-openvpn dokku@sjdonado.de:openvpn
git subtree push --prefix openvpn dokku-openvpn master
```

### Install MacOS client
```bash
brew install --cask openvpn-connect
```

## Bitwarden

### Setup
```bash
dokku letsencrypt:enable bitwarden

dokku postgres:create bitwarden
dokku postgres:link bitwarden bitwarden

dokku storage:ensure-directory bitwarden
dokku storage:mount bitwarden /var/lib/dokku/data/storage/bitwarden:/data

dokku config:set bitwarden DOKKU_PROXY_PORT_MAP="http:80:80 https:443:80"
dokku config:set bitwarden \
  DOMAIN=https://passwords.sjdonado.de \
  SIGNUPS_ALLOWED=false \
  ADMIN_TOKEN='$argon2id...' \
  SMTP_HOST=smtp.sjdonado.de \
  SMTP_FROM=vaultwarden@sjdonado.de \
  SMTP_PORT=587 \
  SMTP_SECURITY=starttls \
  SMTP_USERNAME=apikey \
  SMTP_PASSWORD=
```

### Deploy
```bash
git remote add dokku-bitwarden dokku@sjdonado.de:bitwarden
git subtree push --prefix bitwarden dokku-bitwarden master
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
git remote add dokku-uptime-kuma dokku@sjdonado.de:uptime-kuma
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
git remote add dokku-actual dokku@sjdonado.de:actual
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
git remote add dokku-jellyfin dokku@sjdonado.de:jellyfin
git subtree push --prefix jellyfin dokku-jellyfin master
```

### Upload media
```bash
rsync -avz --progress -e ssh "/path/on/local/computer" sjdonado@sjdonado.de:/var/lib/dokku/data/storage/jellyfin-media
```

## Lesspass

### Local
```bash
docker-compose -f lesspass/docker-compose.yml up
```
Default URL: `http://localhost:8000/api`

### Setup
```bash
dokku letsencrypt:enable lesspass
dokku postgres:create lesspass
dokku postgres:link lesspass lesspass

dokku config:set lesspass DOKKU_PROXY_PORT_MAP="http:80:8000 https:443:8000"
dokku config:set lesspass \
  ALLOWED_HOSTS="passwords.sjdonado.de" \
  DATABASE_ENGINE="django.db.backends.postgresql" \
  DATABASE_HOST="dokku-postgres-lesspass" \
  DATABASE_NAME="lesspass" \
  DATABASE_USER="postgres" \
  DATABASE_PASSWORD="ENTER_YOUR_PASSWORD" \
  DATABASE_PORT="5432" \
  EMAIL_BACKEND="django.core.mail.backends.console.EmailBackend"
```

### Deploy
```bash
git remote add dokku-lesspass dokku@sjdonado.de:lesspass
git subtree push --prefix lesspass dokku-lesspass master
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
git remote add dokku-proxy-server dokku@sjdonado.de:proxy-server
git subtree push --prefix proxy-server dokku-proxy-server master
```

### Test
```bash
curl https://github.com/ -sv -o/dev/null -x https://localhost:3128 --proxy-insecure
```
