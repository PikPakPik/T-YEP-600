from app import app
import json
import pytest

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

def test_user_without_token(login):
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
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response.status_code == 200