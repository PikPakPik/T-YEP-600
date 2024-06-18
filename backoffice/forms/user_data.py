from wtforms import Form, StringField, PasswordField, validators

class UserDataForm(Form):
    firstname = StringField('firstname', [
        validators.DataRequired(message='validator.firstname.required'),
    ])
    lastname = StringField('lastname', [
        validators.DataRequired(message='validator.lastname.required'),
    ])
    email = StringField('email', [
        validators.DataRequired(message='validator.email.required'),
        validators.Email(message='validator.email.invalid')
    ])