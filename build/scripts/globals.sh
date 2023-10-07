#!/bin/bash
function get_container_engine() {
    if [ -x "$(command -v docker)" ]; then
        ContainerEngine="$(command -v docker)"
    fi
    if [ -x "$(command -v podman)" ]; then
        ContainerEngine="$(command -v podman)"
    fi
    #if ContainerEngine is not set, then exit
    if [ -z "$ContainerEngine" ]; then
        echo "No container engine found.  Please install docker or podman."
        exit 1
    fi
    # if ContainerEngine is set, then return it
    echo $ContainerEngine
}

export repo_root="$(git rev-parse --show-toplevel)"
export ArtifactsFolder=$repo_root/build/artifacts
export ContainerEngine=$(get_container_engine)
