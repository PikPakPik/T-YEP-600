from app import app, db
import json
from models.User import User
import pytest
from faker import Faker
fake = Faker()
from flask_bcrypt import generate_password_hash

@pytest.fixture(scope='session')
def loginFakeUser():
    name = fake.name().split(' ')
    email = fake.ascii_email()
    with app.app_context():
        password = generate_password_hash('azertyuiop', 12).decode('utf-8')
        user = User(firstname=name[0], lastname=name[1], email=email, password=password)
        db.session.add(user)
        db.session.commit()

    client = app.test_client()
    data = {
        'email': email,
        'password': 'azertyuiop'
    }
    response = client.post('/api/login', content_type='multipart/form-data', data=data)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    return response_json.get('token')

@pytest.fixture(scope='session')
def login():
    client = app.test_client()
    data = {
        'email': 'admin@tyep600.org',
        'password': 'azertyuiop'
    }
    response = client.post('/api/login', content_type='multipart/form-data', data=data)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    return response_json.get('token')

def test_user_without_token():
    client = app.test_client()
    response = client.get('/api/user')
    assert response.status_code == 401

@pytest.mark.depends(depends=['login'])
def test_user(login):
    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {login}'
    }
    response = client.get('/api/user', headers=headers)
    assert response.status_code == 200

#############
# User Data #
#############

@pytest.mark.depends(depends=['login'])
def test_user_update_with_invalid_data(login):
    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {login}'
    }
    name = fake.name().split(' ')
    data = {
        'firstnamee': name[0],
        'lastnamee': name[1],
        'emaill': "admin@tyep600.org",
    }
    response = client.put('/api/user', headers=headers, content_type='multipart/form-data', data=data)
    assert response.status_code == 400

@pytest.mark.depends(depends=['login'])
def test_user_update_with_invalid_email(login):
    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {login}'
    }
    name = fake.name().split(' ')
    data = {
        'firstname': name[0],
        'lastname': name[1],
        'emaill': "admin.tyep600.org",
    }
    response = client.put('/api/user', headers=headers, content_type='multipart/form-data', data=data)
    assert response.status_code == 400

@pytest.mark.depends(depends=['login'])
def test_user_update(login):
    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {login}'
    }
    name = fake.name().split(' ')
    data = {
        'firstname': name[0],
        'lastname': name[1],
        'email': "admin@tyep600.org",
    }
    response = client.put('/api/user', headers=headers, content_type='multipart/form-data', data=data)
    assert response.status_code == 200

#################
# User Password #
#################

@pytest.mark.depends(depends=['login'])
def test_user_update_password_with_bad_current_password(login):
    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {login}'
    }
    data = {
        'currentPassword': "azertyuiopp",
        'password': "azertyuiop",
        'confirmPassword': "azertyuiop",
    }
    response = client.put('/api/user/password', headers=headers, content_type='multipart/form-data', data=data)
    assert response.status_code == 400

@pytest.mark.depends(depends=['login'])
def test_user_update_password_with_bad_confirm_password(login):
    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {login}'
    }
    data = {
        'currentPassword': "azertyuiop",
        'password': "azertyuiop",
        'confirmPassword': "azertyuiopp",
    }
    response = client.put('/api/user/password', headers=headers, content_type='multipart/form-data', data=data)
    assert response.status_code == 400

@pytest.mark.depends(depends=['login'])
def test_user_update_password(login):
    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {login}'
    }
    data = {
        'currentPassword': "azertyuiop",
        'password': "azertyuiop",
        'confirmPassword': "azertyuiop",
    }
    response = client.put('/api/user/password', headers=headers, content_type='multipart/form-data', data=data)
    assert response.status_code == 200

@pytest.mark.depends(depends=['loginFakeUser'])
def test_user_delete(loginFakeUser):
    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {loginFakeUser}'
    }
    response = client.delete('/api/user', headers=headers)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == "user.deleted"
    assert response.status_code == 200