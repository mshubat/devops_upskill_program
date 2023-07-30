#!/bin/bash

WEBSITE_ZIP_FILE="car-repair-html-template.zip"

WEB_IMAGE_NAME="devops-website-image"
WEB_CONTAINER_NAME="devops-website-container"
DB_CONTAINER_NAME="mock-mysql"


# Unzip the webpage of choice
unzip -qq $WEBSITE_ZIP_FILE

# Start a container from the base image
docker run --name $WEB_CONTAINER_NAME -d -p 8080:80 nginx:alpine

# Copy the website files into the container
docker cp ./car-repair-html-template/. $WEB_CONTAINER_NAME:/usr/share/nginx/html

# Commit the container's state to a new image
docker commit $WEB_CONTAINER_NAME $WEB_IMAGE_NAME

# Notify user
echo "Docker image $WEB_IMAGE_NAME has been created and is running on http://localhost:8080"

# Setup the MySQL container
echo "Creating the MySQL container..."
docker run --name $DB_CONTAINER_NAME -e MYSQL_ROOT_PASSWORD=fake_password -d mysql:latest

echo "Settings up the network..."

if [ ! "$(docker network ls | grep my-network)" ]; then
  echo "Creating my-network..."
  docker network create my-network
else
  echo "my-network exists."
fi

docker network connect my-network $WEB_CONTAINER_NAME
docker network connect my-network $DB_CONTAINER_NAME


