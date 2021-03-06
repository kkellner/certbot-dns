#!/bin/bash

set -eux

CERT_OUTPUT_DIR=letsencrypt

git clone cert-repo cert-repo-modified

# Copy all the generated certs into the repo ()
#mkdir -p cert-repo-modified/letsencrypt
cp -R ${CERT_OUTPUT_DIR} cert-repo-modified

cd cert-repo-modified

if [[ -n $(git status -s) ]]; then 
  git config --global user.email "${EMAIL_ADDRESS}"
  git config --global user.name "${EMAIL_ADDRESS}"

  git add .
  git commit -m "add new lab proxy cert file from LetsEncrypt"

else
  echo "Nothing to commit -- certs must not have been updated"
fi
