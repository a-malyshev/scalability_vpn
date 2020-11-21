#!/bin/bash

#addopted from https://nickb.dev/blog/routing-select-docker-containers-through-wireguard-vpn
set -euo pipefail
set -x

wg-quick up wg0

VPN_IP=$(grep -Po 'Endpoint\s=\s\K[^:]*' /etc/wireguard/wg0.conf)

function finish {
    echo "$(date): Shutting down vpn"
    wg-quick down wg0
}

function has_vpn_ip {
    curl --silent --show-error --retry 10 --fail ifconfig.co | \
        grep $VPN_IP
}

if [[ $? != 0 ]]; then
  echo "Connection to VPN server was not set up correctly" 1>&2
  exit 1
fi

trap finish TERM INT

export LOAD_SLEEP=2
while true; do 
	sleep ${LOAD_SLEEP}; 
	start=`date +%s.%N`
	curl -s http://104.248.120.90:8000/health; 
	end=`date +%s.%N`
	runtime=$( echo "$end - $start" | bc -l )
  echo "$runtime" >> /results/performance${ID}.txt
done

echo "$(date): VPN IP address not detected"

