#!/bin/bash

cd /home/ubuntu
docker compose pull
docker compose up -d --build
