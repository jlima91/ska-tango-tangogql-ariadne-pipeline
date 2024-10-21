KUBE_NAMESPACE?=testnamespace
CI_COMMIT_SHA?=local
HELM_RELEASE?=tangogql-ariadne
SECRET?=
OCI_IMAGES=ska-tango-tangogql-ariadne
PYTHON_SRC=tangogql-ariadne/
PYTHON_TEST_FILE=tangogql-ariadne/tests/
PYTHON_LINT_TARGET=tangogql-ariadne/tangogql
#tangogql-ariadne/tests/
PYTHON_VARS_AFTER_PYTEST=--cov=tangogql-ariadne/tangogql-ariadne
PROJECT=ska-tango-tangogql-ariadne
MINIKUBE ?= true ## Minikube or not
CLUSTER_DOMAIN ?= cluster.local
EXPOSE_All_DS ?= false

# Fixed variables
TIMEOUT = 86400

# Docker and Gitlab CI variables
RDEBUG ?= ""
CI_ENVIRONMENT_SLUG ?= development
CI_PIPELINE_ID ?= pipeline$(shell tr -c -d '0123456789abcdefghijklmnopqrstuvwxyz' </dev/urandom | dd bs=8 count=1 2>/dev/null;echo)
CI_JOB_ID ?= job$(shell tr -c -d '0123456789abcdefghijklmnopqrstuvwxyz' </dev/urandom | dd bs=4 count=1 2>/dev/null;echo)
GITLAB_USER ?= ""
CI_BUILD_TOKEN ?= ""
REPOSITORY_TOKEN ?= ""
REGISTRY_TOKEN ?= ""
GITLAB_USER_EMAIL ?= "nobody@example.com"
DOCKER_VOLUMES ?= /var/run/docker.sock:/var/run/docker.sock
CI_APPLICATION_TAG ?= $(shell git rev-parse --verify --short=8 HEAD)
DOCKERFILE ?= Dockerfile
EXECUTOR ?= docker
STAGE ?= build_tangogql_ariadne_artefacts

#
# include makefile to pick up the standard Make targets, e.g., 'make build'
# build, 'make push' docker push procedure, etc. The other Make targets
# ('make interactive', 'make test', etc.) are defined in this file.
#

# include k8s support
include .make/k8s.mk

# include Helm Chart support
include .make/helm.mk

# Include Python support
include .make/python.mk

# include raw support
include .make/raw.mk

# include core make support
include .make/base.mk

# include your own private variables for custom deployment configuration
-include PrivateRules.mak

OCI_BUILD_ADDITIONAL_ARGS= --build-arg SECRET=${SECRET}

# include OCI Images support
include .make/oci.mk

K8S_CHART_PARAMS = --set global.minikube=$(MINIKUBE) \
	--set global.exposeAllDS=$(EXPOSE_All_DS) \
	--set global.cluster_domain=$(CLUSTER_DOMAIN)

build-docs:
	docker run --rm -d -v $(PWD):/tmp -w /tmp/docs netresearch/sphinx-buildbox sh -c "make html"