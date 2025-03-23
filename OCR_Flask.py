from flask import Flask, request, render_template, redirect, url_for
from PIL import Image
import pytesseract
import cv2
import os
import re
import ftfy

app = Flask(__name__)
UPLOAD_FOLDER = "static/uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

# Path to Tesseract OCR
#pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"
pytesseract.pytesseract.tesseract_cmd = "/usr/bin/tesseract"
def extract_details(image_path):
    image = cv2.imread(image_path)
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    gray = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY | cv2.THRESH_OTSU)[1]
    
    # Save temp image
    temp_filename = "temp_ocr.png"
    cv2.imwrite(temp_filename, gray)
    
    # OCR Extraction
    text = pytesseract.image_to_string(Image.open(temp_filename), lang="eng")
    os.remove(temp_filename)
    
    # Clean text
    text = ftfy.fix_text(text)
    text = ftfy.fix_encoding(text)
    
    # Extract details
    name, prn, course = None, None, None
    lines = [line.strip() for line in text.split("\n") if line.strip()]
    for line in lines:
        if re.search(r"(M\.Sc|MSc|Data Science|Spatial Analytics)", line, re.IGNORECASE):
            course_1 = line.strip()
        if re.search(r"Analytics", line, re.IGNORECASE):
            course_2 = line.strip()
        if re.search(r"Mr\.|Ms\.", line, re.IGNORECASE):
            name = line.strip()
        if re.search(r"^240702430\d{2}$", line):
            prn = line.strip()
    
    return {"Course": course_1+" "+course_2, "Name": name, "PRN": prn}

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        if "file" not in request.files:
            return redirect(request.url)
        
        file = request.files["file"]
        if file.filename == "":
            return redirect(request.url)
        
        if file:
            filepath = os.path.join(UPLOAD_FOLDER, file.filename)
            file.save(filepath)
            extracted_data = extract_details(filepath)
            return render_template("OCR HTML.html", extracted_data=extracted_data, image_path=filepath)

    return render_template("OCR HTML.html", extracted_data=None)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000,debug=True)
