import pytest
from app import app
from tests.fixtures import createHike
import json

#########
# Hikes #
#########

def test_get_hikes():
    client = app.test_client()
    response = client.get('/api/hikes')
    assert response.status_code == 200

def test_get_hikes_with_exceed_limit():
    client = app.test_client()
    response = client.get('/api/hikes?limit=1001')
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == 'pagination.limit.invalid'
    assert response.status_code == 400

########
# Hike #
########

def test_get_hike_not_found():
    client = app.test_client()
    response = client.get('/api/hike/0')
    response_data = response.data.decode('utf-8')
    response_json = json.loads(response_data)
    assert response_json.get('i18n') == 'hike.not_found'
    assert response.status_code == 404

@pytest.mark.depends(depends=['createHike'])
def test_get_hike(createHike):
    client = app.test_client()
    response = client.get(f'/api/hike/{createHike}')
    assert response.status_code == 200