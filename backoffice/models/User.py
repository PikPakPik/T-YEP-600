import datetime
from app import db

class User(db.Model):
    __tablename__ = 'users'
    __table_args__ = {'extend_existing': True, 'mysql_engine':'InnoDB'}

    id = db.Column(db.Integer, primary_key=True)
    firstname = db.Column(db.String(255), nullable=False)
    lastname = db.Column(db.String(255), nullable=False)
    email = db.Column(db.String(255), nullable=False, unique=True)
    password = db.Column(db.String(255), nullable=False)
    lastLogin = db.Column('last_login', db.DateTime, nullable=True, onupdate=datetime.datetime.now)
    createdAt = db.Column('created_at', db.DateTime, nullable=False, default=datetime.datetime.now)
    updatedAt = db.Column('updated_at', db.DateTime, nullable=True, onupdate=datetime.datetime.now)