import datetime
from app import db

class Session(db.Model):
    __tablename__ = 'sessions'
    __table_args__ = {'extend_existing': True, 'mysql_engine':'InnoDB'}

    id = db.Column(db.Integer, primary_key=True)
    user = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    token = db.Column(db.String, nullable=False)
    lastUsedAt = db.Column(db.DateTime, nullable=True)
    createdAt = db.Column(db.DateTime, nullable=False, default=datetime.datetime.now)
    updatedAt = db.Column(db.DateTime, nullable=True, onupdate=datetime.datetime.now)