FROM nginx:alpine

WORKDIR /var/www/public

EXPOSE 80

STOPSIGNAL SIGQUIT

RUN nginx -V

RUN nginx -t