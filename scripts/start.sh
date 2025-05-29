#!/bin/bash

# Stop and remove if running
docker stop spring-petclinic || true
docker rm spring-petclinic || true

# 강제로 포트 점유한 컨테이너도 제거
CONTAINER_ID=$(docker ps -q --filter "publish=80")
if [ -n "$CONTAINER_ID" ]; then
  docker stop "$CONTAINER_ID"
  docker rm "$CONTAINER_ID"
fi

# Run with mounted latest jar
docker run -d -p 80:8080 \
  --name spring-petclinic \
  -v /home/ubuntu/target:/app \
  openjdk:21 \
  java -jar /app/spring-petclinic-*.jar

