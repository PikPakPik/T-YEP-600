from app import app
import pytest
import jwt
from tests.fixtures import login

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