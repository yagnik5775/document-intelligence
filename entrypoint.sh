#!/bin/sh
set -e  # exit if any command fails

echo "Waiting for PostgreSQL at $DB_HOST:$DB_PORT..."

until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER"; do
  sleep 2
done

echo "PostgreSQL is ready!"

# Apply database migrations
python manage.py makemigrations --noinput
python manage.py migrate --noinput
echo "Migrations applied!"

# Collect static files
python manage.py collectstatic --noinput

# Start Gunicorn server
exec gunicorn document_intelligence.wsgi:application \
    --bind 0.0.0.0:8003 \
    --workers 1 \
    --worker-class gthread \
    --threads 2 \
    --timeout 120
