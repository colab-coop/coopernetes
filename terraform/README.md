The terraform folder is designed to help you bootstrap a cluster if you don't have one already. The subfolders should each represent a different kubernetes provider (EKS, GKE, Digital Ocean, etc). We currently only support EKS, but pull request are welcome.

# Running and configuring terraform
Once you clone your copy of the repository, edit the sample.tfvars file, configure your AWS env, and apply the folder to create your cluster.
