FROM alpine:edge

MAINTAINER Teerasak Vichadee <iolumin@gmail.com>

# Install dependencies
RUN \
  apk add --no-cache \

    # PHP Library
    php-fpm php-json php-zlib php-xml php-pdo php-phar php-openssl \
    php-pdo_mysql php-mysqli \
    php-gd php-iconv php-mcrypt \
    php-mysql php-curl php-opcache php-ctype php-apcu \
    php-intl php-bcmath php-dom php-xmlreader \

    # Phalcon framework
    php-phalcon \

    # MySQL -- I think I will create another container for DB Server
    # mysql-client \

    # NgniX and Tools
    nginx ca-certificates \

  # Clear apk temp
  && rm -rf /var/cache/apk/* \

  # Prepare folder
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
