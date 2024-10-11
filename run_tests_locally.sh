#!/bin/bash

# Define the Python versions to test
PYTHON_VERSIONS=("3.10") # "3.11" "3.12"

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
      apt install -y jq \$EXTRA_DEB_PACKAGES;
      python -m venv /tools;
      /tools/bin/python -m pip install wheel-inspect;
      
      # Install pytest and other test dependencies
      pip install pytest-cov pytest-forked;
      pip install -e '.[tests]';

      # Run pytest with coverage options
      pytest --cov=tangogql --cov-branch --cov-report term-missing --cov-report html --junitxml=report.xml \$PYTEST_EXTRA_ARGS;
    "

  echo "Finished tests with Python $PYTHON_VERSION."
done
