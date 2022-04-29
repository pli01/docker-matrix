SHELL = /bin/bash
APP_NAME=docker-matrix
#APP_VERSION := $(shell bash ./ci/version.sh 2>&- || cat VERSION)
DC       := $(shell type -p docker-compose)
DC_BUILD_ARGS := --pull --no-cache --force-rm
DC_APP_DOCKER_CLI := docker-compose.yml
DC_APP_ENV :=  #-f docker-compose.test.yml

DOCKER_USE_TTY := $(shell ( test -t 0 || test -t 1 ) && echo "-t" )
DC_USE_TTY     := $(shell ( test -t 0 || test -t 1 ) || echo "-T" )
DC_RUN_ARGS := --rm ${DC_USE_TTY}

SYNAPSE_DIR ?= matrix/synapse
SYNAPSE_CONFIG ?= ${SYNAPSE_DIR}/homeserver.yaml
POSTGRES_DATA_DIR ?= postgresdata

DRY_RUN ?= true
export

bootstrap-all: bootstrap up test-up create-user

bootstrap: pull
	[ -f "${SYNAPSE_CONFIG}" ] || ./bootstrap.sh
force-bootstrap: clean-synapse-config clean-synapse-dir clean-postgres-data bootstrap
clean-synapse-config:
	[ -f "${SYNAPSE_CONFIG}" ] && rm -rf ${SYNAPSE_CONFIG} || true
clean-synapse-dir:
	[ -d "${SYNAPSE_DIR}" ] && rm -rf ${SYNAPSE_DIR} || true
clean-postgres-data:
	[ -d "${POSTGRES_DATA_DIR}" ] && rm -rf ${POSTGRES_DATA_DIR} || true
create-user:
	./create-user.sh

clean-all: down rm clean-synapse-config clean-synapse-dir clean-postgres-data

all:
	@echo "Usage: make build | config"
build: config
	${DC} -f ${DC_APP_DOCKER_CLI}  build ${DC_BUILD_ARGS}
config:
	@${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} config
pull:
	@${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} pull
up:
	${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} up -d
up-%:
	${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} up -d $*
stop-%:
	${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} stop $*
down:
	${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} down
rm:
	${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} rm -f

sh-%:
	${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} run --entrypoint='/bin/sh' ${DC_RUN_ARGS} $*
run-%:
	${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} run ${DC_RUN_ARGS} $*

test-up: test-element-up test-synapse-up test-db-up test-synapse-api-up
test-synapse-api-up:
	${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} exec $(DC_USE_TTY) proxy /bin/bash -c "$$(cat tests/tests-synapse-up.sh)"
test-%-up:
	${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} exec $(DC_USE_TTY) $* hostname || ( \
		${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} logs --tail=10 $* ; false ; )
