FROM python:3.10-slim

WORKDIR /app

# Copy build artifacts
COPY pyproject.toml ./
COPY src/ ./src/

# Install the package & prepare data directory
RUN pip install --no-cache-dir . \
    && mkdir -p /data

# Copy entrypoint
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 9000

ENV PYTHONUNBUFFERED=1

ENTRYPOINT ["docker-entrypoint.sh"]
