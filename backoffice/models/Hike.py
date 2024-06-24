from app import db

class Hike(db.Model):
    __tablename__ = 'hikes'
    __table_args__ = {'extend_existing': True, 'mysql_engine': 'InnoDB'}

    FID = db.Column(db.String(255), primary_key=True)
    osmId = db.Column('osm_id', db.BigInteger, nullable=False)
    name = db.Column(db.String(255), nullable=True)
