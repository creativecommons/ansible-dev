# Use the Debian Bookworm Slim base image
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

# Copy the sudoers file for sysadmin user to the appropriate directory
COPY ./web/etc-sudoers.d/sysadmin_all_nopass /etc/sudoers.d/sysadmin_all_nopass

# Ensure SSH directory exists with correct permissions
RUN mkdir -p /home/sysadmin/.ssh && \
    chown sysadmin:sysadmin /home/sysadmin/.ssh && \
    chmod 700 /home/sysadmin/.ssh

# Create privilege separation directory for SSH
RUN mkdir -p /run/sshd

# Add Apache2's www-data user to sudo group and enable passwordless startup
RUN adduser www-data sudo
COPY ./web/etc-sudoers.d/www-data_startupservice /etc/sudoers.d/www-data_startupservice

# Add Apache2 service startup script
COPY ./web/startupservice.sh /startupservice.sh
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
COPY ./web/etc-php-8.2-apache2-conf.d/90-local.ini /etc/php/8.2/apache2/conf.d/

# Create the wp directory and set permissions
RUN mkdir -p /usr/local/bin/wp/
RUN chown -R www-data:www-data /usr/local/bin/wp/

# Create the dev directory and set permissions
RUN mkdir -p /var/www/dev/wp-content/uploads
RUN chown -R www-data:www-data /var/www/dev

