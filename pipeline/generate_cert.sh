#!/bin/sh

set -eux

CERT_OUTPUT_DIR=letsencrypt
CERT_WORK_DIR=letsencrypt_work

mkdir -p ${CERT_OUTPUT_DIR}/live
mkdir -p ${CERT_OUTPUT_DIR}/renewal
cp -R cert-repo/proxy-certs/* ${CERT_OUTPUT_DIR}/live

cat >${CERT_OUTPUT_DIR}/renewal/den.ecsteam.io.conf <<EOL
cert = ${CERT_OUTPUT_DIR}/live/den.ecsteam.io/cert.pem
privkey = ${CERT_OUTPUT_DIR}/live/den.ecsteam.io/privkey.pem
chain = ${CERT_OUTPUT_DIR}/live/den.ecsteam.io/chain.pem
fullchain = ${CERT_OUTPUT_DIR}/live/den.ecsteam.io/fullchain.pem
EOL

ls -alR ${CERT_OUTPUT_DIR}

echo "XXXXXXXXXXXXXXXXXXXXX"

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


