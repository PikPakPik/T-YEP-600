import datetime
from app import db, login_manager
from models.User import User
from models.Session import Session

@login_manager.request_loader
def load_user_from_request(request):
    authorization_header = request.headers.get('Authorization')
    if (authorization_header is None) or (authorization_header.startswith('Bearer ') is False):
        return None
    
    token = authorization_header[7:]

    session = Session.query.filter_by(token=token).first()
    if (session is None) or (session.expireAt <= datetime.datetime.now()):
        return None
    
    session.lastUsedAt = datetime.datetime.now()
    db.session.commit()
    
    user = User.query.filter_by(id=session.user).first()
    
    return user