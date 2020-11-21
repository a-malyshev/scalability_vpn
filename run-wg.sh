#!/bin/bash

docker stop wireguard

START=1
END=2
for ((i=$START;i<$END;i++))
do
echo "$i - $START" | bc
docker build -t wg-client \
					 	 --build-arg CONF_NAME=wg$i.conf \
						 .
docker run --cap-add=NET_ADMIN \
                 --cap-add=SYS_MODULE \
                 -it --rm  \
                 --privileged \
								 -v $(pwd)/data:/data \
								 -v $(pwd)/results:/results \
                 --name "wireguard${i}" \
					 	 		 --env ID=${i} \
                 --sysctl net.ipv6.conf.all.disable_ipv6=0 \
                 wg-client
done
