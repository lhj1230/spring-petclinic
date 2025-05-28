#!/bin/bash

export PATH=$PATH:/usr/local/lib/docker/cli-plugins
cd /home/ubuntu/scripts
docker compose up -d --build
