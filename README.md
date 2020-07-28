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
Based on the example at https://github.com/terraform-aws-modules/terraform-aws-eks/blob/7de18cd9cd882f6ad105ca375b13729537df9e68/examples/managed_node_groups/main.tf
1. From inside the `terraform/eks` folder `terraform apply`
1. Configure kubectl with the generated kubeconfig: `aws eks --region us-west-2 --profile=<AWS_PROFILE> update-kubeconfig --name <CLUSTER_NAME>`
1. `helmfile apply` in the root folder.

## Setting up CD for a new project:
All deployment related files, including the chart, helmfile, and Dockfile, should all live in a folder called `.deploy` in the root of the repository.

To deploy, simply launch the `coopernetes-deploy` container in CircleCI and use `coopctl` to deploy
1. Builds a docker image using the Dockerfile at `.deploy/Dockerfile` and the project root as the context.
2. Calls `helfile apply .deploy/helmfile.yaml`.

If you are using a custom chart for the project, we recommend putting it at `.deploy/chart/`.

## Relevant documents / blog posts for intallation:
1. https://cert-manager.io/docs/tutorials/acme/ingress/
1. https://cert-manager.io/docs/installation/kubernetes/
