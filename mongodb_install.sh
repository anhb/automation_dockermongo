#!/bin/bash

echo "Initializing docker service"
systemctl start docker
echo "Activating docker service"
systemctl enable docker
echo "Downloading mongodb docker image"
docker pull mongo
echo "Creating directory"
mkdir -p /mongodata
echo "Running docker container"
docker run -it -v mongodata:/data/db -p 27017:27017 --name mongodb -d mongo


