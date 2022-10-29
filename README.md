# Task
A helm chart for deploying hextris.


1. Create a local Kubernetes cluster (example Kind) using Terraform
2. Create a helm chart for deployment of a hextris game (https://github.com/Hextris/hextris)
3. Deploy the helm chart on the Kubernetes cluster

# Solution
Prerequisites:
* Linux VM (tested on Ubuntu 22.04.1 LTS) with internet connection
* Packages installed on mentioned VM above:
    1. docker
    2. terraform
    3. helm
    4. kubectl

Workflow:
1. Create a local Kubernetes cluster with KIND (https://kind.sigs.k8s.io/) using Terraform. The code is located in `terraform-kind` directory.
   * `cluster.tf` - terraform resource for deploying KIND
   * `namespace.tf` - terraform resource for creating a namespace inside of a deployed Kubernetes cluster (in a specified namespace HEXTRIS app will be later deployed)
   * `secret.tf` - optional terraform resource for adding a secret to Kubernetes cluster containing a self-signed certificates for securing the ingress route
   * `variables.tf` - in order to make my terraform code more generic, I put the most important variables into one file, such as: **cluster_name**, **kubernetes_namespace** and **cluster_config_path**
   * `versions.tf` - in case of provider version change requirement, used providers versions are specified in separate configuration file
   
   Make sure you current directory is `terraform-kind`, then:

      * ```terraform init``` - to initialize working directory and install required providers
      * ```terraform plan``` - (optional) to see an execution plan that Terraform is going to make
      * ```terraform apply -auto-approve``` - executes proposed plan in order to create infrastructure

2. Build a docker image of HEXTRIS application
   * `docker build -t hextris .`

