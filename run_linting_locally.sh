#!/bin/bash

# Define the Python versions to test
PYTHON_VERSIONS=("3.10") # "3.11" "3.12"

for PYTHON_VERSION in "${PYTHON_VERSIONS[@]}"; do
  echo "Running tests with Python $PYTHON_VERSION..."

  docker run -it --rm \
    -v "$(pwd):/build" \
    -w /build \
    python:3.10 \
    bash -c "
      # Change directory to tangogql-ariadne and perform setup as in 'before_script'
      cd tangogql-ariadne/;
      ls -a;
      apt update;
      apt install -y jq;
      
      # Install pytest and other test dependencies
      pip install pytest-cov pytest-forked isort black flake8 pylint pylint-junit;
      pip install -e '.[tests]';

      # Ensure the build directory exists
      mkdir -p build/reports;

      # Run pytest with coverage options
      isort --profile black --line-length 79  tangogql/ tests/
      black --exclude .+\.ipynb --line-length 79  tangogql/ tests/
      flake8 --show-source --statistics --max-line-length 79  tangogql/ tests/
      pylint --output-format=parseable,parseable:build/code_analysis.stdout,pylint_junit.JUnitReporter:build/reports/linting.xml --max-line-length 79 --disable=C0103,R0801 tangogql/ tests/
    "

  echo "Finished tests with Python $PYTHON_VERSION."
done
