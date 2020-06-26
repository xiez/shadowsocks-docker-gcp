## Objective

1. Create a new virtual machine on GCP using Terraform, and setup network policy as well.
2. Install docker and [Shadowsocks server](https://shadowsocks.org/en/index.html) after machine provision.


## Steps

1. init terraform

```
terraform init
```

2. update `dev.tfvars` accordingly & run plan

```
cp dev.tfvars.tmpl dev.tfvars
vi dev.tfvars

terraform plan -var-file=dev.tfvars
```

3. apply

```
terraform apply -var-file=dev.tfvars
```


## Destroy all resources or destroy specific resource

```
terraform destroy -var-file=dev.tfvars

terraform destroy -var-file=dev.tfvars -target google_compute_instance.vm_instance-\[0\]
```


## TODO

1. Create multiple instances in differente regions to find fastest region to connect.

## Refs

1. https://www.pilosa.com/blog/terraform-experiment/
