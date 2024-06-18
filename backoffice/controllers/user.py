from app import app
from flask import json
from flask_login import login_required, current_user

@app.route("/api/user", methods = ['GET'])
@login_required
def user():
    response = app.response_class(
        response=json.dumps(current_user.serialize()),
        status=200,
        mimetype='application/json'
    )
    return response
    