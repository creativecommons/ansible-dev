# https://docs.docker.com/engine/reference/builder/

# https://hub.docker.com/_/debian
FROM debian:bookworm-slim

# Configure apt not to prompt during docker build
ARG DEBIAN_FRONTEND=noninteractive

# Configure apt to avoid installing recommended and suggested packages
RUN apt-config dump \
    | grep -E '^APT::Install-(Recommends|Suggests)' \
    | sed -e's/1/0/' \
    | tee /etc/apt/apt.conf.d/99no-recommends-no-suggests

# Resynchronize the package index files from their sources
RUN apt-get update

# Install packages
RUN apt-get install -y \
    python3 \
    python3-pip \
    python3-virtualenv \
    openssh-client 

# Clean up packages: Saves space by removing unnecessary package files
# and lists
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Create a virtual env
RUN python3 -m virtualenv /ansible-venv

# Activate virtual environment and install ansible using pip
RUN /ansible-venv/bin/pip install ansible

# Create a directory for Ansible configuration
RUN mkdir /etc/ansible/

# Copy local Ansible configuration file to the image
COPY config/ansible.cfg /etc/ansible/ansible.cfg

# Copy local inventory file
COPY config/hosts /etc/ansible/hosts

# Set environment variables for Ansible
ENV PATH="/ansible-venv/bin:$PATH"
ENV ANSIBLE_CONFIG=/etc/ansible/ansible.cfg

# Set the default command to run Ansible
CMD ["ansible", "--version"]
