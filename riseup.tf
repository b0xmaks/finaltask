terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.74.0"
    }
  }
}

provider "yandex" {
  token     = "AQAAAAAGNKXEAATuwcIVyOyPpkhwp3iFVD_zW0w"
  cloud_id  = "b1g055n8e3mua2rcu67m"
  folder_id = "b1gfltbs1jo2gj8g55rp"
  zone      = "ru-central1-b"
}

//resource "yandex_dns_zone" "zone1" {
//  name        = "finaltask"
//  description = "Example public zone"

//  labels = {
//    label1 = "finaltask"
//  }

//  zone    = "example.finaltask.com."
//  public  = true
//}

//resource "yandex_dns_recordset" "rs1" {
//  zone_id = yandex_dns_zone.zone1.id
//  name    = "example.finaltask.com."
//  type    = "A"
//  ttl     = 200
//  data    = ["10.1.0.1"]
//}
resource "yandex_compute_instance" "vm-1" {
  name = "builder"
  platform_id = "standard-v3"
  zone        = "ru-central1-b"
  hostname = "builder"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd86t95gnivk955ulbq8"
      type     = "network-ssd"
      size = 20

    }
  }

//network_interface {
//  subnet_id = yandex_vpc_subnet.subnet-1.id
//  nat       = true
//}

network_interface {
  network_id = "${enpn7v4n97lo5sibtk7a}"
  subnet_ids = ["${e2lg8u6cpv2lkdbr07kp}"]
  nat       = true
}

  metadata = {
    ssh-keys = "ubuntu:${file("/keys/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "vm-2" {
  name = "stage"
  platform_id = "standard-v3"
  zone        = "ru-central1-b"
  hostname = "stage"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd86t95gnivk955ulbq8"
      type     = "network-ssd"
      size = 20

    }
  }

//  network_interface {
//    subnet_id = yandex_vpc_subnet.subnet-1.id
//    nat       = true
//  }
network_interface {
  network_id = "${enpn7v4n97lo5sibtk7a}"
  subnet_ids = ["${e2lg8u6cpv2lkdbr07kp}"]
  nat       = true
}

  metadata = {
    ssh-keys = "ubuntu:${file("/keys/id_rsa.pub")}"
  }
}

//resource "yandex_vpc_network" "network-1" {
//  name = "network1"
//  name = "default"
//}

//resource "yandex_vpc_subnet" "subnet-1" {
//  name           = "default"
//  zone           = "ru-central1-b"
//  network_id     = yandex_vpc_network.network-1.id
//  v4_cidr_blocks = ["10.129.0.0/24"]
//}

//output "internal_ip_address_vm_1" {
//  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
//}

//output "internal_ip_address_vm_2" {
//  value = yandex_compute_instance.vm-2.network_interface.0.ip_address
//}


//output "external_ip_address_vm_1" {
//  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
//}

//output "external_ip_address_vm_2" {
//  value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
//}