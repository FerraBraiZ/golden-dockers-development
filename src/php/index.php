<?php

$url = urldecode(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH));

try {

    if ( $url == '/alive'  || $url == '/health-check/alive' || $url == '/' ) {
        http_response_code(200 );
        exit( "$url: everything is gonna be 200!");
    }

    http_response_code(200 );
    exit( 'everything is gonna be 200!' );

} catch (\Throwable $e) {

    http_response_code($e->getCode());
    exit('Um erro inesperado ocorreu! lamentamos pelo inconveniente!');

}
