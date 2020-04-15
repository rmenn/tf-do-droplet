#!/bin/sh

# ensure sudo group exists
if [ $(grep '^sudo\:' /etc/group | wc -l) -lt 1 ]; then
    groupadd --system "sudo"
fi

# sudo group no password
echo "%sudo ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/50-sudo-nopasswd

# initial_user
if [ $(grep "^${initial_user}\:" /etc/passwd | wc -l) -lt 1 ]; then
    useradd --shell "/bin/bash" --groups "sudo" --create-home "${initial_user}"
fi

# initial_user_path
if [ "${initial_user}" = "root" ]; then
    initial_user_path="/root"
else
    initial_user_path="/home/${initial_user}"
fi

# initial_user_sshkeys
if [ $(echo -n "${initial_user_sshkeys}" | wc -c) -gt 16 ]; then
    mkdir -p "$initial_user_path/.ssh"
    echo -n "${initial_user_sshkeys}" > "$initial_user_path/.ssh/authorized_keys"
    chown -R "${initial_user}":"${initial_user}" "$initial_user_path/.ssh"
    chmod 0700 "$initial_user_path/.ssh"
    chmod 0600 "$initial_user_path/.ssh/authorized_keys"
fi

# remove root passwd
sed -i -e '/^root:/s/^.*$/root:\*:17939:0:99999:7:::/' /etc/shadow

# disable root ssh login
if [ "${initial_user}" != "root" ]; then
    rm -f "/root/.ssh/*.pub"
    rm -f "/root/.ssh/authorized_keys"
    sed -i -e '/^PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
    /etc/init.d/ssh reload
fi
