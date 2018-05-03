FROM debian:stretch-slim

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      sudo \
      curl \
#      wget \
#      cups \
#      pulseaudio \
#      xterm \
      mate-desktop-environment-core \
      fonts-liberation \
      libappindicator3-1 \
      lsb-release \
      xdg-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV NOMACHINE_PACKAGE_NAME nomachine_6.1.6_9_amd64.deb
ENV NOMACHINE_MD5 00b7695404b798034f6a387cf62aba84

RUN curl -fSL "http://download.nomachine.com/download/6.1/Linux/${NOMACHINE_PACKAGE_NAME}" -o nomachine.deb && \
    echo "${NOMACHINE_MD5} *nomachine.deb" | md5sum -c - && \
    dpkg -i nomachine.deb && \
    rm -f nomachine.deb && \
    groupadd -r nomachine -g 433 && \
    useradd -u 431 -r -g nomachine -d /home/nomachine -s /bin/bash -c "NoMachine" nomachine && \
    mkdir /home/nomachine && \
    chown -R nomachine:nomachine /home/nomachine && \
    echo 'nomachine:nomachine' | chpasswd && \
    adduser nomachine sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ADD nxserver.sh /

ENTRYPOINT ["/nxserver.sh"]
