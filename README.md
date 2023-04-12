## OpenVPN server

Setup
```bash
dokku proxy:disable openvpn
dokku config:set openvpn HOST_CONF_PORT=8080
dokku docker-options:add openvpn deploy "--cap-add=NET_ADMIN"
dokku docker-options:add openvpn deploy "-p 1194:1194/udp -p 8080:8080/tcp"
```

Generate new client config
```bash
dokku run openvpn ./genclient
# Config server started, download your client.ovpn config at http://...
```

Install MacOS client
```bash
brew install --cask openvpn-connect
```

## Squid proxy server

Setup
```bash
dokku config:set squid-proxy-server TZ=UTC
```
