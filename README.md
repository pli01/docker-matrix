# docker-matrix

matrix docker-compose stack for local/dev/testing purpose

It includes:
 - nginx reverseproxy: to route trafic through  (`/`) - element-web, and (`/_matrix|/_synapse`) - synapse
 - element : vectorim/element-web web instance
 - synapse : matrixdotorg/synapse instance
 - db : postgres instance
 - mailhog : mailhog/mailhog smtp and web mail instance (for dev purpose)

## Run

* Prereq:
  - install docker, docker-compose
  - data and generated config ar stored in matrix/ directory:
     - element web config: matrix/element-config.json
     - synapse config: matrix/synapse/ (must be generated after bootstrap migrate_config below)
     - postgresdata dir: matrix/postgresdata/ (populated at bootstrap)

* Bootstrap:
```
# generate matrix/synapse/ config from template file
docker-compose run  --rm -e SYNAPSE_NO_TLS=yes -e SYNAPSE_SERVER_NAME=localhost -e SYNAPSE_REPORT_STATS=no -e SYNAPSE_ENABLE_REGISTRATION=yes -e POSTGRES_DB=synapse -e POSTGRES_USER=synapse -e POSTGRES_PASSWORD=STRONGPASSWORD  synapse migrate_config

# add email config
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
```

* Run services
```
make build
make up
```
* Add new users
```
# create admin user
docker-compose exec synapse register_new_matrix_user -a -u root -p CHANGEME -c /data/homeserver.yaml http://localhost:8008
# create test user
docker-compose exec synapse register_new_matrix_user --no-admin -u test -p CHANGEME -c /data/homeserver.yaml http://localhost:8008
```

* Stop/Destroy:
```
make down
make rm
```

## Links:
```
https://cyberhost.uk/element-matrix-setup/
https://github.com/mfallone/docker-compose-matrix-synapse
https://framagit.org/oxyta.net/docker-atelier/-/tree/master/matrix
https://adfinis.com/en/blog/how-to-set-up-your-own-matrix-org-homeserver-with-federation/
```
