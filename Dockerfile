# SPDX-FileCopyrightText: 2025 Idiap Research Institute <contact@idiap.ch>
# SPDX-FileContributor: Amir Mohammadi  <amir.mohammadi@idiap.ch>
#
# SPDX-License-Identifier: MIT

FROM pytorch/pytorch:2.6.0-cuda12.6-cudnn9-runtime

WORKDIR /app

# TruFor weights are NOT baked into the image. They arrive at runtime via a
# bind-mount on /app/weights (see docker-compose.yml). The host bootstrap
# script `setup.sh` is responsible for populating
# /opt/sophia-work-trial/deepid-baseline-docker/weights/ before the
# container starts.

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY src src
ENV PYTHONPATH=/app/src

# Expose the port the app runs on
EXPOSE 8000

# Command to run the application
CMD ["fastapi", "run", "--host", "0.0.0.0", "--port", "8000", "src/main.py"]
