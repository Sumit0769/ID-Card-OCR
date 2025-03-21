# Use an official Python image
FROM python:3.11-slim

# Install Tesseract OCR
RUN apt-get update && apt-get install -y tesseract-ocr

# Set the working directory
WORKDIR /app

# Copy project files
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set Tesseract path
ENV TESSERACT_CMD=/usr/bin/tesseract

# Expose the Flask port
EXPOSE 5000

# Run the Flask app
CMD ["python", "OCR_Flask.py"]
