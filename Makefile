.PHONY: help up fmt sec reqs conda-run conda-clean docker-run docker-clean

help:
	@printf "Usage: make [target]\n"
	@printf "Targets:\n"
	@printf "\thelp - show this help message\n"
	@printf "\t...\n"

# commit
up:
	git pull
	git add .
	git commit -m "up"
	git push

# format code, remove unused imports, sort imports
fmt:
	# sort and remove unused imports
	pip install isort
	isort .
	pip install autoflake
	autoflake --remove-all-unused-imports --recursive --in-place .

	# format
	pip install ruff
	ruff format --config line-length=500 .

# check for security vulnerabilities
sec:
	pip install bandit
	pip install safety
	
	bandit -r .
	safety check --full-report

# update requirements.txt
reqs:
	pip install pipreqs
	rm -rf requirements.txt
	pipreqs .

conda-run:
	# conda config --env --set subdir osx-64 # emulate x86_64
	# conda config --env --set subdir osx-arm64 # emulate arm64
	conda info

	conda deactivate
	conda config --set auto_activate_base false
	conda activate base

	conda create --yes --name main python=3.11 anaconda
	conda activate main
	pip install -r requirements.txt

	# take snapshot
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

	# wipe docker
	docker stop $(docker ps -a -q)
	docker rm $(docker ps -a -q)
	docker rmi $(docker images -q)
	yes | docker container prune
	yes | docker image prune
	yes | docker volume prune
	yes | docker network prune
	yes | docker system prune
	
	# check if successful
	docker ps --all
	docker images
	docker system df
	docker volume ls
	docker network ls
