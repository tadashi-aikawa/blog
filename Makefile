MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

.PHONY: $(shell egrep -oh ^[a-zA-Z_-]+: $(MAKEFILE_LIST) | sed 's/://')

help: ## Print this help
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

#-----

init: ## Prepare environment
	@echo 'Starting $@'
	@docker build -t blog/hugo .
	@echo 'Finished $@'

build: ## Build sites
	@echo 'Starting $@'
	@docker run -i -v `pwd`:/tmp --rm blog/hugo
	@echo 'Finished $@'

deploy: ## Deploy sites
	@echo 'Starting $@'
	@docker rm -f blog && echo "Remove a previous container" || echo "There are no container"
	@docker run --name blog -v `pwd`/docs:/usr/share/nginx/html:ro -d -p 8080:80 nginx
	@echo 'Finished $@'

release: init build deploy ## Release
