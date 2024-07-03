from app import app
from flask import json

@app.route("/api/healthcheck", methods = ['GET'])
def healthcheck():
    response = app.response_class(
        response=json.dumps({"status": "ok"}),
        status=200,
        mimetype='application/json'
    )
    return response
    