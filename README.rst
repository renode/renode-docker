Renode Docker image
===================

This repository contains a Dockerfile for Renode, available on Docker Hub as ``antmicro/renode``.

The image is based on Ubuntu 20.04.

Renode is installed from a release package and also compiled from the corresponding sources.

To build the image run ``docker build --build-arg userId=`id -u` --build-arg groupId=`id -g` -t renode .``.

The image will start Renode in interactive mode by default.


Renode minimized container image
================================
This Dockerfile uses a multistage build with runtime image based on mono:slim to minimize runtime container components, static image size.
By default if no version is passed via `--build-arg RENODE_VERSION=x.y.z` it will build `1.12.0`.
Note on ``podman`` replacing ``docker``: https://podman.io/whatis.html

Static image size comparison: 
    Ubuntu base ~805 MB
    Mono:slim   ~311 MB

BUILD THE IMAGE
---------------
``podman build -t renode_min_test ./ -f Dockerfile.min``

RUN THE IMAGE LOCALLY
---------------------
``podman run -p 1234:1234 localhost/renode_min_test``

RUN THE IMAGE AS SERVICE
------------------------
``podman run -d -p 1234:1234 localhost/renode_min_test``

CONNECT TO THE RUNNING INTERACTIVE INSTANCE OF RENODE
-----------------------------------------------------
``telnet localhost 1234``

BUILD A SPECIFIC VERSION OF RENODE
-------------------------------
``podman build -t test_renode_min ./ -f Dockerfile.min --build-arg RENODE_VERSION=1.11.0``


For more information, visit the `Renode website <https://renode.io>`_, `Renode documentation <https://renode.readthedocs.io>`_ and `Docker documentation <https://docs.docker.com>`_.

