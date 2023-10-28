#!/bin/bash -eu

# Use a here document to create and write formatted text to the file
rm -f ./environment/nginx-fastcgi-pass/alpine/default.conf

cat <<EOT > ./environment/nginx-fastcgi-pass/alpine/default.conf
server {

    listen 80 default;
    server_name _;
    root /var/www/public;
    index index.php;

    access_log /dev/stdout;
    #Log levels:  verbose,warn, error crit, alert, and emerg
    error_log  /dev/stderr warn;

    client_max_body_size 1024M;
    server_tokens off;
    sendfile on;
    keepalive_timeout 60;
    charset utf-8;

    # enabling compression for proxied (php-fpm) requests
    # https://docs.nginx.com/nginx/admin-guide/web-server/compression/
    gzip            on;
    gzip_types      application/xml text/plain text/css text/javascript application/x-javascript application/json;
    gzip_proxied    no-cache no-store private expired auth;
    gzip_min_length 1000;

    location / {
        try_files \$uri /index.php\$is_args\$args;
    }

    if (!-e \$request_filename) {
        rewrite ^.*\$ /index.php last;
    }

    location ~ \.php\$ {

        # First attempt to serve request as file, then
        # as directory, then fall back to displaying a 404.
        #try_files \$uri =404;
        fastcgi_split_path_info ^(.+.php)(/.+)\$;

        fastcgi_intercept_errors on;
        fastcgi_param PHP_VALUE "error_log=/dev/stderr";
        fastcgi_connect_timeout 60;
        fastcgi_send_timeout 60;
        fastcgi_read_timeout 60;
        fastcgi_buffer_size 32k;
        fastcgi_buffers 16 16k;
        fastcgi_hide_header X-Powered-By;
        fastcgi_keep_conn  on;

        fastcgi_pass ${UPSTREAM_APP}:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;

        add_header X-Frame-Options "SAMEORIGIN";
        add_header X-XSS-Protection "1; mode=block";
        add_header X-Content-Type-Options "nosniff";

    }

}

EOT