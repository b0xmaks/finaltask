terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.74.0"
    }
  }
}

locals {
  folder_id = "b1gfltbs1jo2gj8g55rp"
  image_id = "fd86t95gnivk955ulbq8"
  region = "ru-central1-a"
  public_key = "/keys/id_rsa.pub"
  private_key = "/keys/id_rsa"
  bucket_name = "hosts"
}

provider "yandex" {
  token     = "AQAAAAAGNKXEAATuwcIVyOyPpkhwp3iFVD_zW0w"
  cloud_id  = "b1g055n8e3mua2rcu67m"
  folder_id = local.folder_id
  zone      = local.region
}

resource "yandex_iam_service_account" "sa" {
  folder_id = local.folder_id
  name      = "tf-test-sa"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = local.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

resource "yandex_storage_bucket" "hosts" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = local.bucket_name
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

resource "yandex_storage_object" "hosts" {
  bucket = "hosts"
  key    = "bulder-host.txt"
  content = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
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

//resource "yandex_storage_object" "hosts" {
//  bucket = "hosts"
//  key    = "stage-host.txt"
//  content = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
//}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
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