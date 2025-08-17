
PORT=${1:-80}
LAN=${2:-wlan0}
set -v

sudo tcpdump -A -s0 -i"$LAN" port "${PORT}"