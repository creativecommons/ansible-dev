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
    python3 \
    python3-pip \
    python3-venv \
    openssh-client \
    openssh-server \
    wget \
    vim \
    sudo

# Clean up packages: Saves space by removing unnecessary package files and lists
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Create sysadmin user and add to sudoers
RUN useradd -m -s /bin/bash sysadmin && echo "sysadmin:sysadmin" | chpasswd && \
    usermod -aG sudo sysadmin

# Ensure SSH directory exists with correct permissions
RUN mkdir -p /home/sysadmin/.ssh && \
    chown sysadmin:sysadmin /home/sysadmin/.ssh && \
    chmod 700 /home/sysadmin/.ssh

# Create privilege separation directory for SSH
RUN mkdir -p /run/sshd

# Create a virtual environment and install Ansible using pip
RUN python3 -m venv /opt/ansible-venv --system-site-packages && \
    /opt/ansible-venv/bin/pip install --no-cache-dir ansible

# Create a directory for Ansible configuration
RUN mkdir /etc/ansible/
WORKDIR /etc/ansible/

# Set environment variables for Ansible
ENV ANSIBLE_CONFIG=/etc/ansible/ansible.cfg
ENV PATH="/opt/ansible-venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Add commands to set environment variables in .bashrc
RUN echo 'export ANSIBLE_CONFIG=/etc/ansible/ansible.cfg' >> /home/sysadmin/.bashrc
RUN echo 'export PATH=/opt/ansible-venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' >> /home/sysadmin/.bashrc
RUN echo 'export LANG=en_US.UTF-8' >> /home/sysadmin/.bashrc
RUN echo 'export LC_ALL=C.UTF-8' >> /home/sysadmin/.bashrc

# Expose SSH port
EXPOSE 22

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]
