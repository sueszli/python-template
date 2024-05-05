# ------------------------------------------- run
docker-compose up

# ------------------------------------------- use however you like
code --attach-container <container_id>
docker exec -it <container_id> /bin/bash

# ------------------------------------------- stop, clean up
docker-compose down

ids=$(docker ps -a -q)
for id in $ids; do docker stop $id; done
for id in $ids; do docker rm $id; done
docker ps --all

# ------------------------------------------- remove everything
docker rmi $(docker images -q)
docker images

echo y | docker system prune
docker system df
