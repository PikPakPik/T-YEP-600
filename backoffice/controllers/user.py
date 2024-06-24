from app import app, db
from forms.user_data import UserDataForm
from forms.user_password import UserPasswordForm
from flask import json, request
from flask_login import login_required, current_user
from flask_bcrypt import generate_password_hash, check_password_hash

@app.route("/api/user", methods = ['GET', 'PUT'])
@login_required
def user():
    if request.method == 'PUT':
        form = UserDataForm(request.form)

        if form.validate() is False:
            response = app.response_class(
                response=json.dumps({
                    'i18n': 'user.invalid.credentials',
                    'errors': form.errors
                }),
                status=400,
                mimetype='application/json'
            )
            return response
        
        current_user.firstname = form.firstname.data
        current_user.lastname = form.lastname.data
        current_user.email = form.email.data
        db.session.commit()

    response = app.response_class(
        response=json.dumps(current_user.serialize()),
        status=200,
        mimetype='application/json'
    )
    return response

@app.route("/api/user/password", methods = ['PUT'])
@login_required
def userPassword():
    form = UserPasswordForm(request.form)

    if form.validate() is False:
        response = app.response_class(
            response=json.dumps({
                'i18n': 'user.invalid.credentials',
                'errors': form.errors
            }),
            status=400,
            mimetype='application/json'
        )
        return response
    
    if not check_password_hash(current_user.password, form.currentPassword.data):
        response = app.response_class(
            response=json.dumps({
                'i18n': 'user.invalid.credentials',
                'errors': {
                    'currentPassword': ['validator.password.invalid']
                }
            }),
            status=400,
            mimetype='application/json'
        )
        return response

    
    current_user.password = generate_password_hash(form.password.data, 12).decode('utf-8')
    db.session.commit()

    response = app.response_class(
        response=json.dumps(current_user.serialize()),
        status=200,
        mimetype='application/json'
    )
    return response