#!/bin/bash

# Set the name of the docker image, container and zip file for website
IMAGE_NAME="devops-website-image"
CONTAINER_NAME="devops-website-container"
WEBSITE_ZIP_FILE="car-repair-html-template.zip"

# Unzip the webpage of choice
unzip $WEBSITE_ZIP_FILE

# Start a container from the base image
docker run --name $CONTAINER_NAME -d -p 8080:80 nginx:alpine

# Copy the website files into the container
docker cp ./car-repair-html-template/. $CONTAINER_NAME:/usr/share/nginx/html

# Commit the container's state to a new image
docker commit $CONTAINER_NAME $IMAGE_NAME

# Notify user
echo "Docker image $IMAGE_NAME has been created and is running on http://localhost:8080"
