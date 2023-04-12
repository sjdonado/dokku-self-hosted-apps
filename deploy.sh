#!/bin/bash

# OpenVPN
git remote add dokku-openvpn dokku@sjdonado.de:openvpn
git subtree push --prefix openvpn dokku-openvpn master

# squid
git remote add dokku-squid dokku@sjdonado.de:squid-proxy-server
git subtree push --prefix squid-proxy-server dokku-squid master
