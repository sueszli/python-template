# 
# venv
# 

.PHONY: venv # create virtual environment
venv:
	pip install pip --upgrade
	rm -rf requirements.txt requirements.in .venv
	uvx pipreqs . --mode no-pin --encoding utf-8 --ignore .venv
	mv requirements.txt requirements.in
	uv pip compile requirements.in -o requirements.txt

	uv venv .venv --python 3.11
	uv pip install -r requirements.txt
	@echo "activate venv with: \033[1;33msource .venv/bin/activate\033[0m"

.PHONY: lock # freeze dependencies
lock:
	./.venv/bin/python3 -m pip freeze > requirements.in
	uv pip compile requirements.in -o requirements.txt

# 
# docker
# 

.PHONY: docker # run or rebuild docker container
docker:
	@if docker compose ps --services --filter "status=running" | grep -q .; then \
		echo "rebuilding..."; \
		docker compose build; \
	else \
		echo "starting container..."; \
		docker compose up --detach; \
	fi

.PHONY: clean # wipe all containers
clean:
	docker compose down --rmi all --volumes --remove-orphans
	docker system prune -a -f

# 
# conda
# 

.PHONY: conda-reqs-to-yaml # install conda to generate environment.yml from requirements.txt (idempotent)
conda-reqs-to-yaml:
	conda update -n base -c defaults conda
	conda config --env --set subdir osx-arm64 || true
	conda config --set auto_activate_base false
	conda info
	bash -c '\
		source $$(conda info --base)/etc/profile.d/conda.sh && conda activate base; \
		conda create --yes --name con python=3.11; \
		source $$(conda info --base)/etc/profile.d/conda.sh && conda activate con; \
		pip install -r requirements.txt; \
		conda env export --no-builds | grep -v "prefix:" > environment.yml; \
		source $$(conda info --base)/etc/profile.d/conda.sh; conda deactivate; \
		conda remove --yes --name con --all; \
	'

.PHONY: conda # install conda from environment.yml file
conda:
	# can also be used in docker with continuumio/miniconda3 image
	bash -c '\
		source $$(conda info --base)/etc/profile.d/conda.sh; conda activate base; \
		conda env create --file environment.yml --solver=libmamba; \
	'
	@echo "to activate conda environment, run: conda activate con"

.PHONY: conda-clean # wipe conda environment
conda-clean:
	# conda clean --all # wipe everything
	bash -c '\
		source $$(conda info --base)/etc/profile.d/conda.sh; conda activate base; \
		conda remove --yes --name con --all; \
		source $$(conda info --base)/etc/profile.d/conda.sh; conda deactivate; \
	'

# 
# utils
# 

.PHONY: fmt # format code
fmt:
	uvx isort .
	uvx autoflake --remove-all-unused-imports --recursive --in-place .
	uvx ruff format --config line-length=5000 .

.PHONY: rmd-to-pdf # compile rmd to pdf
rmd-to-pdf:
	Rscript -e 'for(p in c("rmarkdown", "ISLR", "IRkernel")) if(!requireNamespace(p, quietly = TRUE)) install.packages(p, repos = "https://cran.rstudio.com")'
	Rscript -e "rmarkdown::render('$(filepath)', output_format = 'pdf_document')"
	rm -rf *.bib *.aux *.log *.out *.synctex.gz

.PHONY: md-to-pdf # compile md to pdf
md-to-pdf:
	pandoc "$(filepath)" -o "$(basename $(filepath)).pdf"

.PHONY: help # generate help message
help:
	@echo "Usage: make [target]\n"
	@grep '^.PHONY: .* #' makefile | sed 's/\.PHONY: \(.*\) # \(.*\)/\1	\2/' | expand -t20
