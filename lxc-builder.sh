#!/bin/sh

apk --no-cache add dnssec-root nsd unbound

rm -rf /etc/unbound/*
rm -rf /etc/nsd/*

install -o unbound -g unbound -m 0755 -d /var/unbound
install -o nsd -g nsd -m 0755 -d /var/nsd

touch /var/unbound/root.key
/usr/sbin/unbound-anchor -v -a /var/unbound/root.key || true
chown unbound:unbound /var/unbound/root.key

wget -qO /var/nsd/root.zone https://www.internic.net/domain/root.zone
chown nsd:nsd /var/nsd/root.zone

wget -qO /etc/unbound/unbound.conf https://raw.githubusercontent.com/michaelmouton/unbound-nsd/refs/heads/main/unbound.conf
wget -qO /etc/nsd/nsd.conf https://raw.githubusercontent.com/michaelmouton/unbound-nsd/refs/heads/main/nsd.conf

wget -qO /etc/init.d/dnsman https://raw.githubusercontent.com/michaelmouton/unbound-nsd/refs/heads/main/dnsman
wget -qO /usr/local/bin/dns-bootstrap.sh https://raw.githubusercontent.com/michaelmouton/unbound-nsd/refs/heads/main/entrypoint.sh

chmod +x /etc/init.d/dnsman
chmod +x /usr/local/bin/dns-bootstrap.sh

rc-update add dnsman default
rc-service dnsman start
