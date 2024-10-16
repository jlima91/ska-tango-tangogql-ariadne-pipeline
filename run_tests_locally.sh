#!/bin/bash

# Define the Python versions to test
PYTHON_VERSIONS=("3.11")

for PYTHON_VERSION in "${PYTHON_VERSIONS[@]}"; do
  echo "Running tests with Python $PYTHON_VERSION..."

  docker run -it --rm \
    -v "$(pwd):/build" \
    -w /build \
    ghcr.io/astral-sh/uv:python${PYTHON_VERSION}-bookworm \
    bash -c "
      # Change directory to tangogql-ariadne and perform setup as in 'before_script'
      cd tangogql-ariadne/;
      ls -a;
      apt update;
      apt install -y jq;
      python -m venv /tools;
      /tools/bin/python -m pip install wheel-inspect;
      
      # Install pytest and other test dependencies
      pip install pytest-cov pytest-forked;
      pip install -e '.[tests]';

      # Run pytest with coverage options
      pytest -k unit --forked -vv --cov=tangogql --cov-report=term-missing --cov-report html:build/reports/code-coverage --cov-report xml:build/reports/code-coverage.xml --junitxml=build/reports/unit-tests.xml tests/
    "

  echo "Finished tests with Python $PYTHON_VERSION."
done
