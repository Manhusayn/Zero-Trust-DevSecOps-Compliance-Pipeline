SHELL := /bin/bash
IMAGE ?= zero-trust-demo:local

.PHONY: test lint build scan policy all

test:
	python3 -m unittest discover -s tests -v

lint:
	python3 -m compileall -q app tests

build:
	docker build --pull -t $(IMAGE) .

scan:
	trivy fs --exit-code 1 --severity HIGH,CRITICAL --ignore-unfixed .

policy:
	conftest test k8s --policy policies/kubernetes

all: test lint policy
