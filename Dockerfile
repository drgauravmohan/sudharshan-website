FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN python manage.py collectstatic --noinput

EXPOSE 8080

# Use shell form (not exec form) so $PORT gets expanded by the shell
CMD gunicorn --bind 0.0.0.0:$PORT --workers 2 --threads 4 --timeout 120 medantaclone.wsgi:application
