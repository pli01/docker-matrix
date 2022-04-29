#!/bin/bash
set -e -o pipefail

# env files
export TCHAP_CONFIG=tchap-config.env
if [ -f "${TCHAP_CONFIG}" ] ; then
    source ${TCHAP_CONFIG}
    export DC_APP_ENV=" --env-file ${TCHAP_CONFIG} "
fi

# docker-compose version
export DC_APP_DOCKER_CLI=docker-compose-tchap.yml

# app version
export POSTGRES_VERSION=${POSTGRES_VERSION:?}
export MATRIX_SYGNAL_VERSION=${MATRIX_SYGNAL_VERSION:?}
export MATRIX_CONTENT_SCANNER_VERSION=${MATRIX_CONTENT_SCANNER_VERSION:?}
export MATRIX_MEDIA_REPO_VERSION=${MATRIX_MEDIA_REPO_VERSION:?}

export MATRIX_SYNAPSE_VERSION="${MATRIX_SYNAPSE_VERSION:?}"
export MATRIX_SYDENT_VERSION="${MATRIX_SYDENT_VERSION:?}"

echo "# bootstrap-all"
make bootstrap-all DC_APP_DOCKER_CLI=${DC_APP_DOCKER_CLI} DC_APP_ENV="${DC_APP_ENV}"
