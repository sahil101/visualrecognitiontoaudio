from flask import *
from model import take_photo
app = Flask("app")
@app.route('/getobjects', methods = ['POST'])
def success():
        if request.method == 'POST':
                f = request.files['image']
                f.save(f.filename)
                result = take_photo(f.filename)

                return results

