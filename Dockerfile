FROM ubuntu:16.04
MAINTAINER nithin <nithinbenny444@gmail.com>
ENV DEBIAN_FRONTEND noninteractive
RUN echo 'debconf debconf/frontend select Dialog' | debconf-set-selections
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
RUN apt-get update -y && apt upgrade -y --no-install-recommends
RUN apt-get install apache2 -y && apt-get install mysql-server -y --no-install-recommends
RUN echo "Asia/Kolkata" > /etc/timezone
RUN apt-get update && apt-get install -yq --no-install-recommends \
    software-properties-common \
    apt-utils \
    curl \
    # Install git
    git \
    # Install php 7.0
    libapache2-mod-php7.0 \
    php7.0-cli \
    php7.0-json \
    php7.0-curl \
    php7.0-gd \
    php7.0-ldap \
    php7.0-mbstring \
    php7.0-mysql \
    php7.0-soap \
    php7.0-sqlite3 \
    php7.0-xml \
    php7.0-zip \
    php7.0-intl \
    php-imagick \
    # Install tools
    openssl \
    nano \
    graphicsmagick \
    imagemagick \
    mysql-client \
    iputils-ping \
    ca-certificates \
    wget \
    unzip \
    supervisor \
    pkg-config \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN service mysql start \
    && mysql -e "CREATE DATABASE DB_NAME;" \
    && mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'DB_USER'@'localhost' IDENTIFIED BY 'DB_USER_PASSWD';" \
    && mysql -e "FLUSH PRIVILEGES;"
EXPOSE 80 3306
ADD apache/example.com.conf /etc/apache2/sites-enabled/example.com.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY wordpress/ /var/www/html/
RUN rm -rf /var/www/html/index.html
COPY wp-config.php /var/www/html/wp-config.php 
VOLUME /var/lib/mysql
VOLUME /var/www/html
CMD ["/usr/bin/supervisord"]
