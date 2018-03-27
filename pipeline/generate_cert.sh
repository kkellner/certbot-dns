#!/bin/sh

set -eux

CERT_OUTPUT_DIR=letsencrypt
CERT_WORK_DIR=letsencrypt_work

if [ -d cert-repo/${CERT_OUTPUT_DIR} ]; then
    cp -R cert-repo/${CERT_OUTPUT_DIR} .
    ls -alR ${CERT_OUTPUT_DIR}
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
     --server https://acme-staging-v02.api.letsencrypt.org/directory \
     --email "${EMAIL_ADDRESS}" \
     --domains "${DOMAINS}"

# temp to get some changed files
#mkdir -p ./letsencrypt/live/den.ecsteam.io
#date >> ./letsencrypt/live/den.ecsteam.io/fullchain.pem
#date >> ./letsencrypt/live/den.ecsteam.io/privkey.pem

#cp ./letsencrypt/live/den.ecsteam.io/fullchain.pem cert-repo/proxy-certs
#cp ./letsencrypt/live/den.ecsteam.io/privkey.pem cert-repo/proxy-certs

ls -alR ${CERT_OUTPUT_DIR}


