#!/bin/sh

set -eux

certbot certonly \
     --non-interactive \
     --agree-tos \
     --manual-public-ip-logging-ok \
     --expand \
     --dns-route53 \
     --server https://acme-staging-v02.api.letsencrypt.org/directory \
     --email "${EMAIL_ADDRESS}" \
     --domains "${DOMAINS}"

