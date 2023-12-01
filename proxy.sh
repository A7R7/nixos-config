#!/usr/bin/env bash
# this script restart nix-daemon with proxy settings as below

# content='[Service]
# Environment="http_proxy=socks5h://localhost:7890"
# Environment="https_proxy=socks5h://localhost:7890"
# Environment="all_proxy=socks5h://localhost:7890"
# '
if [ -z "$1" ]; then
	proxy="socks5h://localhost:7890"
else
	proxy="$1"
fi
content='[Service]
Environment="http_proxy='$proxy'"
Environment="https_proxy='$proxy'"
Environment="all_proxy='$proxy'"
'
path='/run/systemd/system/nix-daemon.service.d/'
sudo mkdir -p "$path"
echo "$content" | sudo tee "$path/"override.conf
sudo systemctl daemon-reload
sudo systemctl restart nix-daemon
