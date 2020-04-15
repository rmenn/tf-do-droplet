variable "hostname" {
  description = "The hostname applied to this digitalocean-droplet."
}

variable "digitalocean_region" {
  description = "The DigitalOcean region-slug to start this digitalocean-droplet within (nyc1, sgp1, lon1, nyc3, ams3, fra1, tor1, sfo2, blr1)"
}

# variables - with defined defaults
# ============================================================================

variable "initial_user" {
  description = "The initial user account to create at this digitalocean-droplet - if not root account then the root account will be disabled via sshd_config PermitRootLogin no."
  default = "root"
}

variable "initial_user_sshkeys" {
  type = "list"
  description = "The list of ssh authorized_keys values to apply to the initial_user account - the actual ssh public key(s) must be supplied not a reference to an ssh key within a digitalocean account."
  default = []
}

variable "digitalocean_image" {
  description = "The digitalocean image to use as the base for this digitalocean-droplet."
  default = "ubuntu-18-04-x64"    # tested and confirmed 2018-07-18
}

variable "digitalocean_size" {
  description = "The digitalocean droplet size to use for this digitalocean-droplet."
  default = "s-1vcpu-1gb"
}

variable "user_data" {
  description = "User supplied cloudinit userdata."
  default = "#!/bin/sh"
}

variable "digitalocean_ssh_keys" {
  type = "list"
  description = "A list of Digital Ocean SSH ids or sshkey fingerprints to apply to the root account - overwritten by `initial_user_sshkeys` if `initial_user` is root."
  default = []
}

