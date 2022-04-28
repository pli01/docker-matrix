#!/bin/bash
set -e -o pipefail
make clean-all DC_APP_DOCKER_CLI=docker-compose-tchap.yml
