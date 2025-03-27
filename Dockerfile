# Start with base Python image
FROM python:3.10-slim

# Install OS-level deps
RUN apt-get update && apt-get install -y curl build-essential git && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    ln -s /root/.local/bin/poetry /usr/local/bin/poetry

# Set working directory
WORKDIR /app

# Copy only project files needed for dependency resolution
COPY pyproject.toml poetry.lock* ./

# Install dependencies (no virtualenv inside container)
ENV POETRY_VIRTUALENVS_CREATE=false
RUN poetry install --no-interaction --no-ansi

# Copy the rest of the source code
COPY . .

# Add init files (just in case)
RUN touch flows/__init__.py models/__init__.py data/__init__.py utils/__init__.py

# Run Metaflow flow
ENTRYPOINT ["python", "flows/train_model_flow.py", "run"]
