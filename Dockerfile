FROM alpine:3.23


RUN apk --no-cache add dnssec-root nsd unbound


RUN rm -rf /etc/unbound/*
RUN rm -rf /etc/nsd/*

RUN install -o unbound -g unbound -m 0755 -d /var/unbound
RUN install -o nsd -g nsd -m 0755 -d /var/nsd/db

RUN touch /var/unbound/root.key
RUN /usr/sbin/unbound-anchor -v -a /var/unbound/root.key || true
RUN chown unbound:unbound /var/unbound/root.key

RUN wget -qO /var/nsd/root.zone https://www.internic.net/domain/root.zone
RUN chown nsd:nsd /var/nsd/root.zone

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY ./unbound.conf /etc/unbound/unbound.conf
COPY ./nsd.conf /etc/nsd/nsd.conf


EXPOSE 53/tcp
EXPOSE 53/udp

ENTRYPOINT ["/entrypoint.sh"]
