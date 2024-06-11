from app import app
from flask import json

@app.route("/api/user", methods = ['GET'])
def user():
    data = {
        "name": "John Doe",
        "email": ""
    }
    response = app.response_class(
        response=json.dumps(data),
        status=200,
        mimetype='application/json'
    )
    return response
    