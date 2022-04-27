#!/bin/bash
echo "# create admin user"
docker-compose exec synapse register_new_matrix_user -a -u root -p CHANGEME -c /data/homeserver.yaml http://localhost:8008
echo "# create test user"
docker-compose exec synapse register_new_matrix_user --no-admin -u test -p CHANGEME -c /data/homeserver.yaml http://localhost:8008

