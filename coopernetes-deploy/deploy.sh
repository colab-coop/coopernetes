#!/bin/bash

if test -z "$DOCKERFILE"; then
  DOCKERFILE="$CIRCLE_WORKING_DIRECTORY/.deploy/Dockerfile"
fi
if test -z "$HELMFILE"; then
  HELMFILE="$CIRCLE_WORKING_DIRECTORY/.deploy/helmfile.yaml"
fi

DOCKER_REPO=colabcoop/$CIRCLE_PROJECT_REPONAME
GIT_TAG=$(git rev-parse --short HEAD)
export DOCKER_TAG=$DOCKER_REPO:$GIT_TAG

if test -z "$DOCKER_USER" ||
  test -z "$DOCKER_PASSWORD" ||
  test -z "$AWS_ACCESS_KEY_ID" ||
  test -z "$AWS_SECRET_ACCESS_KEY" ||
  test -z "$AWS_DEFAULT_REGION" ||
  test -z "$CLUSTER_NAME"; then
    >&2 echo "In order to deploy, this script requires the following bash variables to be set:"
    >&2 echo "- DOCKER_USER"
    >&2 echo "- DOCKER_PASSWORD"
    >&2 echo "- AWS_ACCESS_KEY_ID"
    >&2 echo "- AWS_SECRET_ACCESS_KEY"
    >&2 echo "- AWS_DEFAULT_REGION"
    >&2 echo "- CLUSTER_NAME"
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
docker build --tag $DOCKER_TAG $CIRCLE_WORKING_DIRECTORY -f $DOCKERFILE
docker push $DOCKER_TAG

# Deploy to kubernetes
if [ ! -f "$HELMFILE" ]; then
    >&2 echo "The deploy script expected a helmfile at $HELMFILE, but found nothing."
    exit 1
fi
aws eks --region $AWS_DEFAULT_REGION update-kubeconfig --name $CLUSTER_NAME
helmfile --file $HELMFILE apply
