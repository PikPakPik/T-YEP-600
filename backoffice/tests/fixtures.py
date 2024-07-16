from models.Hike import Hike
import pytest
from app import app, db
import json

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

@pytest.fixture(scope='session')
def createHike(pytestconfig):
    with app.app_context():
        hike = Hike(
            osmId=0, 
            name='Test Hike',
            firstNodeLat=0.0,
            firstNodeLon=0.0,
            lastNodeLat=0.0,
            lastNodeLon=0.0,
        )
        db.session.add(hike)
        db.session.commit()
        pytestconfig.cache.set("current_hike", hike.id)
        return hike.id 