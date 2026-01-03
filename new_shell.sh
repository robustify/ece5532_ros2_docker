#!/bin/bash
set -e

if [ ! "$(docker ps -a -q -f name=ece5532_jazzy)" ]; then
    echo "Container does not exist, attempting to create and start it..."
    ./run.sh
elif [ "$( docker container inspect -f '{{.State.Running}}' ece5532_jazzy )" == "false" ]; then
    echo "Container exists, but not running yet. Attempting to start it..."
    ./run.sh
fi

docker exec -it ece5532_jazzy /bin/bash
