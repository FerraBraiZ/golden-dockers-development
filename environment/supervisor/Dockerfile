FROM alpine:latest

RUN apk add --no-cache supervisor

RUN mkdir -p /etc/supervisor.d

COPY ./supervisord.conf /etc/supervisor.d/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]