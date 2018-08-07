#!/bin/bash

docker run -ti --rm -e DISPLAY=:0 -v /tmp/.X11-unix:/tmp/.X11-unix renode_docker $@
