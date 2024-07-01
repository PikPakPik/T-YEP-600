from app import app
import json
import jwt

def test_login_no_data():
    client = app.test_client()
    response = client.post('/api/login')
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == "security.login.invalid_credentials"
    assert response.status_code == 400

def test_login_with_invalid_email():
    client = app.test_client()
    data = {
        'email': 'ddd',
        'password': 'azertyuiop'
    }
    response = client.post('/api/login', content_type='multipart/form-data', data=data)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == "security.login.invalid_credentials"
    assert response.status_code == 400

def test_login_with_invalid_password():
    client = app.test_client()
    data = {
        'email': 'dd@dd.com',
        'password': 'azeuiop'
    }
    response = client.post('/api/login', content_type='multipart/form-data', data=data)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == "security.login.invalid_credentials"
    assert response.status_code == 400

def test_login():
    client = app.test_client()
    data = {
        'email': 'admin@tyep600.org',
        'password': 'azertyuiop'
    }
    response = client.post('/api/login', content_type='multipart/form-data', data=data)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    token = response_json.get('token')
    assert response.status_code == 200

    decoded_token = jwt.decode(token, app.config['SECRET_KEY'], audience='smarthike_app', algorithms=['HS256'])
    assert decoded_token.get('identifier') == "admin@tyep600.org"