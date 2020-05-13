This is the set of terraform and helm comfigurations for Colab's brand new kubernetes cluster.

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
- https://github.com/awslabs/amazon-ecr-credential-helper

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
