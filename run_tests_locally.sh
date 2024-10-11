#!/bin/bash

docker run -it --rm \
  -v "$(pwd):/build" \
  -w /build \
  artefact.skao.int/ska-cicd-k8s-tools-build-deploy:0.13.4 \
  bash -c "
    export POETRY_CONFIG_VIRTUALENVS_CREATE='false';
    export PIP_CACHE_DIR='./.cache/pip';

    if [ -f .make/python.mk ]; then
      echo '.make/python.mk found.';
    else
      echo 'File python.mk not included in Makefile; exiting.';
      exit 1;
    fi

    make help | grep python-test;

    poetry config virtualenvs.in-project true;
    echo 'python-build Setting.. poetry config virtualenvs.create \$POETRY_CONFIG_VIRTUALENVS_CREATE';
    poetry config virtualenvs.create \$POETRY_CONFIG_VIRTUALENVS_CREATE;

    if [[ -f pyproject.toml ]]; then
      if [[ -n \$CI_POETRY_VERSION ]] && [[ \$(poetry --version) != *\$CI_POETRY_VERSION* ]]; then
        echo 'python-test: Updating poetry to \$CI_POETRY_VERSION';
        time poetry self update \$CI_POETRY_VERSION;
      fi
      echo 'python-test: Installing with poetry';
      time poetry install --all-extras;
    elif [[ -f requirements.txt ]]; then
      echo 'python-test: Installing with pip';
      time pip3 install -r requirements.txt;
    fi

    make python-test;
  "
