import datetime
from app import app, db
import re
from models.User import User
from models.Session import Session
from flask import json, request
from flask_bcrypt import generate_password_hash, check_password_hash
import jwt

@app.route("/api/login", methods = ['POST'])
def login():
    if len(request.form.get('email')) > 0 and re.match(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)", request.form.get('email')):
        email = request.form.get('email')
    else:
        response = app.response_class(
            response=json.dumps({
                'i18n': 'security.login.invalid_email'
            }),
            status=400,
            mimetype='application/json'
        )
        return response

    if len(request.form.get('password')) >= 8:
        password = request.form.get('password')
    else:
        response = app.response_class(
            response=json.dumps({
                'greaterOrEqualThan': len(request.form.get('password')) >= 8,
                'i18n': 'security.login.invalid_password'
            }),
            status=400,
            mimetype='application/json'
        )
        return response

    user = User.query.filter_by(email=email).first()
    if (user is None) or (not check_password_hash(user.password, password)):
        response = app.response_class(
            response=json.dumps({
                'i18n': 'security.login.invalid_credentials'
            }),
            status=400,
            mimetype='application/json'
        )
        return response

    encoded_token = jwt.encode(
        {
            "identifier": user.email,
            "aud": "smarthike_app",
            "iat": datetime.datetime.now(tz=datetime.timezone.utc),
            "exp": datetime.datetime.now(tz=datetime.timezone.utc) + datetime.timedelta(hours=24),
        },
        app.config['JWT_KEY'],
        algorithm="HS256"
    )

    session = Session(user=user.id, token=encoded_token)
    db.session.add(session)
    db.session.commit()

    response = app.response_class(
        response=json.dumps({
            'token': encoded_token
        }),
        status=200,
        mimetype='application/json'
    )
    return response


@app.route("/api/register", methods = ['POST'])
def register():
    if len(request.form.get('firstname')) > 0 and re.match(r"(^[a-zA-Z]+$)", request.form.get('firstname')):
        firstname = request.form.get('firstname')
    else:
        response = app.response_class(
            response=json.dumps({
                'i18n': 'security.register.invalid_firstname'
            }),
            status=400,
            mimetype='application/json'
        )
        return response
    
    if len(request.form.get('lastname')) > 0 and re.match(r"(^[a-zA-Z]+$)", request.form.get('lastname')):
        lastname = request.form.get('lastname')
    else:
        response = app.response_class(
            response=json.dumps({
                'i18n': 'security.register.invalid_lastname'
            }),
            status=400,
            mimetype='application/json'
        )
        return response
    
    if len(request.form.get('email')) > 0 and re.match(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)", request.form.get('email')):
        email = request.form.get('email')
    else:
        response = app.response_class(
            response=json.dumps({
                'i18n': 'security.register.invalid_email'
            }),
            status=400,
            mimetype='application/json'
        )
        return response

    if len(request.form.get('password')) >= 8:
        password = request.form.get('password')
    else:
        response = app.response_class(
            response=json.dumps({
                'greaterOrEqualThan': len(request.form.get('password')) >= 8,
                'i18n': 'security.register.invalid_password'
            }),
            status=400,
            mimetype='application/json'
        )
        return response
    
    user = User(firstname=firstname, lastname=lastname, email=email, password=Bcrypt.generate_password_hash('hunter2', 12).decode('utf-8'))

    app.logger.debug(f'User created : {user.email}')

    response = app.response_class(
        response=json.dumps({}),
        status=200,
        mimetype='application/json'
    )
    return response
    