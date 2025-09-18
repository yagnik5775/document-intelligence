FROM python:3.10-slim

WORKDIR /app

# Install PostgreSQL client, build tools, and common deps for Django libs
RUN apt-get update && apt-get install -y postgresql-client build-essential libpq-dev && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt 

# Copy app files including vector_store
COPY . .

# Add entrypoint script
COPY entrypoint.sh . 
RUN chmod +x entrypoint.sh

# Set environment variables
ENV DJANGO_SETTINGS_MODULE=document_intelligence.settings \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

ENTRYPOINT ["./entrypoint.sh"]
