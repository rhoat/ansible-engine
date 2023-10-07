#!/bin/bash
# Source the global variables from globals.sh
set -e
source ./build/scripts/globals.sh

SSHFolder="$HOME/.ssh/"
ANSIBLESSHKeyName=ansible
IMAGE_NAME="local/ansible:1.0"

if [[ "$($ContainerEngine images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
  echo "The image $IMAGE_NAME does not exist locally. Building it..."
  $ContainerEngine build -f "$ArtifactsFolder/dockerfile" -t $IMAGE_NAME .
fi

$ContainerEngine run --rm --network host -it \
-v "$SSHFolder/$ANSIBLESSHKeyName":"/root/.ssh/ansible" \
-v "$repo_root/ansible":"/etc/ansible" $IMAGE_NAME "$@"
