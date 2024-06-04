FROM debian:12-slim

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    acl \
    apache2 \
    asciidoc \
    bzip2 \
    cdbs \
    curl \
    debhelper \
    debianutils \
    default-mysql-server \
    devscripts \
    docbook-xml \
    dpkg-dev \
    fakeroot \
    gawk \
    gcc \
    git \
    libffi-dev \
    libssl-dev \
    libxml2-utils \
    locales \
    make \
    mercurial \
    openssh-client \
    openssh-server \
    python3-dev \
    pass \
    python3-httplib2 \
    python3-jinja2 \
    python3-lxml \
    python3-mock \
    python3-mysqldb \
    python3-nose \
    python3-paramiko \
    python3-passlib \
    python3-pip \
    python3-setuptools \
    python3-virtualenv \
    python3-yaml \
    reprepro \
    rsync \
    ruby \
    sshpass \
    subversion \
    sudo \
    tzdata \
    unzip \
    xsltproc \
    zip \
    && \
    apt-get clean

RUN python3 -m virtualenv /venv

ENV PATH="/venv/bin:$PATH"

RUN pip3 install --upgrade pip
RUN pip3 install --upgrade pycrypto cryptography
RUN pip3 install ansible

RUN rm /usr/sbin/policy-rc.d; \
	rm /sbin/initctl; dpkg-divert --rename --remove /sbin/initctl

RUN for f in \
		/etc/init/u*.conf \
		/etc/init/mounted-dev.conf \
		/etc/init/mounted-proc.conf \
		/etc/init/mounted-run.conf \
		/etc/init/mounted-tmp.conf \
		/etc/init/mounted-var.conf \
		/etc/init/hostname.conf \
		/etc/init/networking.conf \
		/etc/init/tty*.conf \
		/etc/init/plymouth*.conf \
		/etc/init/hwclock*.conf \
		/etc/init/module*.conf\
	; do \
		dpkg-divert --local --rename --add "$f"; \
	done; \
	echo '# /lib/init/fstab: cleared out for bare-bones Docker' > /lib/init/fstab

RUN locale-gen en_US.UTF-8

RUN ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa && \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys && \
    for key in /etc/ssh/ssh_host_*_key.pub; do echo "localhost $(cat ${key})" >> /root/.ssh/known_hosts; done

RUN mkdir /etc/ansible/
RUN /bin/echo -e "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts


RUN service ssh start

VOLUME /sys/fs/cgroup /run/lock /run /tmp

RUN pip3 install coverage junit-xml

ENV container=docker

CMD ["/bin/bash"]