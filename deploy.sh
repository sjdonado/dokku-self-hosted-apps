#!/bin/bash

# OpenVPN
git remote add dokku-openvpn dokku@sjdonado.de:openvpn
git subtree push --prefix openvpn dokku-openvpn master
