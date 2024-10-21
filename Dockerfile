# Use the Debian 12 slim base image
FROM debian:12-slim

# Set the working directory inside the container
WORKDIR /tangogql

# Copy all files from the current directory to the working directory in the container
COPY ./tangogql-ariadne .

# Update package list, install necessary packages, create virtual environment, activate it, and install dependencies
RUN apt update && apt -y install python3.11 python3.11-dev python3.11-venv git make gcc && \
    python3.11 -m venv .venv && \
    . .venv/bin/activate && \
    pip install -e .

# Expose port 5004 to allow external access to the application
EXPOSE 5004

# Use CMD to run uvicorn with the required arguments in shell form
CMD .venv/bin/uvicorn tangogql.main:app --host 0.0.0.0 --port 5004
