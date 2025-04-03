# Use an official lightweight Python image
FROM python:3.11-slim

# Install dependencies and Tesseract OCR
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    libtesseract-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the application files
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set environment variable for Tesseract path
ENV TESSERACT_PATH="/usr/bin/tesseract"

# Expose port 5000
EXPOSE 5000

# Run the application
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "OCR_Main:app"]
