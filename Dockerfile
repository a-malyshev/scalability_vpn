FROM alpine:3.12

ARG CONF_NAME
#ENV ID=5

RUN apk update
RUN apk upgrade
RUN apk add -U wireguard-tools
RUN apk --no-cache add curl iptables
RUN apk add ip6tables
RUN apk add grep
RUN apk add --update coreutils && rm -rf /var/cache/apk/*

COPY ./configs/$CONF_NAME /etc/wireguard/wg0.conf
COPY ./startup.sh /scripts/startup
RUN chmod 755 /scripts/*

#EXPOSE 51820 51820/udp

CMD [ "./scripts/startup" ]
