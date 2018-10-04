FROM ubuntu
ENV TERM xterm
RUN apt update
RUN apt install -y gnupg ca-certificates
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list
RUN apt update
RUN apt install -y mono-complete g++ policykit-1 libgtk2.0-0 screen uml-utilities gtk-sharp2 python2.7 python-pip sudo wget
RUN python -m pip install robotframework netifaces requests psutil
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
RUN wget https://github.com/renode/renode/releases/download/v1.5/renode_1.5.0_amd64.deb
RUN sudo dpkg -i renode_1.5.0_amd64.deb
CMD renode
