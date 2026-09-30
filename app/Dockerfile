FROM python:3.11-slim

# Create a non-root user
RUN groupadd --gid 1001 appuser \
 && useradd --uid 1001 --gid appuser --shell /bin/bash --create-home appuser

WORKDIR /app

# Install dependencies first (better layer caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code and set ownership
COPY --chown=appuser:appuser app.py .

# Switch to the non-root user
USER appuser

EXPOSE 8080

# Use Gunicorn (production WSGI server) instead of Flask dev server
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "2", "--access-logfile", "-", "--error-logfile", "-", "app:app"]