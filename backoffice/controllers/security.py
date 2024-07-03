import datetime
from app import app, db
from forms.register import RegisterForm
from forms.login import LoginForm
from models.User import User
from models.Session import Session
from flask import json, request
from flask_bcrypt import generate_password_hash, check_password_hash
import jwt
from flask_login import login_required

@app.route("/api/login", methods = ['POST'])
def login():
    form = LoginForm(request.form)

    if form.validate() is False:
        response = app.response_class(
            response=json.dumps({
                'i18n': 'security.login.invalid_credentials',
                'errors': form.errors
            }),
            status=400,
            mimetype='application/json'
        )
        return response

    user = User.query.filter_by(email=form.email.data).first()
    if (user is None) or (not check_password_hash(user.password, form.password.data)):
        response = app.response_class(
            response=json.dumps({
                'i18n': 'security.login.invalid_credentials'
            }),
            status=400,
            mimetype='application/json'
        )
        return response
    
    user.lastLogin = datetime.datetime.now()
    db.session.commit()

    encoded_token = createJwt(user)

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
    form = RegisterForm(request.form)

    if form.validate() is False:
        response = app.response_class(
            response=json.dumps({
                'i18n': 'security.register.invalid_credentials',
                'errors': form.errors
            }),
            status=400,
            mimetype='application/json'
        )
        return response
    
    user = User.query.filter_by(email=form.email.data).first()
    if user is not None:
        response = app.response_class(
            response=json.dumps({
                'i18n': 'security.register.email_already_exists'
            }),
            status=400,
            mimetype='application/json'
        )
        return response
    
    user = User(firstname=form.firstname.data, lastname=form.lastname.data, email=form.email.data, password=generate_password_hash(form.password.data, 12).decode('utf-8'))
    db.session.add(user)
    db.session.commit()

    encoded_token = createJwt(user)

    response = app.response_class(
        response=json.dumps({
            'token': encoded_token
        }),
        status=200,
        mimetype='application/json'
    )
    return response
    
@app.route("/api/logout", methods = ['POST'])
@login_required
def logout():
    request.headers.get('Authorization')
    session = Session.query.filter_by(token=request.headers.get('Authorization')[7:]).first()
    db.session.delete(session)
    db.session.commit()
    response = app.response_class(
        response=json.dumps({
            'i18n': 'security.logout.success'
        }),
        status=200,
        mimetype='application/json'
    )
    return response

def createJwt(user: User):
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
    return encoded_token