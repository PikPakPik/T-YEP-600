from app import app
import json
import jwt
from faker import Faker
fake = Faker()

def test_register_no_data():
    client = app.test_client()
    response = client.post('/api/register')
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == "security.register.invalid_credentials"
    assert response.status_code == 400

def test_register_with_invalid_firstname():
    client = app.test_client()
    data = {
        'firstname': 'dd@d',
        'lastname': 'ddd',
        'email': 'ddd',
        'password': 'azertyuiop'
    }
    response = client.post('/api/register', content_type='multipart/form-data', data=data)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == "security.register.invalid_credentials"
    assert response.status_code == 400

def test_register_with_invalid_lastname():
    client = app.test_client()
    data = {
        'firstname': 'ddd',
        'lastname': 'dd@d',
        'email': 'ddd',
        'password': 'azertyuiop'
    }
    response = client.post('/api/register', content_type='multipart/form-data', data=data)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == "security.register.invalid_credentials"
    assert response.status_code == 400

def test_register_with_invalid_email():
    client = app.test_client()
    data = {
        'firstname': 'ddd',
        'lastname': 'ddd',
        'email': 'ddd',
        'password': 'azertyuiop'
    }
    response = client.post('/api/register', content_type='multipart/form-data', data=data)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == "security.register.invalid_credentials"
    assert response.status_code == 400

def test_register_with_invalid_password():
    client = app.test_client()
    data = {
        'firstname': 'ddd',
        'lastname': 'ddd',
        'email': 'dd@dd.com',
        'password': 'azeuiop'
    }
    response = client.post('/api/register', content_type='multipart/form-data', data=data)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == "security.register.invalid_credentials"
    assert response.status_code == 400

def test_register_with_existing_email():
    client = app.test_client()
    name = fake.name().split(' ')
    data = {
        'firstname': name[0],
        'lastname': name[1],
        'email': 'admin@tyep600.org',
        'password': 'azertyuiop'
    }
    response = client.post('/api/register', content_type='multipart/form-data', data=data)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == "security.register.email_already_exists"
    assert response.status_code == 400

def test_register():
    client = app.test_client()
    name = fake.name().split(' ')
    email = fake.ascii_email()
    data = {
        'firstname': name[0],
        'lastname': name[1],
        'email': email,
        'password': 'azertyuiop'
    }
    response = client.post('/api/register', content_type='multipart/form-data', data=data)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    token = response_json.get('token')
    assert response.status_code == 200

    decoded_token = jwt.decode(token, app.config['SECRET_KEY'], audience='smarthike_app' ,algorithms=['HS256'])
    assert decoded_token.get('identifier') == email