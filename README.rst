Renode Docker image
===================

This repository contains a Dockerfile for Renode.

Running ``build.sh`` downloads and builds the newest version from the Renode git repository on top of a Ubuntu image.

``run.sh`` starts Renode in an interactive mode.
You can provide other command as a parameter to this script instead.

To mount your own local directory, modify the ``run.sh`` script by adding more ``-v`` switches.

For more information, visit to `Renode website <renode.io>`_, `Renode documentation <renode.readthedocs.io>`_ and `Docker documentation <docs.docker.com>`_.
