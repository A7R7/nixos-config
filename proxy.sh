#!/usr/bin/env bash
# this script restart nix-daemon with proxy settings as below

path="/run/systemd/system/nix-daemon.service.d"
content='
[Service]
Environment="http_proxy=socks5h://localhost:7890"
Environment="https_proxy=socks5h://localhost:7890"
Environment="all_proxy=socks5h://localhost:7890"
'
sudo mkdir -p "$path"
echo "$content" | sudo tee "$path/"override.conf
sudo systemctl daemon-reload
sudo systemctl restart nix-daemon
