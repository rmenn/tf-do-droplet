data "template_file" "droplet-bootstrap-sh" {
  template = "${file("${path.module}/bootstrap.sh")}"
  vars = {

    initial_user = "${var.initial_user}"
    initial_user_sshkeys = "${join("\n", var.initial_user_sshkeys)}"

  }
}

data "template_cloudinit_config" "droplet-userdata" {
  gzip = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    filename = "10-terraform-bootstrap"
    content = "#!/bin/sh\necho -n '${base64gzip(data.template_file.droplet-bootstrap-sh.rendered)}' | base64 -d | gunzip | /bin/sh"
  }

  part {
    content = "${var.user_data}"
    filename = "20-userdata-bootstrap"
  }
}

resource "digitalocean_droplet" "droplet" {
  image = "${var.digitalocean_image}"
  name = "${var.hostname}"
  region = "${var.digitalocean_region}"
  size = "${var.digitalocean_size}"
  ssh_keys = "${var.digitalocean_ssh_keys}"
  user_data = "${data.template_cloudinit_config.droplet-userdata.rendered}"
}
