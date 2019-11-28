# This docker configuration file lets you easily run Renode and simulate embedded devices
# on an x86 desktop or laptop. The framework can be used for debugging and automated testing.
FROM ubuntu:18.04

LABEL maintainer="Piotr Zierhoffer <pzierhoffer@antmicro.com>"

# Install main dependencies and some useful tools
RUN apt update && apt install -y gnupg ca-certificates
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic/snapshots/5.20.1.19 main" | tee /etc/apt/sources.list.d/mono-official-stable.list
RUN apt update && apt install -y mono-complete g++ policykit-1 libgtk2.0-0 screen uml-utilities gtk-sharp2 python2.7 python-pip sudo wget git ruby-dev build-essential rpm bsdtar zlib1g-dev && rm -rf /var/lib/apt/lists/*

# Install Python dependencies - mostly for Robot testing
RUN python -m pip install robotframework==3.0.4 netifaces requests psutil

# Install FPM for packaging support
RUN gem install fpm

# Set up users
RUN sed -i.bkp -e \
      's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
      /etc/sudoers
ARG userId
ARG groupId
RUN mkdir -p /home/developer && \
    echo "developer:x:$userId:$groupId:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:$userId:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown $userId:$groupId -R /home/developer

USER developer
ENV HOME /home/developer
WORKDIR /home/developer

ARG RENODE_VERSION=1.8.2

# Install Renode
RUN wget https://github.com/renode/renode/releases/download/v${RENODE_VERSION}/renode_${RENODE_VERSION}_amd64.deb
USER root
RUN apt install -y ./renode_${RENODE_VERSION}_amd64.deb
USER developer

# Build the development version
RUN git clone https://github.com/renode/renode.git && \
    cd renode && \
    git checkout v${RENODE_VERSION} && \
    bash build.sh -p
CMD renode
