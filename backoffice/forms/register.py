from wtforms import Form, StringField, PasswordField, validators

class RegisterForm(Form):
    firstname = StringField('firstname', [
        validators.DataRequired(message='security.register.firstname_required'),
    ])
    lastname = StringField('lastname', [
        validators.DataRequired(message='security.register.lastname_required'),
    ])
    email = StringField('email', [
        validators.DataRequired(message='security.register.email_required'),
        validators.Email(message='security.register.invalid_email')
    ])
    password = PasswordField('password', [
        validators.DataRequired(message='security.register.password_required'),
        validators.Length(message='security.register.invalid_password', min=8)
    ])