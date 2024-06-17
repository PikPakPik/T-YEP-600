import datetime
from app import db

class Session(db.Model):
    __tablename__ = 'sessions'
    __table_args__ = {'extend_existing': True, 'mysql_engine':'InnoDB'}

    id = db.Column(db.Integer, primary_key=True)
    user = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    token = db.Column(db.Text, nullable=False)
    lastUsedAt = db.Column('last_used_at', db.DateTime, nullable=True)
    createdAt = db.Column('created_at', db.DateTime, nullable=False, default=datetime.datetime.now)
    updatedAt = db.Column('updated_at', db.DateTime, nullable=True, onupdate=datetime.datetime.now)