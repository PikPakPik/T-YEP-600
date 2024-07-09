from app import db
import datetime

class Hike(db.Model):
    __tablename__ = 'hikes'
    __table_args__ = {'extend_existing': True, 'mysql_engine': 'InnoDB'}

    id = db.Column(db.Integer, primary_key=True)
    osmId = db.Column('osm_id', db.BigInteger, nullable=False)
    name = db.Column(db.String(255), nullable=True)
    difficulty = db.Column(db.Integer, default=None)
    hikingTime = db.Column('hinking_time', db.Integer, default=None)
    imgName = db.Column('image', db.String(255), default=None)
    createdAt = db.Column('created_at', db.DateTime, nullable=False, default=datetime.datetime.now)
    updatedAt = db.Column('updated_at', db.DateTime, nullable=True, onupdate=datetime.datetime.now)
    users = db.relationship('User', secondary='user_hike', back_populates='hikes', lazy=True)

    def serialize(self):
        return {
            'id': self.id,
            'osmId': self.osmId,
            'name': self.name,
            'difficulty': self.difficulty,
            'hikingTime': self.hikingTime,
            'imgName': self.imgName,
            'createdAt': self.createdAt.isoformat(),
            'updatedAt': self.updatedAt.isoformat() if self.updatedAt else None
        }
    
    def serializeFavorite(self):
        return {
            'id': self.id,
            'osmId': self.osmId,
            'name': self.name
        }