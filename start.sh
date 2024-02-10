#!/bin/bash

# MIT License

# Copyright (c) 2022 Run-Pod

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

setup_ssh() {
  if [[ $PUBLIC_KEY ]]; then
    echo "Setting up SSH..."
    mkdir -p ~/.ssh
    echo "$PUBLIC_KEY" >>~/.ssh/authorized_keys
    chmod 700 -R ~/.ssh

    if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
      ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -q -N ''
      echo "RSA key fingerprint:"
      ssh-keygen -lf /etc/ssh/ssh_host_rsa_key.pub
    fi

    if [ ! -f /etc/ssh/ssh_host_dsa_key ]; then
      ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -q -N ''
      echo "DSA key fingerprint:"
      ssh-keygen -lf /etc/ssh/ssh_host_dsa_key.pub
    fi

    if [ ! -f /etc/ssh/ssh_host_ecdsa_key ]; then
      ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -q -N ''
      echo "ECDSA key fingerprint:"
      ssh-keygen -lf /etc/ssh/ssh_host_ecdsa_key.pub
    fi

    if [ ! -f /etc/ssh/ssh_host_ed25519_key ]; then
      ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -q -N ''
      echo "ED25519 key fingerprint:"
      ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub
    fi

    sudo service ssh start

    echo "SSH host keys:"
    for key in /etc/ssh/*.pub; do
      echo "Key: $key"
      ssh-keygen -lf "$key"
    done
  fi
}

export_env_vars() {
  echo "Exporting environment variables..."
  printenv | grep -E '^RUNPOD_|^PATH=|^_=' | awk -F = '{ print "export " $1 "=\"" $2 "\"" }' >>/etc/rp_environment
  echo 'source /etc/rp_environment' >>~/.bashrc
}

setup_ssh
export_env_vars

/dockerstartup/kasm_default_profile.sh /dockerstartup/vnc_startup.sh /dockerstartup/kasm_startup.sh --wait
