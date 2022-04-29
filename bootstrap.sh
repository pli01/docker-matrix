#!/bin/bash
set -e -o pipefail

DC_APP_DOCKER_CLI="${DC_APP_DOCKER_CLI:-docker-compose.yml}"
DC_USE_TTY="${DC_USE_TTY:-}"

echo "# generate matrix/synapse/homeserver.yaml"
docker-compose -f ${DC_APP_DOCKER_CLI}  run ${DC_USE_TTY} --rm \
    -e SYNAPSE_NO_TLS=yes \
    -e SYNAPSE_SERVER_NAME=localhost\
    -e SYNAPSE_REPORT_STATS=no \
    -e SYNAPSE_ENABLE_REGISTRATION=yes \
    -e POSTGRES_DB=synapse \
    -e POSTGRES_USER=synapse \
    -e POSTGRES_PASSWORD=STRONGPASSWORD \
    synapse \
    migrate_config

echo "# configure matrix/synapse/homeserver.yaml"
docker-compose -f ${DC_APP_DOCKER_CLI} run ${DC_USE_TTY} --rm \
    --entrypoint /bin/bash \
    synapse \
    -c '
echo "# Run in synapse"
cat <<EOF | tee -a /data/homeserver.yaml

# enable registration without verification (for dev purpose only)

enable_registration_without_verification: true
public_baseurl: http://localhost/

# add email config to matrix/synapse/homeserver.yaml

email:
   enable_notifs: true
   smtp_host: "mailhog"
   smtp_port: 1025
   smtp_user: "dev@dev.net"
   smtp_pass: "changeme"
   require_transport_security: false
   notif_from: "dev@dev.net"
   notif_for_new_users: true
EOF
'
