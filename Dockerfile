# This docker configuration file lets you easily run Renode and simulate embedded devices
# on an x86 desktop or laptop. The framework can be used for debugging and automated testing.
FROM ubuntu:20.04

LABEL maintainer="Piotr Zierhoffer <pzierhoffer@antmicro.com>"

# Install main dependencies and some useful tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends mono-complete g++ policykit-1 libgtk2.0-0 screen uml-utilities gtk-sharp2 python3 python3-pip python3-dev python3-setuptools sudo wget git ruby-dev build-essential rpm bsdtar zlib1g-dev && rm -rf /var/lib/apt/lists/*

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

ARG RENODE_VERSION=1.10.0

# Install Renode
USER root
RUN wget https://github.com/renode/renode/releases/download/v${RENODE_VERSION}/renode_${RENODE_VERSION}_amd64.deb && \
    apt-get install -y --no-install-recommends ./renode_${RENODE_VERSION}_amd64.deb && \
    rm ./renode_${RENODE_VERSION}_amd64.deb
USER developer

# Build the development version
RUN git clone https://github.com/renode/renode.git --depth 1 -b v${RENODE_VERSION} && \
    cd renode && \
    bash build.sh -p && \
    python -m pip install -r tools/requirements.txt --no-cache-dir
CMD renode
