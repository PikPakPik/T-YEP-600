import datetime
from app import db
from flask_login import UserMixin

class User(UserMixin, db.Model):
    __tablename__ = 'users'
    __table_args__ = {'extend_existing': True, 'mysql_engine':'InnoDB'}

    id = db.Column(db.Integer, primary_key=True)
    firstname = db.Column(db.String(255), nullable=False)
    lastname = db.Column(db.String(255), nullable=False)
    email = db.Column(db.String(255), nullable=False, unique=True)
    password = db.Column(db.String(255), nullable=False)
    lastLogin = db.Column('last_login', db.DateTime, nullable=True)
    createdAt = db.Column('created_at', db.DateTime, nullable=False, default=datetime.datetime.now)
    updatedAt = db.Column('updated_at', db.DateTime, nullable=True, onupdate=datetime.datetime.now)

    def serialize(self):
        return {
            'id': self.id,
            'firstname': self.firstname,
            'lastname': self.lastname,
            'email': self.email,
            'lastLogin': self.lastLogin.isoformat() if self.lastLogin else None,
            'createdAt': self.createdAt.isoformat(),
            'updatedAt': self.updatedAt.isoformat() if self.updatedAt else None
        }