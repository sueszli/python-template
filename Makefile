# --------------------------------------------------------------- docker

.PHONY: docker-install # run docker container
docker-install:
	@echo "to exec into docker container, run: 'docker exec -it main /bin/bash'"
	docker-compose up --detach

.PHONY: docker-clean # wipe everything in docker
docker-clean:
	docker-compose down

	# wipe docker
	-docker stop $$(docker ps -a -q)
	-docker rm $$(docker ps -a -q)
	-docker rmi $$(docker images -q)
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

# --------------------------------------------------------------- conda

.PHONY: conda-get-yaml # generate an environment yaml file
conda-get-yaml:
	conda update -n base -c defaults conda
	# conda config --env --set subdir osx-64
	# conda config --env --set subdir osx-arm64
	conda config --set auto_activate_base false
	conda info
	@bash -c '\
		source $$(conda info --base)/etc/profile.d/conda.sh; conda activate base; \
		conda create --yes --name con python=3.11; \
		source $$(conda info --base)/etc/profile.d/conda.sh; conda activate con; \
		\
		pip install -r requirements.txt; \
		\
		conda env export --no-builds | grep -v "prefix:" > conda-environment.yml; \
		source $$(conda info --base)/etc/profile.d/conda.sh; conda deactivate; \
		conda remove --yes --name con --all; \
	'

.PHONY: conda-install # install conda environment from yaml file
conda-install:
	@bash -c '\
		source $$(conda info --base)/etc/profile.d/conda.sh; conda activate base; \
		conda env create --file conda-environment.yml; \
	'

.PHONY: conda-clean # remove conda environment
conda-clean:
	@bash -c '\
		source $$(conda info --base)/etc/profile.d/conda.sh; conda activate base; \
		conda remove --yes --name con --all; \
		source $$(conda info --base)/etc/profile.d/conda.sh; conda deactivate; \
	'

# --------------------------------------------------------------- utils

.PHONY: fmt # format and remove unused imports
fmt:
	pip install isort
	isort .
	pip install autoflake
	autoflake --remove-all-unused-imports --recursive --in-place .

	pip install ruff
	ruff format --config line-length=500 .

.PHONY: sec # check for common vulnerabilities
sec:
	pip install bandit
	pip install safety
	
	bandit -r .
	safety check --full-report

.PHONY: reqs # generate requirements.txt file
reqs:
	pip install pipreqs
	rm -rf requirements.txt
	pipreqs .

.PHONY: up # pull remote changes and push local changes
up:
	git pull
	git add .
	if [ -z "$(msg)" ]; then git commit -m "up"; else git commit -m "$(msg)"; fi
	git push

.PHONY: help # generate help message
help:
	@grep '^.PHONY: .* #' Makefile | sed 's/\.PHONY: \(.*\) # \(.*\)/\1	\2/' | expand -t20
