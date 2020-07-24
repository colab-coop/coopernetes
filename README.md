This is the set of terraform, helm, and docker configurations required to manage, operate, and deploy to a no-nonsense version of Kubernetes we call Coopernetes. This project is still in very early alpha developement, and is currently only being used by Colab Coop (https://colab.coop) and itme (https://itme.company). If you are interested in hosting containers and applicaitons on a managed Kubernetes cluster using Coopernetes, or you are interested in deploying the infrastructure yourself, please reach out to friends@colab.coop.

## Branches and Releases
- `master` is our primary working branch. It is intended to be generic, and can be cloned and used by anyone to launch a cluster from scracth.
- `itme` and `colab` correspond to the configurations of the two organizations currently using coopernetes. We each have slightly different needs and architectures, so we're using branches to track the individual changes until we can merge them back to master.1::wq

## Tools
To manage the AWS infrastructure:
- `terraform`
- `awscli`
- `wget`

To manage and deploy applications on kubernetes:
- `kubectl`
- `helm`
- `helmfile`
- the helm-diff plugin: `helm plugin install https://github.com/databus23/helm-diff`
- the helm-secrets plugin: `helm plugin install https://github.com/futuresimple/helm-secrets`

## Creating a cluster
Forked from the steps at https://learn.hashicorp.com/terraform/kubernetes/provision-eks-cluster
1. From inside the `eks` folder `terraform apply`
1. Configure kubectl with the generated kubeconfig: `aws eks --region us-east-1 --profile=coopernetes update-kubeconfig --name coopernetes-test-vxA2m96J`
1. From inside the `kubernetes` folder run `terraform apply`: NOTE: These must be done as separate steps because the kubeconfig generated in step one is necessary to configure the kubernetes provider.
1. Sometimes the aws auth map doesn't apply (https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/faq.md#aws-auth-configmap-not-present). As a result the worker nodes will launch but be unable to communicate with the cluster. It can be fixed manually by following the instructions here: https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html.
1. `helmfile apply` in the root folder

## Deploying a new application
1. Dockerize the application
1. Create an ecr registry for the application in `terraform/ENV/REGION/apps/APP_NAME.tf`
1. Build the image, tag it with the repo name and the commit hash, and push it to the new ecr registry
1. Create a database, if needed
1. Write a chart for the app, in it's own git repo

## Setting up CD for a new project:
All deployment related files, including the chart, helmfile, and Dockfile, should all live in a folder called `.deploy` in the root of the repository.

To deploy, simply launch the `coopernetes-deploy` container in CircleCI, and then call the `deploy.sh` script. This script does two things:
1. Builds a docker image using the Dockerfile at `.deploy/Dockerfile` and the project root as the context.
2. Calls `helfile apply .deploy/helmfile.yaml`.

If you are using a custom chart for the project, we recommend putting it at `.deploy/chart/`.

## Relevant documents / blog posts for intallation:
1. https://cert-manager.io/docs/tutorials/acme/ingress/
1. https://cert-manager.io/docs/installation/kubernetes/
