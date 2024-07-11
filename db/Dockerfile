# https://docs.docker.com/engine/reference/builder/

# https://hub.docker.com/_/mariadb
FROM mariadb

# Resynchronize the package index files from their sources
RUN apt-get update

# Install packages for ssh
RUN apt-get install -y \
    openssh-client \
    openssh-server

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

# Expose SSH port
EXPOSE 22
EXPOSE 3306

# Add mariadb service startup script
COPY ./db/startupservice.sh /startupservice.sh
RUN chmod +x /startupservice.sh

ENTRYPOINT ["/startupservice.sh"]
CMD ["mariadbd"]