# Use official Python image
FROM python:3.11

# Set working directory
WORKDIR /app

# Install system dependencies (Tesseract)
RUN apt-get update && \
    apt-get install -y tesseract-ocr libtesseract-dev && \
    apt-get clean

# Copy project files
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set the path for Tesseract in pytesseract
ENV TESSDATA_PREFIX="/usr/share/tesseract-ocr/4.00/tessdata/"
ENV PATH="/usr/bin/:$PATH"

# Expose port 5000
EXPOSE 5000

# Start Flask app
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "OCR_Main:app"]
