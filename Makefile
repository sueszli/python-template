.PHONY: help fmt up reqs conda-run conda-clean docker-run docker-clean

help:
	@printf "Usage: make [target]\n"
	@printf "\tfmt - run black formatter\n"
	@printf "\tup - git pull, add, commit, push\n"
	@printf "\treqs - generate requirements.txt\n"
	@printf "\tconda-run - create conda environment\n"
	@printf "\tconda-clean - remove conda environment\n"
	@printf "\tdocker-run - run docker container\n"
	@printf "\tdocker-clean - remove docker container\n"

fmt:
	pip install black
	black -l 200 .

up:
	git pull
	git add .
	git commit -m "up"
	git push

reqs:
	pip install pipreqs
	rm -rf requirements.txt
	pipreqs .

# to emulate x86_64 run: conda config --env --set subdir osx-64
# to emulate arm64 run: conda config --env --set subdir osx-arm64
# check with: conda info
conda-run:
	conda config --set auto_activate_base false
	conda activate base
	
	conda create --yes --name main python=3.11 anaconda
	conda activate main

	pip install -r requirements.txt

	conda env export > conda-environment.yml

conda-clean:
	conda deactivate
	conda remove --yes --name main --all
	conda env list

docker-run:
	docker-compose up
	docker ps --all
	docker exec -it main /bin/bash

docker-clean:
	docker-compose down

	docker stop $(docker ps -a -q)
	docker rm $(docker ps -a -q)
	docker rmi $(docker images -q)
	yes | docker container prune
	yes | docker image prune
	yes | docker volume prune
	yes | docker network prune
	yes | docker system prune
	docker ps --all
	docker images
	docker system df
	docker volume ls
	docker network ls
