Renode Docker image
===================

This repository contains a Dockerfile for Renode.

Running ``build.sh`` downloads and installs the newest release of Renode on top of a Ubuntu image.

``run.sh`` starts Renode in interactive mode.
You can provide another command as a parameter to this script instead.

To mount your own local directory, modify the ``run.sh`` script by adding more ``-v`` switches.

For more information, visit the `Renode website <renode.io>`_, `Renode documentation <renode.readthedocs.io>`_ and `Docker documentation <docs.docker.com>`_.
