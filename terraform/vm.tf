resource "google_compute_instance" "vm_instance" {
  name         = "${local.prefix}-vm-bazel-machine"
  machine_type = "n1-standard-4"
  zone         = "us-central1-a"
  tags = ["vm", "tf", "http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
      size = "50"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
  metadata_startup_script = "${file("packages.sh")}"
}

resource "null_resource" "deploy_files" {
  triggers = {
    dir_sha1 = sha1(filesha1("packages.sh"))
  }
}

