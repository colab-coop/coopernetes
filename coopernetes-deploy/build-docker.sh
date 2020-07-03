#!/bin/bash

PROJECT_PATH=$(git rev-parse --show-toplevel)
if test -z "$DOCKERFILE"; then
  DOCKERFILE="$PROJECT_PATH/.deploy/Dockerfile"
fi
if test -z "$DOCKER_CONTEXT"; then
  DOCKER_CONTEXT="$PROJECT_PATH/"
fi
if test -z "$DOCKER_REPO"; then
  DOCKER_REPO=colabcoop/$CIRCLE_PROJECT_REPONAME
fi

GIT_TAG=$(git rev-parse --short HEAD)
export DOCKER_TAG=$DOCKER_REPO:$GIT_TAG

if test -z "$DOCKER_USER" ||
  test -z "$DOCKER_PASSWORD" ||
    >&2 echo "In order to build and publish a docker container, this script requires the following bash variables to be set:"
    >&2 echo "- DOCKER_USER"
    >&2 echo "- DOCKER_PASSWORD"
    >&2 echo "These should all be set in the CircleCI context that corresponds to the cluster you want to deploy to."
    exit 1
fi

# Build and push docker container
if [ ! -f "$DOCKERFILE" ]; then
    >&2 echo "The deploy script expected a Dockerfile at $DOCKERFILE, but found nothing."
    exit 1
fi

echo $DOCKER_PASSWORD | docker login --username $DOCKER_USER --password-stdin
echo Tagging docker image with $DOCKER_TAG
docker build --tag $DOCKER_TAG $DOCKER_CONTEXT -f $DOCKERFILE
docker push $DOCKER_TAG
