# docker-matrix

matrix docker-compose stack for local/dev/testing purpose

It includes:
 - nginx reverseproxy (http://localhost) :
   - to route trafic through  (`/`) to element-web
   - and (`/_matrix|/_synapse`) to synapse
 - element : vectorim/element-web web instance
 - synapse : matrixdotorg/synapse instance
 - db : postgres instance
 - mailhog (http://localhost:8025/): mailhog/mailhog smtp and webmail instance

## Run

* Prereq:
  - install docker, docker-compose
  - bootstrap data and generated config are stored in matrix/ directory:
     - element web config: `matrix/element-config.json`
     - synapse config dir : `matrix/synapse/` (must be generated after bootstrap migrate_config below)
     - postgres data dir: `matrix/postgresdata/` (populated at bootstrap)

* First, configure and launch the stack for the first time
```
make bootstrap-all
```

* Then connect to http://localhost with one of users:
  - `admin` 
  - `test`
(default password `CHANGEME`)

* To stop the stack
```
make down
```

* To start the stack
```
make up
```

* To remove all datas and stack
```
make clean-all
```

## details

* See script `bootstrap.sh` to add other homeserver configuration
* Add new users `create-user.sh` to add admin and test user

## Links:
```
https://cyberhost.uk/element-matrix-setup/
https://github.com/mfallone/docker-compose-matrix-synapse
https://framagit.org/oxyta.net/docker-atelier/-/tree/master/matrix
https://adfinis.com/en/blog/how-to-set-up-your-own-matrix-org-homeserver-with-federation/
```
