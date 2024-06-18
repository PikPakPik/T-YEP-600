from app import app, db
from forms.user_data import UserDataForm
from flask import json, request
from flask_login import login_required, current_user

@app.route("/api/user", methods = ['GET', 'PUT'])
@login_required
def user():
    if request.method == 'PUT':
        form = UserDataForm(request.form)

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