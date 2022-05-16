terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.74.0"
    }
  }
}

locals {
  folder_id = "b1g35u1fgpj0eea2lqig"
  image_id = "fd86t95gnivk955ulbq8"
  region = "ru-central1-a"
  public_key = "/keys/id_rsa.pub"
  private_key = "/keys/id_rsa"
 }

provider "yandex" {
  token     = "AQAAAAAGNKXEAATuwcIVyOyPpkhwp3iFVD_zW0w"
  cloud_id  = "b1gv3kn8mkcufn39kr9d"
  folder_id = local.folder_id
  zone      = local.region
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
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "local_file" "buildhost" {
    content  = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
    filename = "${path.module}/buildhost"
}

resource "local_file" "stagehost" {
    content  = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
    filename = "${path.module}/stagehost"
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