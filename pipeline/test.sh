#!/bin/bash

set -eu

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
export fly_target=${fly_target}
echo "Concourse API target ${fly_target}"
echo "Location: $(basename $DIR)"

pushd $DIR
  fly -t ${fly_target} set-pipeline -p generate-lab-certs -c pipeline.yml -n
  fly -t ${fly_target} unpause-pipeline -p generate-lab-certs
  fly -t ${fly_target} trigger-job -w -j generate-lab-certs/job-pass-files
popd
