FROM alpine

MAINTAINER Teerasak Vichadee <iolumin@gmail.com>

# Install PHP Dependencies
# from main and common repo
RUN \
  apk add --no-cache \
  php-fpm php-json php-zlib php-xml php-pdo php-phar php-openssl \
  php-pdo_mysql php-mysqli php-gd php-iconv php-mcrypt \
  php-mysql php-curl php-opcache php-ctype php-apcu \
  php-intl php-bcmath php-dom php-xmlreader

# Install redis
# from testing repo
RUN \
  apk add --no-cache --repository http://nl.alpinelinux.org/alpine/edge/testing \
  php-redis

# Install Phalcon framework
RUN \
  apk add --no-cache \
  php-phalcon

# Install NgniX and Tools
RUN \
  apk add --no-cache \
  nginx ca-certificates

# Clear temp and prepare dir
RUN \
  rm -rf /var/cache/apk/* \
  && mkdir /app

# Update config
RUN \
  sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/php.ini && \
  sed -i 's/nginx:x:100:101:Linux User,,,:\/var\/www\/localhost\/htdocs:\/sbin\/nologin/nginx:x:100:101:Linux User,,,:\/var\/www\/localhost\/htdocs:\/bin\/bash/g' /etc/passwd && \
  sed -i 's/nginx:x:100:101:Linux User,,,:\/var\/www\/localhost\/htdocs:\/sbin\/nologin/nginx:x:100:101:Linux User,,,:\/var\/www\/localhost\/htdocs:\/bin\/bash/g' /etc/passwd-

# Add default physical config into container
ADD config/nginx.conf /etc/nginx/
ADD config/php-fpm.conf /etc/php/
ADD run.sh /
RUN chmod +x /run.sh

EXPOSE 80

VOLUME ["/app"]

WORKDIR /app

# CMD ["/bin/echo", "Hello Docker"] # Default docker CMD
CMD ["/run.sh"]
