.PHONY: help fmt update-reqs install-reqs

help:
	@printf "Usage: make [target]\n"
	@printf "\tfmt - run black formatter\n"
	@printf "\tupdate-reqs - update requirements.txt\n"
	@printf "\tinstall-reqs - install requirements.txt\n"
	@printf "\tup - git pull, add, commit, push\n"

fmt:
	pip install black
	black -l 200 .

update-reqs:
	pip install pipreqs
	rm -rf requirements.txt
	pipreqs .

install-reqs:
	pip install -r requirements.txt

up:
	git pull
	git add .
	git commit -m "up"
	git push
