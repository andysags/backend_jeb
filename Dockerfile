# Example Dockerfile for deploying the Django app
# Uses a slim image and installs required system libs for psycopg2, Pillow, cryptography, etc.
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libjpeg-dev \
    zlib1g-dev \
    libssl-dev \
    libffi-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# create virtualenv in image
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /app

# copy only requirements first for better caching
COPY requirements-production.txt /app/requirements-production.txt

RUN pip install --upgrade pip setuptools wheel
RUN pip install -r /app/requirements-production.txt

# copy project
COPY . /app

# collectstatic if you use static files (optional)
# RUN python manage.py collectstatic --noinput

CMD ["gunicorn", "incubator.wsgi:application", "--bind", "0.0.0.0:8000"]
