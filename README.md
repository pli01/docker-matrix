# docker-matrix

matrix docker-compose stack for local/dev/testing purpose

## Run

* Prereq:
  - install docker, docker-compose
  - data and generated config ar stored in matrix/ directory

* Bootstrap:
```
# generate from template file
docker-compose run  --rm -e SYNAPSE_NO_TLS=yes -e SYNAPSE_SERVER_NAME=localhost -e SYNAPSE_REPORT_STATS=yes -e POSTGRES_DB=synapse -e POSTGRES_USER=synapse -e POSTGRES_PASSWORD=STRONGPASSWORD  synapse migrate_config
```

* Run:
```
make build
make up
```
* Add new users
```
# create admin user
docker-compose exec synapse register_new_matrix_user -a -u root -p CHANGEME -c /data/homeserver.yaml http://localhost:8008 
# create test user
docker-compose exec synapse register_new_matrix_user -u test -p CHANGEME -c /data/homeserver.yaml http://localhost:8008 
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
