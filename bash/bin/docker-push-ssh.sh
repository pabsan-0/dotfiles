#!/bin/bash
#
# Push images to machines in LAN without access to docker registry

set -euo pipefail
set -x

print_usage() {
    echo "Usage: $0 <user@remote-host> <image1> [image2] ..."
}

main() {
    # Parse args
    REMOTE=$1
    shift
    IMAGES=("$@")

    if [ -z "$REMOTE" ] || [ ${#IMAGES[@]} -eq 0 ]; then
        print_usage 
        exit 1
    fi

    for IMG in "${IMAGES[@]}"; do
        
        # Check if image exists locally
        if ! docker image inspect "$IMG" >/dev/null 2>&1; then
            echo "Local image $IMG not found. Pulling..."
            docker pull "$IMG"
        fi

        # Compute image size 
        IMAGE_SIZE=$(docker image inspect "$IMG" --format='{{.Size}}')
        
        # Stream with % progress display
        echo "Pushing $IMG (~$IMAGE_SIZE bytes) to $REMOTE..."
        docker save "$IMG" | pv -s "$IMAGE_SIZE" -p -t -e -r | ssh "$REMOTE" "docker load"
        echo "Finished pushing $IMG!"
    done

    echo "All images sent!"
}

main "$@"
