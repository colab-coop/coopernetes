This is the folder for creating the CirlceCI deployment container. It contains all the tools necessary to deploy to the cluster. It also includes a script called deploy.sh which will be used to actually run the deploy.

# Env Vars
It expects the following env-vars to be set (will come from the coopernetes CircleCI context):
 - DOCKER_USER
 - DOCKER_PASSWORD
 - AWS_ACCESS_KEY_ID (User must have permission to deploy to cluster)
 - AWS_SECRET_ACCESS_KEY
 - AWS_DEFAULT_REGION
 - CLUSTER_NAME

# Deploying the Deploy Container
$ docker login
$ docker push colabcoop/deploy-to-coopernetes:$VERSION
