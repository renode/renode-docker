# This docker configuration file lets you easily run Renode and simulate embedded devices
# on an x86 desktop or laptop. The framework can be used for debugging and automated testing.
FROM ubuntu:22.04

LABEL maintainer="Piotr Zierhoffer <pzierhoffer@antmicro.com>"

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
# Install main dependencies and some useful tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates sudo wget && rm -rf /var/lib/apt/lists/*

# Set up users
RUN sed -i.bkp -e \
      's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
      /etc/sudoers
ARG userId=1000
ARG groupId=1000
RUN mkdir -p /home/developer && \
    echo "developer:x:$userId:$groupId:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:$userId:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown $userId:$groupId -R /home/developer

USER developer
ENV HOME /home/developer
WORKDIR /home/developer

ARG RENODE_VERSION=1.16.1

# Install Renode
USER root
RUN wget https://github.com/renode/renode/releases/download/v${RENODE_VERSION}/renode_${RENODE_VERSION}_amd64.deb && \
    apt-get update && \
    apt-get install -y --no-install-recommends ./renode_${RENODE_VERSION}_amd64.deb python3-dev && \
    rm ./renode_${RENODE_VERSION}_amd64.deb && \
    rm -rf /var/lib/apt/lists/*
RUN pip3 install -r /opt/renode/tests/requirements.txt --no-cache-dir
USER developer
CMD renode
