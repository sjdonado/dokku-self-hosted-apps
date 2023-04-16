#!/bin/bash

# OpenVPN
git remote add dokku-openvpn dokku@sjdonado.de:openvpn
git subtree push --prefix openvpn dokku-openvpn master

# Proxy server 
git remote add dokku-proxy-server dokku@sjdonado.de:proxy-server
git subtree push --prefix proxy-server dokku-proxy-server master
