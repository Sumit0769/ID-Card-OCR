# Use an official Python runtime as a parent image
FROM python:3.11-slim

# Install system dependencies (Tesseract + required libraries)
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    libtesseract-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy project files
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set Tesseract path in the environment
ENV TESSDATA_PREFIX=/usr/share/tesseract-ocr/4.00/tessdata
ENV TESSERACT_PATH=/usr/bin/tesseract

# Expose port 5000 for Flask
EXPOSE 5000

# Run the Flask app using Gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:5000", "OCR_Main:app"]
