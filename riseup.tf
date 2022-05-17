terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.74.0"
    }
  }
}

locals {
  folder_id = "b1gs97sf1m1od813qrbi"
  image_id = "fd86t95gnivk955ulbq8"
  region = "ru-central1-a"
  public_key = "/keys/id_rsa.pub"
  private_key = "/keys/id_rsa"
 }

provider "yandex" {
  token     = "AQAAAAAGNKXEAATuwcIVyOyPpkhwp3iFVD_zW0w"
  cloud_id  = "b1g1itnqmpe22fgrfcaq"
  folder_id = local.folder_id
  zone      = local.region
}

provisioner "local-exec" {
  inline = [
    "chmod 0777 /etc/ansible/hosts",
  ]
}

resource "yandex_compute_instance" "vm-1" {
  name = "builder"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = local.image_id
      type     = "network-ssd"
      size = 20
    }
  }

network_interface {
  subnet_id = yandex_vpc_subnet.subnet-1.id
  nat       = true
}

  metadata = {
    ssh-keys = "ubuntu:${file("${local.public_key}")}"
  }   
}


resource "yandex_compute_instance" "vm-2" {
  name = "stage"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = local.image_id
      type     = "network-ssd"
      size = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("${local.public_key}")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "labnet"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "labsubnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "local_file" "buildhost" {
    filename = "/etc/ansible/hosts" 
    content = <<EOT
    [buildhost]
    ${yandex_compute_instance.vm-1.network_interface.0.nat_ip_address}

    EOT
}

resource "local_file" "stagehost" {
    filename = "/etc/ansible/hosts" 
    content = <<EOT
    [stagehost]
    ${yandex_compute_instance.vm-2.network_interface.0.nat_ip_address}
    
    EOT
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "internal_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.ip_address
}


output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

output "external_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
}