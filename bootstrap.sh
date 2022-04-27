#!/bin/bash
echo "# generate matrix/synapse/homeserver.yaml"
docker-compose run  --rm -e SYNAPSE_NO_TLS=yes -e SYNAPSE_SERVER_NAME=localhost -e SYNAPSE_REPORT_STATS=no -e SYNAPSE_ENABLE_REGISTRATION=yes -e POSTGRES_DB=synapse -e POSTGRES_USER=synapse -e POSTGRES_PASSWORD=STRONGPASSWORD -e SYNAPSE_ENABLE_REGISTRATION_WITHOUT_VERIFICATION=true synapse migrate_config

echo "# enable registration without verification (for dev purpose only)"
cat <<EOF | tee -a matrix/synapse/homeserver.yaml

enable_registration_without_verification: true
EOF

echo "# add email config to matrix/synapse/homeserver.yaml"

cat <<EOF >> matrix/synapse/homeserver.yaml

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

