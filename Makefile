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

DATA_FILE ?=
DATA_DIR ?= data
DRY_RUN ?= true
export

all:
	@echo "Usage: make build | config"
build: config
	${DC} -f ${DC_APP_DOCKER_CLI}  build ${DC_BUILD_ARGS}
config:
	@${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} config
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

test-up: test-element-up test-synapse-up test-db-up
test-%-up:
	${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} exec $(DC_USE_TTY) $* hostname || ( \
		${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} logs --tail=10 $* ; false ; )
