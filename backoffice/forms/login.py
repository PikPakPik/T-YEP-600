from wtforms import Form, StringField, PasswordField, validators

class LoginForm(Form):
    email = StringField('email', [
        validators.DataRequired(message='validator.email.required'),
        validators.Email(message='validator.email.invalid')
    ])
    password = PasswordField('password', [
        validators.DataRequired(message='validator.password.required'),
        validators.Length(message='validator.password.invalid', min=8)
    ])