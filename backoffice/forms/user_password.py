from wtforms import Form, PasswordField, validators

class UserPasswordForm(Form):
    currentPassword = PasswordField('currentPassword', [
        validators.DataRequired(message='validator.password.required'),
        validators.Length(message='validator.password.invalid', min=8)
    ])
    password = PasswordField('password', [
        validators.DataRequired(message='validator.password.required'),
        validators.Length(message='validator.password.invalid', min=8)
    ])
    confirmPassword = PasswordField('confirmPassword', [
        validators.DataRequired(message='validator.password.required'),
        validators.Length(message='validator.password.invalid', min=8),
        validators.EqualTo('password', message='validator.password.match')
    ])