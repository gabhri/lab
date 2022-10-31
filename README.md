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
   * `secret.tf` - (optional) terraform resource for adding a secret to Kubernetes cluster containing a self-signed certificates for securing the ingress route (self-signed certificates are provided in certs directory)
   * `variables.tf` - in order to make my terraform code more generic, I put the most important variables into one file, such as: **cluster_name**, **kubernetes_namespace** and **cluster_config_path**
   * `versions.tf` - in case of provider version change requirement, used providers versions are specified in separate configuration file
   
   Make sure you current directory is `terraform-kind`, then:

      * ```terraform init``` - to initialize working directory and install required providers
      * ```terraform plan``` - create an execution plan that Terraform is going to make
      * ```terraform apply -auto-approve``` - executes proposed plan in order to create infrastructure. Terraform code is written with respect to dependencies, but it may happen that terraform state will be showing KIND as deployed, but KIND still might be in booting state. In case of ERROR, just wait a couple of minutes and try again. Works for sure. 
      
   You can verify cluster deployment with:
      * `docker ps -a` - to see if all docker containers are running
      * `kubectl get all` - to check if you see ClusterIP

2. Create a helm chart for deployment of a HEXTRIS game

   Build a docker image of HEXTRIS application
   * `docker build -t hextris .` - this command build docker image of a Hextris application with the tag **latest**
   * `docker images` - to verify if you see built image
   
   Now, as there is no docker registry that KIND could access, we need to upload newly built docker image to the cluster:
      * `kind load docker-image hextris:latest --name lab` - upload docker image to KIND
      * `docker exec -it $(kind get clusters | head -1)-control-plane crictl images` - list all images in KIND, make sure you see uploaded image
      * Alternatively we could push a new docker image to accessible docker registry
      
   A created helm chart with specified docker image is located in `helm-hextris` directory. Also as an **optional** feature ingress is preconfigured to serve an appplication on port 80 or 443 (depending on variables set in values.yaml). IMPORTANT: KIND is not a real Kubernetes deployment, so additional steps of configuring INGRESS to work are needed, such as: correct host specification, DNS configuration on a VM, etc. - Not a scope of a current task. Rather a concept of how it could be expanded. 
   
3. Deploy the helm chart to Kubernetes cluster
   * `helm install hextris ./helm-hextris/ -n hextris` - this command installing helm chart from **helm-hextris** directory into the **hextris** namespace in Kubernetes cluster with name of hextris
   * `kubectl get all -n hextris` - you can verify that Hextris application is running correctly, pod should be in Running state
   * `values.yaml` - used for variables/values needed/wanted for Helm Chart
   * `helm install hextris ./helm-hextris/ -n hextris` - if you made changes to values.yaml and want to redeploy/upgrade the installation of Helm Chart.

 


