#!/bin/bash
set -e -o pipefail

export POSTGRES_VERSION=${POSTGRES_VERSION:-14}
export MATRIX_SYNAPSE_VERSION="${MATRIX_SYNAPSE_VERSION:-1.31.0_dinum_2021_10_05-sygnalrewrite-frozendict}"
synapse_dinsic_git_tag="tags/${MATRIX_SYNAPSE_VERSION}"
synapse_dinsic_url="https://github.com/matrix-org/synapse-dinsic"
synapse_dinsic_git_dir="$(basename $synapse_dinsic_url)"
synapse_dinsic_url_package="$synapse_dinsic_url/archive/refs/${synapse_dinsic_git_tag}.tar.gz"

export MATRIX_SYDENT_VERSION="${MATRIX_SYDENT_VERSION:-2.3.0_dinum_2022_04_04}"
sydent_dinsic_git_tag="tags/${MATRIX_SYDENT_VERSION}"
sydent_dinsic_url="https://github.com/matrix-org/sydent"
sydent_dinsic_git_dir="$(basename $sydent_dinsic_url)"
sydent_dinsic_url_package="$sydent_dinsic_url/archive/refs/${sydent_dinsic_git_tag}.tar.gz"

export MATRIX_SYGNAL_VERSION=${MATRIX_SYGNAL_VERSION:-v0.11.0}
export MATRIX_CONTENT_SCANNER_VERSION=${MATRIX_CONTENT_SCANNER_VERSION:-v1.9.0}

echo "# get"
mkdir -p build
( cd build
  echo "# get ${synapse_dinsic_url}"
  if [ ! -d "${synapse_dinsic_git_dir}" ]; then
      mkdir -p ${synapse_dinsic_git_dir}
      curl -L ${synapse_dinsic_url_package} | tar zxvf - -C ${synapse_dinsic_git_dir}  --strip-components 1
      ( cd ${synapse_dinsic_git_dir} ;
        echo "# apply patch"
        patch -p0 < ../../patch/00-${synapse_dinsic_git_dir}.patch
      )
  fi

  echo "# get ${sydent_dinsic_url}"
  if [ ! -d "${sydent_dinsic_git_dir}" ]; then
      mkdir -p ${sydent_dinsic_git_dir}
      curl -L ${sydent_dinsic_url_package} | tar zxvf - -C ${sydent_dinsic_git_dir}  --strip-components 1
  fi
)

echo "# build"
export DC_APP_DOCKER_CLI=docker-compose-tchap.yml
make build DC_APP_DOCKER_CLI=${DC_APP_DOCKER_CLI}

echo "# bootstrap"
make bootstrap-all DC_APP_DOCKER_CLI=${DC_APP_DOCKER_CLI}
