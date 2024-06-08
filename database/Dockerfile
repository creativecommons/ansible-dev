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
    mariadb-client \
    ca-certificates \
    && update-ca-certificates

# Clean up packages: Saves space by removing unnecessary package files
# and lists
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Expose ports for MariaDB
EXPOSE 3306

# Set the default command to run MariaDB
CMD ["mysqld"]