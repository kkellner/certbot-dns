#!/bin/bash
#
# This script is meant to be copied as an example of creating a
# wildcard cert with multiple domains and validated vis aws route53
#
# Copyright (C) 2018 Kurt Kellner - All Rights Reserved
# Licensed under the Apache License, Version 2.0 (the "License");
#
cert_name="lab.mycompany.com"
domain_subject_cn="*.lab.mycompany.com"
domain_sans="*.system.lab.mycompany.com, *.apps.lab.mycompany.com, *.uaa.system.lab.mycompany.com, *.login.system.lab.mycompany.com"

export DNS_TYPE=aws
export CERT_OUTPUT_DIR=${PWD}/letsencrypt

./certbot-dns.sh \
   --agree-tos \
   --manual-public-ip-logging-ok \
   --email my-email@mycompany.com \
   --server https://acme-staging-v02.api.letsencrypt.org/directory \
   --cert-name "${cert_name}" \
   --domains "${domain_subject_cn}" \
   --domains "${domain_sans}"

