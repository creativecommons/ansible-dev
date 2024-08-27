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
    python3 \
    sudo \
    unzip \
    vim \
    wget \
    openssh-client \
    openssh-server \
    && update-ca-certificates

# Make sure that apache can get the environment variables we need
ARG WORDPRESS_DB_HOST
ARG WORDPRESS_DB_PASSWORD
ARG WORDPRESS_DB_USER
ARG WORDPRESS_DB_NAME
ARG WORDPRESS_USER
RUN echo "SetEnv WORDPRESS_DB_HOST ${WORDPRESS_DB_HOST}" >> /etc/apache2/conf-enabled/environment.conf
RUN echo "SetEnv WORDPRESS_DB_PASSWORD ${WORDPRESS_DB_PASSWORD}" >> /etc/apache2/conf-enabled/environment.conf
RUN echo "SetEnv WORDPRESS_DB_USER ${WORDPRESS_DB_USER}" >> /etc/apache2/conf-enabled/environment.conf
RUN echo "SetEnv WORDPRESS_DB_NAME ${WORDPRESS_DB_NAME}" >> /etc/apache2/conf-enabled/environment.conf
RUN echo "SetEnv WORDPRESS_USER ${WORDPRESS_USER}" >> /etc/apache2/conf-enabled/environment.conf

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

# Start SSH
CMD ["/usr/sbin/sshd", "-D"]

# Expose SSH port
EXPOSE 22

# Expose ports for Apache
EXPOSE 80

# Enable Apache modules
RUN a2enmod rewrite

