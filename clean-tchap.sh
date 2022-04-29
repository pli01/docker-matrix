#!/bin/bash
set -e -o pipefail
export DC_APP_DOCKER_CLI=docker-compose-tchap.yml

make clean-all DC_APP_DOCKER_CLI=${DC_APP_DOCKER_CLI}
