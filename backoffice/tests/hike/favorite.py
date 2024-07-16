import pytest
from app import app
from tests.fixtures import login, createHike
import json

############
# Fixtures #
############

@pytest.fixture()
def currentHike(pytestconfig):
    hike_id = pytestconfig.cache.get("current_hike", None)
    if hike_id is None:
        pytest.skip("currentHike not set")
    return hike_id

#####################
# Get user favorite #
#####################

def test_get_user_favorite_without_token():
    client = app.test_client()
    response = client.get('/api/hike/favorites')
    assert response.status_code == 401

@pytest.mark.depends(depends=['login'])
def test_get_user_favorite(login):
    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {login}'
    }
    response = client.get('/api/hike/favorites', headers=headers)
    assert response.status_code == 200

@pytest.mark.depends(depends=['login'])
def test_get_user_favorite_with_exceed_limit(login):
    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {login}'
    }
    response = client.get('/api/hike/favorites?limit=1001', headers=headers)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == 'pagination.limit.invalid'
    assert response.status_code == 400


#####################
# Add user favorite #
#####################

def test_add_user_favorite_without_user_token():
    client = app.test_client()
    response = client.post('/api/hike/1/favorite')
    assert response.status_code == 401

@pytest.mark.depends(depends=['login'])
def test_add_user_favorite_not_found(login):
    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {login}'
    }
    response = client.post('/api/hike/0/favorite', headers=headers)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == 'hike.not_found'
    assert response.status_code == 404

@pytest.mark.depends(depends=['login', 'createHike'])
def test_add_user_favorite(login, createHike):
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
def test_add_user_favorite_already_added(login, currentHike):
    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {login}'
    }
    response = client.post(f'/api/hike/{currentHike}/favorite', headers=headers)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == 'hike.favorite.already_exists'
    assert response.status_code == 400

########################
# Remove user favorite #
########################

def test_delete_user_favorite_without_user_token():
    client = app.test_client()
    response = client.delete('/api/hike/0/favorite')
    assert response.status_code == 401

@pytest.mark.depends(depends=['login'])
def test_delete_user_favorite_not_found(login):
    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {login}'
    }
    response = client.delete('/api/hike/0/favorite', headers=headers)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == 'hike.not_found'
    assert response.status_code == 404

@pytest.mark.depends(depends=['login', 'currentHike'])
def test_delete_user_favorite(login, currentHike):
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
def test_delete_user_favorite_already_deleted(login, currentHike):
    client = app.test_client()
    headers = {
        'Authorization': f'Bearer {login}'
    }
    response = client.delete(f'/api/hike/{currentHike}/favorite', headers=headers)
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == 'hike.favorite.does_not_exist'
    assert response.status_code == 400