FROM alpine:3.7
MAINTAINER Nurse Curtis <curtis@crabdance.ca>
# root filesystem
COPY rootfs /

# base image packages
RUN apk -U update && \
    apk -U upgrade && \
    apk -U add --no-cache \
        bash \
        coreutils \
        ca-certificates \
        shadow \
        curl

# s6 overlay
RUN curl -L https://github.com/just-containers/s6-overlay/releases/download/v1.21.4.0/s6-overlay-amd64.tar.gz \
    | tar -xzC /

# create default user / group and folders
RUN groupadd -g 1000 abc && \
    useradd -u 1000 -g abc -d /app -s /bin/false abc && \
    mkdir -p \
	    /app \
	    /config

RUN apk -U update && \
    apk -U upgrade && \
    apk -U add --no-cache \
        git \
        nginx \
        php7 \
        php7-fpm \
        php7-curl \
        php7-dom \
        php7-gettext \
        php7-xml \
        php7-simplexml \
        php7-zip \
        php7-zlib \
        php7-gd \
        php7-openssl \
        php7-mysqli \
        php7-pdo \
        php7-pdo_mysql \
	php7-pdo_pgsql \
        php7-json \
        php7-mbstring \
        php7-ctype \
    && \
    git clone --branch develop --depth 1 https://github.com/spotweb/spotweb.git /app && \
    sed -i "s/date.timezone = UTC/date.timezone = \"America\/Edmonton\"/g" /etc/php7/php.ini && \
    sed -i "s/memory_limit = 128M/memory_limit = \"1024M\"/g" /etc/php7/php.ini && \
    sed -i "s/max_execution_time = 30/max_execution_time = \"120\"/g" /etc/php7/php.ini

# Configure Spotweb
COPY ./conf/spotweb /app

# Copy root filesystem
COPY rootfs /

EXPOSE 80
