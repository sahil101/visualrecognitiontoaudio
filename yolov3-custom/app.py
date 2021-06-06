from flask import *
from model import take_photo
import boto3
import json
from textdetection import recognize_text
app = Flask("app")

region = 'ap-south-1'
bucket = 'flask-api-s3-v2'
s3 = boto3.resource('s3')

@app.route('/getobjects', methods = ['POST'])
def objects():
        if request.method == 'POST':
                f = request.files['image']
                s3.Bucket(bucket).upload_file(f, f.filename);
                result = take_photo(f.filename)
                json_object = json.dumps(result,indent = 2)
                return json_object

@app.route('/gettext', methods={'POST'})
def text():
        if request.method == 'POST':
                client = boto3.client('rekognition')
                f = request.files['image']
                s3.Bucket(bucket).upload_file(f, f.filename);
                results = recognize_text(f.filename)
                textdetections = response['TextDetections']
                results = {}
                l = 0
                for item in textdetections:
                        if item['Confidence'] > 95:
                            r = {'confidence_score': str(item['Confidence']),
                            'text': item['DetectedText'],
                            'H': str(item["Geometry"]["BoundingBox"]["Height"]),
                            'W': str(item["Geometry"]["BoundingBox"]["Width"]),
                            'top': str(item["Geometry"]["BoundingBox"]["Top"]),
                            'left':str(item["Geometry"]["BoundingBox"]["Left"])}
                            results[str(l)] = r
                            l = l + 1
                return results



