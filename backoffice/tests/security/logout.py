from app import app
import json
import pytest
import jwt

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

@pytest.mark.depends(depends=['login'])
def test_user_logout(login):
    decoded_token = jwt.decode(login, app.config['SECRET_KEY'], audience='smarthike_app', algorithms=['HS256'])
    assert decoded_token.get('identifier') == "admin@tyep600.org"

    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {login}'
    }
    response = client.post('/api/logout', headers=headers)
    assert response.status_code == 200