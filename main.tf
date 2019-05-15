provider "google" {
 project     = "ikea-dt-splunkrix-test"
 region      = "europe-west1"
}

resource "random_id" "instance_id" {
 byte_length = 8
}

resource "google_compute_instance" "splunk-bigredbutton-idx" {
 name = "splunk-bigredbutton-idx-vm-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone = "europe-west1-b"
 tags = ["splunk-bigredbutton"]

 boot_disk {
  initialize_params {
   image = "gce-uefi-images/centos-7"
  }
 }

 metadata_startup_script = "sudo yum -q -y update"

 network_interface {
  network = "default"

  access_config {
  }
 }
}

resource "google_compute_instance" "splunk-bigredbutton-hf" {
 name = "splunk-bigredbutton-hf-vm-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone = "europe-west1-b"
 tags = ["splunk-bigredbutton"]

 boot_disk {
  initialize_params {
   image = "gce-uefi-images/centos-7"
  }
 }

 metadata_startup_script = "sudo yum -q -y update"

 network_interface {
  network = "default"

  access_config {
  }
 }

 //metadata {
  //sshKeys = "panther:${file("id_ed25519.pub")}"
// }
}

output "idx-ip" {
 value = "${google_compute_instance.splunk-bigredbutton-idx.network_interface.0.access_config.0.nat_ip}"
 }
output "hf-ip" {
value = "${google_compute_instance.splunk-bigredbutton-hf.network_interface.0.access_config.0.nat_ip}"
}
