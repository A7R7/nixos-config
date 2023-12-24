#!/bin/sh
# this script restart nix-daemon with proxy settings as below

content='[Service]
Environment="http_proxy=http://192.168.199.101:8080"
Environment="https_proxy=http://192.168.199.101:8080"
Environment="all_proxy=http://192.168.199.101:8080"
'
path='/run/systemd/system/nix-daemon.service.d/'
sudo mkdir -p "$path"
echo "$content" | sudo tee "$path/"override.conf
sudo systemctl daemon-reload
sudo systemctl restart nix-daemon
