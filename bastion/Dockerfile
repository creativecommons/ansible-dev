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
    ca-certificates \
    && update-ca-certificates

# Follows the instructions here:
# https://ovh.github.io/the-bastion/installation/basic.html
RUN git clone https://github.com/ovh/the-bastion /opt/bastion
RUN git -C /opt/bastion checkout $(git -C /opt/bastion tag | tail -1)

RUN /opt/bastion/bin/admin/packages-check.sh -i

RUN /opt/bastion/bin/admin/install --new-install

RUN /opt/bastion/bin/admin/setup-first-admin-account.sh sysadmin auto