# Dockerfile
FROM python:3.12-slim

# Set workdir
WORKDIR /app

# Copy all code
COPY . /app

# Install dependencies
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Expose port (Flask default)
EXPOSE 6202

# Start API
CMD ["python", "start_api.py"]
