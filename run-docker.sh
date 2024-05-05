# run
docker-compose up

# use however you like
docker ps --all
code --attach-container <container_id>
docker exec -it <container_id> /bin/bash

# stop
docker-compose down

ids=$(docker ps -a -q)
for id in $ids; do docker stop $id; done
for id in $ids; do docker rm $id; done
docker ps --all
