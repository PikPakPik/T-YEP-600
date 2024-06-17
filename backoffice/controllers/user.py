from app import app
from flask import json
from flask_login import login_required

@app.route("/api/user", methods = ['GET'])
@login_required
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
    