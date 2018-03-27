#!/bin/sh

set -eux

CERT_OUTPUT_DIR=letsencrypt
CERT_WORK_DIR=letsencrypt_work

if [ -d cert-repo/${CERT_OUTPUT_DIR} ]; then
    cp -R cert-repo/${CERT_OUTPUT_DIR} .
fi 

certbot certonly \
     --config-dir "${CERT_OUTPUT_DIR}" \
     --work-dir "${CERT_WORK_DIR}" \
     --logs-dir "${CERT_WORK_DIR}" \
     --non-interactive \
     --agree-tos \
     --manual-public-ip-logging-ok \
     --expand \
     --dns-route53 \
     --server ${LETSENCRYPT_API_ENDPOINT} \
     --email "${EMAIL_ADDRESS}" \
     --domains "${DOMAINS}"

