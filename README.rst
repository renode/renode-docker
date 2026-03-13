Renode Docker image
===================

This repository contains a Dockerfile for Renode, available on Docker Hub as ``antmicro/renode``.

The image is based on 'microsoft/dotnet/runtime:8.0-noble'.

Renode is installed from a release linux package.

To build the image run ``docker build --build-arg userId=`id -u` --build-arg groupId=`id -g` -t renode .``.

The image will start Renode in interactive mode by default.


Renode minimized container image
================================

This Dockerfile uses a multistage build with runtime image based on `Dotnet:8.0-bookworm-slim` to minimize runtime container components and static image size.
By default if no version is passed via `--build-arg RENODE_VERSION=x.y.z` it will build `1.16.1`.

Note on ``Podman`` replacing ``Docker``: https://docs.podman.io/en/latest/

Static image size comparison:
    Ubuntu base ~805 MB

    Dotnet:8.0-bookworm-slim ~328 MB

Build the image
---------------

``podman build -t renode_min_test ./ -f Dockerfile.min``

Run the image locally
---------------------

``podman run -p 1234:1234 localhost/renode_min_test``

Run the image as service
------------------------

``podman run -d -p 1234:1234 localhost/renode_min_test``

Connect to the running interactive instance of Renode
-----------------------------------------------------

``telnet localhost 1234``

Build a specific version of Renode
----------------------------------

``podman build -t renode_min_test ./ -f Dockerfile.min --build-arg RENODE_VERSION=1.16.1``

For more information, visit the `Renode website <https://renode.io>`_, `Renode documentation <https://renode.readthedocs.io>`_ and `Docker documentation <https://docs.docker.com>`_.

