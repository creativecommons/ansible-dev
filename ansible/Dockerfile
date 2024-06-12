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

# Set environment variables for Ansible
ENV PATH="/opt/ansible-venv/bin:$PATH"
ENV ANSIBLE_CONFIG=/etc/ansible/ansible.cfg

# Expose SSH port
EXPOSE 22

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]

