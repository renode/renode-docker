# This docker configuration file lets you easily run Renode and simulate embedded devices
# on an x86 desktop or laptop. The framework can be used for debugging and automated testing.
FROM ubuntu:18.04

LABEL maintainer="Piotr Zierhoffer <pzierhoffer@antmicro.com>"

# Install main dependencies and some useful tools
RUN apt update
RUN apt install -y gnupg ca-certificates
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list
RUN apt update
RUN apt install -y mono-complete g++ policykit-1 libgtk2.0-0 screen uml-utilities gtk-sharp2 python2.7 python-pip sudo wget git ruby-dev build-essential rpm bsdtar

# Install Python dependencies - mostly for Robot testing
RUN python -m pip install robotframework netifaces requests psutil

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

# Install Renode
RUN wget https://github.com/renode/renode/releases/download/v1.6.1/renode_1.6.1_amd64.deb
RUN sudo apt install -y ./renode_1.6.1_amd64.deb

# Build the development version
RUN git clone https://github.com/renode/renode.git && \
    cd renode && \
    bash build.sh -p && \
    cd /home/developer
CMD renode
