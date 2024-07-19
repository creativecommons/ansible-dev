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

# Install git
RUN apt-get install -y \
    git \
    sed \
    ca-certificates \
    openssh-client \
    openssh-server \
    && update-ca-certificates

# Clean up packages: Saves space by removing unnecessary package files and lists
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Create sysadmin user and add to sudoers
RUN useradd -m -s /bin/bash sysadmin && echo "sysadmin:sysadmin" | chpasswd && \
    usermod -aG sudo sysadmin

# Ensure SSH directory exists with correct permissions
RUN mkdir -p /home/sysadmin/.ssh && \
    chown sysadmin:sysadmin /home/sysadmin/.ssh && \
    chmod 700 /home/sysadmin/.ssh

# Create privilege separation directory for SSH
RUN mkdir -p /run/sshd

# Follows the instructions here:
# https://ovh.github.io/the-bastion/installation/basic.html
RUN git clone https://github.com/ovh/the-bastion /opt/bastion
RUN git -C /opt/bastion checkout $(git -C /opt/bastion tag | tail -1)
RUN /opt/bastion/bin/admin/packages-check.sh -i
RUN /opt/bastion/bin/admin/install --new-install

# Allow SSH jumping
RUN sed -i 's/AllowTcpForwarding no/AllowTcpForwarding yes/' /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 22

# Start SSH service
ENTRYPOINT ["/opt/bastion/docker/entrypoint.sh"]