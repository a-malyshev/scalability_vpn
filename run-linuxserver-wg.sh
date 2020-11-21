#!/bin/bash

N=0

docker stop $(docker ps -q)
#docker build -t wg-client \
							#--build-arg CONF_NAME=wg${N}.conf \
						 #.
START=1
END=2
for ((i=$START;i<$END;i++))
do
echo "$i - $START" | bc
docker run --cap-add=NET_ADMIN \
					 --cap-add=SYS_MODULE \
					 -it \
					 --rm  \
					 -d \
					 -v $(pwd)/data:/data \
					 -v $(pwd)/results:/results \
					 -v /lib/modules:/lib/modules \
					 -v $(pwd)/new_config:/config \
					 -e PUID=1000 \
					 -e PGID=1000 \
					 --entrypoint "/config/startup.sh" \
					 --name "wireguard${i}" \
					 --env ID=${i} \
					 --sysctl net.ipv6.conf.all.disable_ipv6=0 \
					 ghcr.io/linuxserver/wireguard
done
