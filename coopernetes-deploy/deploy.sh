#!/bin/bash

#DOCKER BUILD

PROJECT_PATH=$(git rev-parse --show-toplevel)
if test -z "$DOCKERFILE"; then
  DOCKERFILE="$PROJECT_PATH/.deploy/Dockerfile"
fi
if test -z "$DOCKER_CONTEXT"; then
  DOCKER_CONTEXT="$PROJECT_PATH/"
fi
if test -z "$DOCKER_REPO"; then
  DOCKER_REPO="colabcoop/$CIRCLE_PROJECT_REPONAME"
fi

GIT_TAG=$(git rev-parse --short HEAD)
export DOCKER_TAG=$DOCKER_REPO:$GIT_TAG

if test -z "$DOCKER_USER" ||
  test -z "$DOCKER_PASSWORD"; then
    >&2 echo "In order to build and publish a docker container, this script requires the following bash variables to be set:"
    >&2 echo "- DOCKER_USER"
    >&2 echo "- DOCKER_PASSWORD"
    >&2 echo "These should all be set in the CircleCI context that corresponds to the cluster you want to deploy to."
    exit 1
fi

# Build and push docker container
if test ! -f "$DOCKERFILE"; then
    >&2 echo "The deploy script expected a Dockerfile at $DOCKERFILE, but found nothing."
    exit 1
fi

echo $DOCKER_PASSWORD | docker login --username $DOCKER_USER --password-stdin
echo Tagging docker image with $DOCKER_TAG
docker build --tag $DOCKER_TAG $DOCKER_CONTEXT -f $DOCKERFILE
docker push $DOCKER_TAG

# HELMFILE APPLY

PROJECT_PATH=$(git rev-parse --show-toplevel)
if test -z "$HELMFILE"; then
  HELMFILE="$PROJECT_PATH/.deploy/helmfile.yaml"
fi

if test -z "$AWS_ACCESS_KEY_ID" ||
  test -z "$AWS_SECRET_ACCESS_KEY" ||
  test -z "$AWS_DEFAULT_REGION" ||
  test -z "$CLUSTER_NAME"; then
    >&2 echo "In order to deploy, this script requires the following bash variables to be set:"
    >&2 echo "- AWS_ACCESS_KEY_ID"
    >&2 echo "- AWS_SECRET_ACCESS_KEY"
    >&2 echo "- AWS_DEFAULT_REGION"
    >&2 echo "- CLUSTER_NAME"
    >&2 echo "These should all be set in the CircleCI context that corresponds to the cluster you want to deploy to."
    exit 1
fi

# Deploy to kubernetes
if test ! -f "$HELMFILE"; then
    >&2 echo "The deploy script expected a helmfile at $HELMFILE, but found nothing."
    exit 1
fi
aws eks --region $AWS_DEFAULT_REGION update-kubeconfig --name $CLUSTER_NAME
helmfile --file $HELMFILE apply
