#!/usr/bin/env bash
#
# Use certbot to generate a cert for a group
# of domain names including wildcard names.
# The LetsEncrypt validation is done via DNS.
# This script will call a helper DNS script
# to perform the DNS updates. 
#
# Copyright (C) 2018 Kurt Kellner - All Rights Reserved
# Licensed under the Apache License, Version 2.0 (the "License");
#
export CHANGE_DNS_DATA_FILE=$(mktemp -t "change_dns_XXXX")

DNS_SCRIPT="$(cd "$(dirname "$0")" && pwd)/${DNS_TYPE}/change_dns.sh"

domainCount() {
  while [ $# -gt 0 ]; do
    if [[ $1 == "--domains" ]]; then
      if [ -n "${domains}" ]; then
        seperator=","
      fi
      domains="${domains}${seperator} $2"
    fi
    shift
  done
}

domainCount "$@"

IFS=',' read -r -a domainsArray <<< "$domains"
domainsLen=${#domainsArray[@]}

echo "Full list of domains: ${domains}"
echo "Total number of domains: ${domainsLen}"
echo "Using temp DNS data file: ${CHANGE_DNS_DATA_FILE}"

export TOTAL_DOMAINS=$domainsLen

rm -f "${CHANGE_DNS_DATA_FILE}"
mkdir -p "${CERT_OUTPUT_DIR}"

certbot certonly \
    --non-interactive \
    --manual \
    --manual-auth-hook "${DNS_SCRIPT}" \
    --manual-cleanup-hook "${DNS_SCRIPT}" \
    --preferred-challenge dns \
    --config-dir "${CERT_OUTPUT_DIR}" \
    --work-dir "${CERT_OUTPUT_DIR}" \
    --logs-dir "${CERT_OUTPUT_DIR}" \
    "$@"

rm -f "${CHANGE_DNS_DATA_FILE}"