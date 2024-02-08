# Create EC2 instance using Terraform

Automatic deployment of EC2 instance with nginx using Terraform.

### Pre-requisites
1. Existing aws access and secret keys configured through aws cli.
2. Existing IAM role and public and private keys for the EC2 instance.

### Conclusions
1. Three public and three private subnets are created accross different availability zones.
2. Nginx on the EC2 instance public IP is accessible through HTTP
3. EC2 instances on Private IP are not accessible through HTTP since NAT Gateway is not used.



