#!/bin/bash

set -eu

pipeline_name="generate-cert"

if [ -z ${fly_target:-} ]; then echo "need to set fly_target environment variable"; exit 1; fi

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
export fly_target=${fly_target}
echo "Concourse API target ${fly_target}"
echo "Location: $(basename $DIR)"

pushd $DIR
  fly -t ${fly_target} set-pipeline -p ${pipeline_name} -c pipeline.yml -l params.yml
  fly -t ${fly_target} unpause-pipeline -p ${pipeline_name}
#  fly -t ${fly_target} trigger-job -w -j ${pipeline_name}/generate-cert
popd
