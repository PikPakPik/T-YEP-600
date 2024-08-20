from app import db
import datetime

class Hike(db.Model):
    __tablename__ = 'hikes'
    __table_args__ = {'extend_existing': True, 'mysql_engine': 'InnoDB'}

    id = db.Column(db.Integer, primary_key=True)
    osmId = db.Column('osm_id', db.BigInteger, nullable=False)
    name = db.Column(db.String(255), nullable=True)
    firstNodeLat = db.Column('first_node_lat', db.String(255), nullable=False)
    firstNodeLon = db.Column('first_node_lon', db.String(255), nullable=False)
    lastNodeLat = db.Column('last_node_lat', db.String(255), nullable=False)
    lastNodeLon = db.Column('last_node_lon', db.String(255), nullable=False)
    difficulty = db.Column(db.Integer, default=None)
    hikingTime = db.Column('hiking_time', db.Integer, default=None)
    distance = db.Column('distance', db.String(255), default=None)
    positiveAltitude = db.Column('positive_altitude', db.String(255), default=None)
    negativeAltitude = db.Column('negative_altitude', db.String(255), default=None)
    createdAt = db.Column('created_at', db.DateTime, nullable=False, default=datetime.datetime.now)
    updatedAt = db.Column('updated_at', db.DateTime, nullable=True, onupdate=datetime.datetime.now)
    users = db.relationship('User', secondary='user_hike', back_populates='hikes', lazy=True)
    files = db.relationship('Files', back_populates='hike', lazy=True)

    def serialize(self):
        return {
            'id': self.id,
            'osmId': self.osmId,
            'name': self.name,
            'firstNodeLat': self.firstNodeLat,
            'firstNodeLon': self.firstNodeLon,
            'lastNodeLat': self.lastNodeLat,
            'lastNodeLon': self.lastNodeLon,
            'difficulty': self.difficulty,
            'hikingTime': self.hikingTime,
            'distance': self.distance,
            'positiveAltitude': self.positiveAltitude,
            'negativeAltitude': self.negativeAltitude,
            'createdAt': self.createdAt.isoformat(),
            'updatedAt': self.updatedAt.isoformat() if self.updatedAt else None,
            'files': [file.serialize() for file in self.files],
            'likes': len(self.users)
        }
    
    def serializeFavorite(self):
        return {
            'id': self.id,
            'osmId': self.osmId,
            'name': self.name,
            'files': [file.serialize() for file in self.files],
        }