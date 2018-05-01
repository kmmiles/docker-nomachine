FROM debian:stretch
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y \
      sudo \
      curl \
      wget \
      vim \
      cups \
      pulseaudio \
      xterm \
      mate-desktop-environment-core \
      fonts-liberation \
      libappindicator3-1 \
      lsb-release \
      xdg-utils

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

RUN curl -fSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o chrome.deb && \
    dpkg -i chrome.deb && \
#    apt fix-broken install && \
    rm -f chrome.deb

ADD nxserver.sh /

ENTRYPOINT ["/nxserver.sh"]
