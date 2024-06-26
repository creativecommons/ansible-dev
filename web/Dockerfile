# https://docs.docker.com/engine/reference/builder/
# https://hub.docker.com/_/debian
FROM debian:bookworm-slim

# Configure apt not to prompt during docker build
ARG DEBIAN_FRONTEND=noninteractive

# Configure apt to avoid installing recommended and suggested packages
RUN apt-config dump \
    | grep -E '^APT::Install-(Recommends|Suggests)' \
    | sed -e 's/1/0/' \
    | tee /etc/apt/apt.conf.d/99no-recommends-no-suggests

# Resynchronize the package index files from their sources
RUN apt-get update

# Install packages
RUN apt-get install -y \
    apache2 \
    apache2-utils \
    ca-certificates \
    curl \
    git \
    less \
    libapache2-mod-php \
    mariadb-client \
    php8.2 \
    php8.2-mbstring \
    php8.2-mysql \
    php8.2-pdo \
    php8.2-xml \
    python3 \
    sudo \
    unzip \
    vim \
    wget \
    openssh-client \
    openssh-server \
    && update-ca-certificates

# Clean up packages: Saves space by removing unnecessary package files and lists
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Create sysadmin user and add to sudoers
RUN useradd -m -s /bin/bash sysadmin && \
    echo "sysadmin:sysadmin" | chpasswd && \
    usermod -aG sudo sysadmin

# Ensure SSH directory exists with correct permissions
RUN mkdir -p /home/sysadmin/.ssh && \
    chown sysadmin:sysadmin /home/sysadmin/.ssh && \
    chmod 700 /home/sysadmin/.ssh

# Create privilege separation directory for SSH
RUN mkdir -p /run/sshd

# Add Apache2's www-data user to sudo group and enable passwordless startup
RUN adduser www-data sudo
COPY web/config-web/www-data_startupservice /etc/sudoers.d/www-data_startupservice

# Add Apache2 service startup script
COPY web/config-web/startupservice.sh /startupservice.sh
RUN chmod +x /startupservice.sh
CMD ["sudo", "--preserve-env", "/startupservice.sh"]

# Expose SSH port
EXPOSE 22

# Expose ports for Apache
EXPOSE 80

# Enable Apache modules
RUN a2enmod headers
RUN a2enmod php8.2
RUN a2enmod rewrite

# Configure PHP
COPY web/config-web/90-local.ini /etc/php/8.2/apache2/conf.d/

# Install WordPress CLI (WP-CLI)
# https://wp-cli.org/#installing
RUN curl -L \
    https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    -o wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Create WP-CLI directory for www-data
RUN mkdir /var/www/.wp-cli
RUN chown -R www-data:www-data /var/www/.wp-cli

# Create the dev directory and set permissions
RUN mkdir -p /var/www/dev/wp-content/uploads
RUN chown -R www-data:www-data /var/www/dev

# Use WP-CLI to install WordPress
USER www-data
WORKDIR /var/www/dev
ARG WP_VERSION
RUN wp core download --version=$WP_VERSION

# Add WordPress basic configuration
# 1) Download wp-config-docker.php for use as wp-config.php. Friendly view at:
# https://github.com/docker-library/wordpress/blob/master/latest/php8.2/apache/wp-config-docker.php
RUN curl -L \
    https://raw.githubusercontent.com/docker-library/wordpress/master/latest/php8.2/apache/wp-config-docker.php \
    -o /var/www/dev/wp-config.php

# 2) Use awk to replace all instances of "put your unique phrase here" with a
#    properly unique string (for AUTH_KEY and friends to have safe defaults if
#    they aren't specified with environment variables)
#    Based on:
# https://github.com/docker-library/wordpress/blob/master/latest/php8.2/apache/docker-entrypoint.sh
RUN awk ' \
    /put your unique phrase here/ { \
        cmd = "head -c1m /dev/urandom | sha1sum | cut -d\\  -f1"; \
        cmd | getline str; \
        close(cmd); \
        gsub("put your unique phrase here", str); \
    } \
    { print } \
    ' /var/www/dev/wp-config.php > /var/www/dev/wp-config.tmp \
    && mv /var/www/dev/wp-config.tmp /var/www/dev/wp-config.php

