provider "google" {
 project     = "possible-jetty-239813"
 region      = "europe-west1"
}

resource "random_id" "instance_id" {
 byte_length = 8
}

resource "google_compute_instance" "free-kittens" {
 name = "free-kittens-vm-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone = "europe-west1-b"

 boot_disk {
  initialize_params {
   image = "gce-uefi-images/centos-7"
  }
 }

 metadata_startup_script = "sudo yum -q -y update; sudo yum -q -y install epel-release; sudo yum -q -y install nginx; sudo systemctl start nginx"

 network_interface {
  network = "default"

  access_config {
  }
 }

 metadata {
  sshKeys = "panther:${file("id_ed25519.pub")}"
 }
}


resource  "google_compute_firewall" "default" {
 name    = "nginx-firewall"
 network = "default"

allow {
 protocol = "tcp"
 ports = ["80","443"]
}
allow {
 protocol = "icmp"
}
}

output "ip" {
 value = "${google_compute_instance.free-kittens.network_interface.0.access_config.0.nat_ip}"
}
