#!/bin/bash

cd /home/ubuntu

docker compose down
docker compose up -d --build
