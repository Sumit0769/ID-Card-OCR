FROM python:3.9-slim-bullseye

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    tesseract-ocr \
    libgl1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python dependencies FIRST
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Then copy the rest of the files
COPY . .

# Fix the command (use "app:app" if your Flask instance is named 'app')
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]  
