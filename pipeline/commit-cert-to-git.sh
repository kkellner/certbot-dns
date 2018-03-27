#!/bin/bash

set -eux

CERT_OUTPUT_DIR=letsencrypt

git clone cert-repo cert-repo-modified

# Copy all the generated certs into the repo ()
mkdir -p cert-repo-modified/proxy-certs
cp -R --dereference ${CERT_OUTPUT_DIR}/live/* cert-repo-modified/proxy-certs

cd cert-repo-modified

git config --global user.email "${EMAIL_ADDRESS}"
git config --global user.name "${EMAIL_ADDRESS}"

git add .
git commit -m "add new lab proxy cert file from LetsEncrypt"