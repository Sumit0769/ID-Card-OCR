# Use an official lightweight Python image
FROM python:3.11-slim

# Set environment variable to avoid interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# Update and install required dependencies including Tesseract OCR
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    libtesseract-dev \
    libleptonica-dev \
    tesseract-ocr-eng \
    && apt-get clean

# Set the working directory
WORKDIR /app

# Copy project files
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set environment variable for Tesseract path
ENV TESSERACT_PATH="/usr/bin/tesseract"
ENV PATH="/usr/bin:$PATH"

# Expose port 5000
EXPOSE 5000

# Run the application using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "OCR_Main:app"]
