from wtforms import Form, StringField, PasswordField, validators

class LoginForm(Form):
    email = StringField('email', [
        validators.DataRequired(message='security.login.email_required'),
        validators.Email(message='security.login.invalid_email')
    ])
    password = PasswordField('password', [
        validators.DataRequired(message='security.login.password_required'),
        validators.Length(message='security.login.invalid_password', min=8)
    ])