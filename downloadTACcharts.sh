#!/usr/bin/env bash

# Copyright 2020 The TKG Contributors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#set -euxo pipefail

# The local paths where you'd like to save charts
export LOCAL_CHART_DIRECTORY="./charts"

# The final registry in the airgapped environment. This is for updating chart references.
export FINAL_CUSTOM_IMAGE_REPOSITORY="my.private.registry/tac/"

# The TAC registry endpoint and user id
export TAC_IMAGE_REPOSITORY="registry.pivotal.io/tac-federal-apple"
export TAC_REPOSITORY_USER="robot\$federal-apple-client"

# Set the following to allow Helm to work with OCI repos. Don't change this.
export HELM_EXPERIMENTAL_OCI=1

# Reuse the tac-auth.json for Helm
export HELM_REGISTRY_CONFIG="./tac-autha.json"

if [ ! -d "$LOCAL_CHART_DIRECTORY" ] 
then
  echo "Directory $LOCAL_CHART_DIRECTORY DOES NOT exist. Pleae create it and re-run."
  exit 1
fi

if ! [[ $(command -v skopeo) ]]; then
  echo "ERROR: 'skopeo' needs to be installed in your PATH"
  echo 'Ubuntu: https://software.opensuse.org//download.html?project=devel%3Akubic%3Alibcontainers%3Astable&package=skopeo'
  echo 'Amazon Linux 2: https://software.opensuse.org//download.html?project=devel%3Akubic%3Alibcontainers%3Astable&package=skopeo'
  exit 1
fi
if ! [[ $(command -v oras) ]]; then
  echo "ERROR: 'oras' needs to be installed in your PATH"
  echo 'See: https://github.com/deislabs/oras/releases'
  exit 1
fi
if [ ! -f tac-auth.json ]; then
  echo "TAC Authorization File not found, please create one with: "
  # cat federal-apple-client-password.txt | skopeo login --authfile ./tac-auth.json -u 'robot$federal-apple-client' registry.pivotal.io/tac-federal-apple --password-stdin  
  # skopeo login generates the authfile json at the path specified e.g. ./tac-auth.json
  echo "skopeo login --authfile ./tac-auth.json -u '$TAC_REPOSITORY_USER' $TAC_IMAGE_REPOSITORY"
  echo "or put the password in a file called password.txt and run:"
  echo "cat password.txt | skopeo login --authfile ./tac-auth.json -u '$TAC_REPOSITORY_USER' $TAC_IMAGE_REPOSITORY --password-stdin"
  exit 1
fi

TAC_FILE="asset-index.json"
oras pull $TAC_IMAGE_REPOSITORY/index:latest -a -c tac-auth.json >/dev/null

echo && echo "# Downloading charts"
for row in $(<$TAC_FILE jq -r '.charts[] | @base64'); do
    _jq() {
        echo ${row} | base64 --decode | jq -r ${1}
    }
    IMAGE_NAME=$(_jq '.name')
    CHART_URI=$(_jq '.versions[0].uri')
    
    echo "helm chart pull $CHART_URI"
    helm chart pull $CHART_URI
    echo "helm chart export -d $LOCAL_CHART_DIRECTORY $CHART_URI"
    helm chart export -d $LOCAL_CHART_DIRECTORY $CHART_URI
    
done
