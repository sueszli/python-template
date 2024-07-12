.PHONY: help fmt sec reqs docker-run docker-clean conda-install conda-install-yml conda-clean

help:
	@printf "Usage: make [target]\n"
	@printf "Targets:\n"
	@printf "\thelp - show this help message\n"
	@printf "\t...\n"

# --------------------------------------------------------------- utils

fmt:
	# sort and remove unused imports
	pip install isort
	isort .
	pip install autoflake
	autoflake --remove-all-unused-imports --recursive --in-place .

	# format
	pip install ruff
	ruff format --config line-length=500 .

sec:
	pip install bandit
	pip install safety
	
	bandit -r .
	safety check --full-report

reqs:
	pip install pipreqs
	rm -rf requirements.txt
	pipreqs .

# --------------------------------------------------------------- docker

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

# --------------------------------------------------------------- conda

# workaround because makefile opens up its own shell for each command
.ONESHELL:
SHELL = /bin/bash
CONDA_DEACTIVATE = source $$(conda info --base)/etc/profile.d/conda.sh ; conda deactivate
CONDA_ACTIVATE_BASE = source $$(conda info --base)/etc/profile.d/conda.sh ; conda activate base
CONDA_ACTIVATE_CON = source $$(conda info --base)/etc/profile.d/conda.sh ; conda activate con

conda-install:
	# conda config --env --set subdir osx-64
	# conda config --env --set subdir osx-arm64
	conda config --set auto_activate_base false
	conda info

	$(CONDA_ACTIVATE_BASE)
	conda create --yes --name con python=3.11 anaconda

	$(CONDA_ACTIVATE_CON)
	pip install -r requirements.txt

	conda env export --name con > conda-environment.yml

	@echo "To activate the conda environment, run: `conda activate con`"
	@echo "To deactivate the conda environment, run: `conda deactivate`"

conda-install-yml:
	$(CONDA_ACTIVATE_BASE)
	conda env create --file conda-environment.yml

	@echo "To activate the conda environment, run: `conda activate con`"
	@echo "To deactivate the conda environment, run: `conda deactivate`"

conda-clean:
	conda remove --yes --name con --all
	conda env list
