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
synapse_dinsic_git_tag="tags/${MATRIX_SYNAPSE_VERSION}"
synapse_dinsic_url="https://github.com/matrix-org/synapse-dinsic"
synapse_dinsic_git_dir="$(basename $synapse_dinsic_url)"
synapse_dinsic_url_package="$synapse_dinsic_url/archive/refs/${synapse_dinsic_git_tag}.tar.gz"

export MATRIX_SYDENT_VERSION="${MATRIX_SYDENT_VERSION:?}"
sydent_dinsic_git_tag="tags/${MATRIX_SYDENT_VERSION}"
sydent_dinsic_url="https://github.com/matrix-org/sydent"
sydent_dinsic_git_dir="$(basename $sydent_dinsic_url)"
sydent_dinsic_url_package="$sydent_dinsic_url/archive/refs/${sydent_dinsic_git_tag}.tar.gz"

mkdir -p build
( cd build
  echo "# download and extract ${synapse_dinsic_url}"
  if [ ! -d "${synapse_dinsic_git_dir}" ]; then
      mkdir -p ${synapse_dinsic_git_dir}
      curl -L ${synapse_dinsic_url_package} | tar zxf - -C ${synapse_dinsic_git_dir}  --strip-components 1
      ( cd ${synapse_dinsic_git_dir} ;
        echo "# apply patch"
        patch -p0 < ../../patch/00-${synapse_dinsic_git_dir}.patch
      )
  fi

  echo "# download and extract ${sydent_dinsic_url}"
  if [ ! -d "${sydent_dinsic_git_dir}" ]; then
      mkdir -p ${sydent_dinsic_git_dir}
      curl -L ${sydent_dinsic_url_package} | tar zxf - -C ${sydent_dinsic_git_dir}  --strip-components 1
  fi
)

echo "# build"
make build DC_APP_DOCKER_CLI=${DC_APP_DOCKER_CLI} DC_APP_ENV="${DC_APP_ENV}"

echo "# image versions:"
make config DC_APP_DOCKER_CLI=${DC_APP_DOCKER_CLI} DC_APP_ENV="${DC_APP_ENV}" |grep "image:" |sort
