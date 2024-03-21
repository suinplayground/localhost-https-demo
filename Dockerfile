FROM alpine:3

# install certbot
RUN apk add --upgrade python3 py3-pip certbot \
    gcc \
    musl-dev \
    python3-dev \
    libffi-dev \
    openssl-dev \
    cargo

# Create a virtual environment and activate it
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install certbot-dns-cloudflare

RUN apk add nginx

RUN apk add php83

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./app1.conf /etc/nginx/http.d/app1.conf

COPY ./cloudflare.ini /cloudflare.ini

RUN certbot certonly \
        --agree-tos \
        --register-unsafely-without-email \
        --no-eff-email \
        --dns-cloudflare \
        --dns-cloudflare-credentials cloudflare.ini \
        -d "*.suin.127s.suin.org" # your domain name here

COPY ./index.php /root/index.php

COPY ./main.sh /main.sh
RUN chmod +x /main.sh
RUN apk add bash

CMD ["/main.sh"]
