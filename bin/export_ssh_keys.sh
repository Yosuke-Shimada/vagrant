#! /bin/bash -e

if [[ ! -e ~/.ssh/id_ecdsa_vagrant ]]; then
  ssh-keygen -t ecdsa -b 521 -C "only used by vagrant" -f ~/.ssh/id_ecdsa_vagrant
fi

