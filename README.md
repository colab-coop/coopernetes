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

## Creating a cluster
1. From inside the terraform folder `terraform apply`
1. Sometimes the aws auth map doesn't apply (https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/faq.md#aws-auth-configmap-not-present). As a result the worker nodes will launch but be unable to communicate with the cluster. It can be fixed manually by following the instructions here: https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html.
1. `helmfile apply` in the root folder
