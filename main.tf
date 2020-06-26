# Configure the Google Cloud provider
provider "google" {
  credentials = file("creds/account.json")
  project     = var.project
  region      = var.region
}

variable "project" {
  type = string
  description = "Google Cloud project name"
}

variable "region" {
  type = string
  description = "Default Google Cloud region"
}

variable "general_purpose_machine_type" {
  type = string
  description = "Machine type to use for the general-purpose node pool. See https://cloud.google.com/compute/docs/machine-types"
}

variable "general_purpose_node_count" {
  type = string
  description = "The maximum number of nodes PER ZONE in the general-purpose node pool"
  default = 1
}

variable "vpc_network_ports" {
  type = list(string)
  description = "vpc network ports range"
  default = ["22", "80"]
}

variable "ss_passwd" {
  type = string
  description = "shadowsocks password"
  default = "sUpeR_secret_PasswOrd!&*"
}

variable "ss_port" {
  type = string
  description = "shadowsocks port"
  default = "8000"
}

# 3 resources(network, firewall, compute engine)
resource "google_compute_network" "vpc_network" {
  name                    = "${var.project}-network"
  auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "ss-firewall" {
  name    = "${var.project}-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = var.vpc_network_ports
  }
}

resource "google_compute_instance" "vm_instance-" {
  count = var.general_purpose_node_count
  name = "${var.project}-general-${count.index}"
  zone = var.region
  machine_type = var.general_purpose_machine_type

  tags = ["ss", "shadowsocks"]

  boot_disk {
    initialize_params {
      image = "gce-uefi-images/ubuntu-1804-lts"
      size = "80"
    }
  }

#  metadata_startup_script = file("startup.sh")
  metadata_startup_script = templatefile("./startup.sh", {SS_PASSWD = var.ss_passwd, SS_PORT = var.ss_port})


  network_interface {
    network = google_compute_network.vpc_network.self_link
    access_config {
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  depends_on = [google_compute_firewall.ss-firewall]
  connection {
    type = "ssh"
    user = "ubuntu"
    host = google_compute_instance.vm_instance-[count.index].network_interface.0.access_config.0.nat_ip
    private_key = file("~/.ssh/id_rsa")
  }

  # provisioner "file" {
  #   source      = "run-ss-server.sh"
  #   destination = "/home/ubuntu/run-ss-server.sh"
  # }
}
