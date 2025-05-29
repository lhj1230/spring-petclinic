#!/bin/bash

docker stop spring-petclinic || true
docker rm spring-petclinic || true

docker run -d -p 80:8080 \
  -v /home/ubuntu/target:/app \
  --name spring-petclinic \
  openjdk:21 java -jar /app/spring-petclinic-*.jar

