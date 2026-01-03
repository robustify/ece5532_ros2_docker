#!/bin/bash
set -e
docker buildx build --build-arg UID=$(id -u) --build-arg GID=$(id -g) . -t ece5532_jazzy
