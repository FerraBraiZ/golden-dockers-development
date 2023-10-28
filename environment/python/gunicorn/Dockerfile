FROM python:3.10

WORKDIR /var/www/

EXPOSE 9000

ENV ACCEPT_EULA=Y \
    FLASK_ENV=development \
    TIME_ZONE="America/Sao_Paulo"

RUN cp /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && \
    echo "$TIME_ZONE" > /etc/timezone; exit 0;

COPY ./src/python-flask/requirements.txt /var/www/requirements.txt

RUN pip install -r requirements.txt

CMD ["/usr/local/bin/gunicorn","--reload","--bind",":9000","--workers","4","app:app"]