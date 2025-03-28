# Base image with Python 3.10
FROM python:3.10-slim

# System deps
RUN apt-get update && apt-get install -y \
	curl \
	build-essential \
	git \
	&& rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 - && \
	ln -s /root/.local/bin/poetry /usr/local/bin/poetry

# Disable poetry creating venvs (we want global env in container)
ENV POETRY_VIRTUALENVS_CREATE=false

# Set working directory
WORKDIR /app

# Install awscli + metaflow dependencies
RUN pip install --upgrade pip && pip install awscli boto3 psutil

# Copy Poetry project files
COPY pyproject.toml poetry.lock* ./

# Install deps
RUN poetry install --no-root --no-interaction --no-ansi

# Copy source code
COPY . .

# (Optional) Add __init__.py if needed
RUN mkdir -p flows models data utils && \
	touch flows/__init__.py models/__init__.py data/__init__.py utils/__init__.py

# Set AWS Region as default environment var
ENV AWS_DEFAULT_REGION=us-east-1

# CMD not ENTRYPOINT so Batch can override it
CMD ["python"]
