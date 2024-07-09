from app import app, db
import json
from models.Hike import Hike
import pytest

@pytest.fixture(scope='session')
def createHike(pytestconfig):
    with app.app_context():
        hikes = []
        for i in range(50):
            hike = Hike(
                osmId=i, 
                name=f'Test Hike {i}',
                firstNodeLat=0.0,
                firstNodeLon=0.0,
                lastNodeLat=0.0,
                lastNodeLon=0.0,
            )
            db.session.add(hike)
            hikes.append(hike)
        db.session.commit()
        pytestconfig.cache.set("current_hike", hikes[0].id)
        return hikes[0].id 

@pytest.fixture()
def currentHike(pytestconfig):
    hike_id = pytestconfig.cache.get("current_hike", None)
    if hike_id is None:
        pytest.skip("currentHike not set")
    return hike_id

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

def test_hike_get_user_favorite_without_token():
    client = app.test_client()
    response = client.get('/api/hike/favorites')
    assert response.status_code == 401

@pytest.mark.depends(depends=['login'])
def test_hike_get_user_favorite(login):
    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {login}'
    }
    response = client.get('/api/hike/favorites', headers=headers)
    assert response.status_code == 200

@pytest.mark.depends(depends=['login'])
def test_hike_get_user_favorite_with_exceed_limit(login):
    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {login}'
    }
    response = client.get('/api/hike/favorites?limit=1001', headers=headers)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == 'pagination.limit.invalid'
    assert response.status_code == 403

def test_hike_add_user_favorite_without_user_token():
    client = app.test_client()
    response = client.post('/api/hike/99999999999999999999999999/favorite')
    assert response.status_code == 401

@pytest.mark.depends(depends=['login'])
def test_hike_add_user_favorite_not_found(login):
    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {login}'
    }
    response = client.post('/api/hike/99999999999999999999999999/favorite', headers=headers)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == 'hike.not_found'
    assert response.status_code == 404

@pytest.mark.depends(depends=['login', 'createHike'])
def test_hike_add_user_favorite(login, createHike):
    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {login}'
    }
    response = client.post(f'/api/hike/{createHike}/favorite', headers=headers)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == 'hike.favorite.added'
    assert response.status_code == 200

@pytest.mark.depends(depends=['login', 'currentHike'])
def test_hike_add_user_favorite_already_added(login, currentHike):
    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {login}'
    }
    response = client.post(f'/api/hike/{currentHike}/favorite', headers=headers)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == 'hike.favorite.already_exists'
    assert response.status_code == 400


def test_hike_delete_user_favorite_without_user_token():
    client = app.test_client()
    response = client.delete('/api/hike/99999999999999999999999999/favorite')
    assert response.status_code == 401

@pytest.mark.depends(depends=['login'])
def test_hike_delete_user_favorite_not_found(login):
    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {login}'
    }
    response = client.delete('/api/hike/99999999999999999999999999/favorite', headers=headers)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == 'hike.not_found'
    assert response.status_code == 404

@pytest.mark.depends(depends=['login', 'currentHike'])
def test_hike_delete_user_favorite(login, currentHike):
    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {login}'
    }
    response = client.delete(f'/api/hike/{currentHike}/favorite', headers=headers)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == 'hike.favorite.deleted'
    assert response.status_code == 200

@pytest.mark.depends(depends=['login', 'currentHike'])
def test_hike_delete_user_favorite_already_deleted(login, currentHike):
    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {login}'
    }
    response = client.delete(f'/api/hike/{currentHike}/favorite', headers=headers)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == 'hike.favorite.does_not_exist'
    assert response.status_code == 400

def test_get_hikes_default():
    client = app.test_client()
    response = client.get('/api/hikes')
    assert response.status_code == 200
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert len(response_json.get('items')) == 25

def test_get_hikes_limit_exceed():
    client = app.test_client()
    response = client.get('/api/hikes?limit=1001')
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == 'pagination.limit.invalid'
    assert response.status_code == 403