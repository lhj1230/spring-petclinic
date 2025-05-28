#!/bin/bash

export PATH=$PATH:/home/ubuntu/.docker/cli-plugins
cd /home/ubuntu/scripts
docker compose up -d --build
