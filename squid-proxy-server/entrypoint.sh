#!/bin/bash
set -e

exec $(which squid) -f /etc/squid/squid.conf -NYCd 1
