FROM python:3.9-bullseye  

# Install system dependencies with verification
RUN apt-get update && \
    apt-get install -y \
    tesseract-ocr \
    tesseract-ocr-eng \
    libleptonica-dev \
    libgl1 \
    libsm6 \
    libxext6 \
    libxrender-dev && \
    rm -rf /var/lib/apt/lists/* && \
    tesseract --version  # Verify installation

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Confirm Tesseract path exists
RUN ls -l /usr/bin/tesseract

CMD ["gunicorn", "--bind", "0.0.0.0:10000", "app:app"]
