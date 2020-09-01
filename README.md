This is the set of terraform, helm, and docker configurations required to manage, operate, and deploy to a no-nonsense version of Kubernetes we call Coopernetes. This project is still in very early alpha developement, and is currently only being used by Colab Coop (https://colab.coop) and itme (https://itme.company). If you are interested in hosting containers and applicaitons on a managed Kubernetes cluster using Coopernetes, or you are interested in deploying the infrastructure yourself, please reach out to friends@colab.coop.

## Branches and Releases
- `master` is our primary working branch. It is intended to be generic, and can be cloned and used by anyone to launch a cluster from scracth.
- `itme` and `colab` correspond to the configurations of the two organizations currently using coopernetes. We each have slightly different needs and architectures, so we're using branches to track the individual changes until we can merge them back to master.1::wq

## Tools
All commands can be installed with `brew install`, except for helm plugins which use `helm plugin install`
To manage the AWS infrastructure:
- `terraform`
- `awscli`
- `wget`

To manage and deploy applications on kubernetes:
- `kubectl`
- `helm`
- `helmfile`
- the helm-diff plugin: `helm plugin install https://github.com/databus23/helm-diff`
- the helm-secrets plugin: `helm plugin install https://github.com/zendesk/helm-secrets`
- `gnu-getopt`: used by helm-secrets
- `velero`: used for backup and restore

## Creating a cluster
Based on the example at https://github.com/terraform-aws-modules/terraform-aws-eks/blob/7de18cd9cd882f6ad105ca375b13729537df9e68/examples/managed_node_groups/main.tf
1. Create a `terraform.tfvars` file based on the sample in the terraform repo to configure your cluster.
1. From inside the `terraform/eks` folder `terraform apply`
  - Terraform generates a couple of config files needed by helmfile / helm. They are put in `terraform/eks/generated`, and the other programs that rely on them link to the files there.
  - The first of these files is `helmfile.yaml` which is a set of non-secret values generated or configured in terraform that are needed by helmfile. This file is imported as the default environment in helmfile, granting charts and configuration access to terraform values. Anything non-secret you want to pass from terraform to helmfile should live here.
  - Secrets are encrypted with helm-secrets, which is confiured using a `.sops.yaml` file in the root folder. In this repo, that file is symlinked to `terraform/eks/generated/sops.yaml`, since the kms key is generated by terraform.
1. Configure kubectl with the generated kubeconfig: `aws eks --region us-west-2 --profile=<AWS_PROFILE> update-kubeconfig --name <CLUSTER_NAME>`
1. `helmfile apply` in the root folder.
1. Once you deploy your first application with an Ingress, run `kubectl get ingress --all-namespaces` to list the address associated with the ingress. That is the load balancer for all inbound requests on the clster. You should create a DNS entry pointing to this load balancer for all services you want to create.
1. Port forward into kibana by running the command from below, then go to Discover menu item, configure the index to `kubernetes_cluster*`, choose a `@timestamp` and Kibana is ready.
1. Once the velero client is installed, you need to run a couple commands to configure and setup backups:
  - Run `velero client config set namespace=system-backups`. This tells velero what namespace we installed it it.
  - Run `velero backup create test-backup` to test the backup functionality
1. Once prometheus-operator is installed, you should add the following dashboard to grafana: https://grafana.com/grafana/dashboards/8670.
  - You can run the grafan dashboard by finding the grafana pod in the system-monitoring namespace, and then running: `kubectl port-forward <GRAFANA_POD> -n system-monitoring 3000:3000`
  - You can log in with the user `admin` and the passwor `prom-operator`. Since you need access to the cluster to port forward, these account credentials can be shared freely.

## Setting up CD for a new project:
All deployment related files, including the chart, helmfile, and Dockfile, should all live in a folder called `.deploy` in the root of the repository.

To deploy, simply launch the `coopernetes-deploy` container in CircleCI and use `coopctl` to deploy
1. Builds a docker image using the Dockerfile at `.deploy/Dockerfile` and the project root as the context.
1. Calls `helfile apply .deploy/helmfile.yaml`.
1. Run `velero schedule create daily-<NAMESPACE>-backup --schedule="0 0 * * *" --include-namespaces <NAMESPACE>` to setup a backup schedule for the namespace.
1. Keep in mind, nodes have a maximum number of pods they can support, as indicated on the following list: https://github.com/awslabs/amazon-eks-ami/blob/master/files/eni-max-pods.txt


If you are using a custom chart for the project, we recommend putting it at `.deploy/chart/`.

## Relevant documents / blog posts for intallation:
1. https://cert-manager.io/docs/tutorials/acme/ingress/
1. https://cert-manager.io/docs/installation/kubernetes/

## Working with the cluster:
- *logs*: `kubectl port-forward deployment/efk-kibana 5601 -n system-logging`
- *kubecost*: `kubectl port-forward deployment/kubecost-cost-analyzer 9090 -n kubecost`
