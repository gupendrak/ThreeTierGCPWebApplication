#!/bin/bash
if [[ $# -ne 1 || $1 -ne "backend" || $1 -ne "frontend" ]]; then
    echo "Script takes one arguement which must be either 'backend' or 'frontend'. Value given: '$1'"
    exit 1
fi

echo "Running docker pipeline for: $1"
echo ""

# Define the GCR path
# gcr_image="gcr.io/$GOOGLE_PROJECT_ID/gcpwebapp-$1:1.1"
dockerhub_image="gupendrak/gcpwebapp-$1:1.6"

echo "Building container"
# build_command="docker build $1 -f $1/$1.dockerfile -t $gcr_image"
# build_command="docker buildx build $1 -f $1/$1.dockerfile -t $gcr_image --platform=linux/amd64"
build_command="docker buildx build $1 -f $1/$1.dockerfile -t $dockerhub_image --platform=linux/amd64 --load"
echo -e "\t$build_command"
eval $build_command
echo "showing built images below"
docker images | grep $dockerhub_image


# echo "Pushing container to GCR"
# push_command="docker push $gcr_image"

echo "Pushing container to Docker Hub"
push_command="docker push $dockerhub_image"
echo -e "\t$push_command"
eval $push_command
echo ""
