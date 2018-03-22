#!/bin/bash 
# AWS (Amazon) route53 DNS update script - invoked by certbot-dns.sh vis certbot
#
# We collect all the DNS updates (UPSERT or DELETE) and batch them into one 
# AWS route53 update.  This is because it takes 60 seconds or so to perform
# a synced update with route53 as it roles out to all aws datacenters.
#
# NOTE: You must have the `aws` CLI installed and configured
#  Install:
#  https://docs.aws.amazon.com/cli/latest/userguide/installing.html
#  e.g.,  MacOS: brew install awscli
#         Other: pip install awscli
#  Configure:
#  https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
#  e.g.,
#    $ aws configure
#    AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
#    AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
#    Default region name [None]: us-west-2
#    Default output format [None]: json
#
# Copyright (C) 2018 Kurt Kellner - All Rights Reserved
# Licensed under the Apache License, Version 2.0 (the "License");
#
[[ ${CERTBOT_AUTH_OUTPUT} ]] && ACTION="DELETE" || ACTION="UPSERT"

DOMAIN="${CERTBOT_DOMAIN}"
while true; do

  printf -v QUERY 'HostedZones[?Name == `%s.`]|[?Config.PrivateZone == `false`].Id' "${DOMAIN}"

  echo "aws route53 check domain: ${DOMAIN}"
  HOSTED_ZONE_ID="$(aws route53 list-hosted-zones --query "${QUERY}" --output text)"

  if [ -n "${HOSTED_ZONE_ID}" ]; then
    break
  fi

  # We strip out the hostname part to leave only the domain
  DOMAIN="$(echo "${DOMAIN}" | cut -d"." -f2- )"
  if [[  "${DOMAIN}" != *.* ]] ; then
    break
  fi

done

if [ -z "${HOSTED_ZONE_ID}" ]; then
  echo "No hosted zone found that matches ${CERTBOT_DOMAIN} hierarchy"
  exit 1
fi

echo "Found HOSTED_ZONE_ID: ${HOSTED_ZONE_ID}"
echo "For domain ${CERTBOT_DOMAIN} Action: ${ACTION} validation value: ${CERTBOT_VALIDATION}"

CHANGE_BATCH_LINE="{ \"Action\": \"${ACTION}\", \"ResourceRecordSet\": \
   { \"Name\": \"_acme-challenge.${CERTBOT_DOMAIN}.\", \
     \"ResourceRecords\": [{\"Value\": \"\\\"${CERTBOT_VALIDATION}\\\"\"}], \
     \"Type\": \"TXT\", \
     \"TTL\": 30 } }"

echo "${CHANGE_BATCH_LINE}" >> ${CHANGE_DNS_DATA_FILE}

if [ -r "${CHANGE_DNS_DATA_FILE}" ]; then
  processDomainNum=$(cat ${CHANGE_DNS_DATA_FILE} | wc -l)
else
  processDomainNum=0
fi
echo "Processing domain ${processDomainNum} of ${TOTAL_DOMAINS}"

if [ "${processDomainNum}" -eq "${TOTAL_DOMAINS}" ]; then

  while IFS='' read -r line || [[ -n "$line" ]]; do
    if [ -n "${CHANGE_BATCH}" ]; then
      seperator=","
    fi
    CHANGE_BATCH="${CHANGE_BATCH}${seperator} ${line}"
  done < "${CHANGE_DNS_DATA_FILE}"
  rm -f "${CHANGE_DNS_DATA_FILE}"

  CHANGE_BATCH="{ \"Changes\": [ ${CHANGE_BATCH} ] }"

  echo "CHANGE_BATCH=${CHANGE_BATCH}"

  aws route53 wait resource-record-sets-changed --id "$(
    aws route53 change-resource-record-sets \
    --hosted-zone-id "${HOSTED_ZONE_ID}" \
    --query ChangeInfo.Id --output text \
    --change-batch "${CHANGE_BATCH}"
  )"
  echo "aws route53 resource-record-sets-changed return status: $?"
fi