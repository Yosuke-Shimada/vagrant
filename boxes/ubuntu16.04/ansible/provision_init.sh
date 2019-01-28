#! /bin/bash -e

# yum update all
sudo apt-get update -y

# dotfiles
chmod 600 ~/.ssh/id_rsa
cd ~
if [ -e ./dotfiles ]; then
  git clone git@github.com:chan-yo/dotfiles.git
  /bin/bash ./bin/initialize/initialize.sh
fi

# ansible
sudo apt-get install software-properties-common -y
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update -y
sudo apt-get install ansible -y
ansible-playbook -i 127.0.0.1 /vagrant/ansible/playbook.yml
