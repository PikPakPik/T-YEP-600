from app import db
import datetime

class Files(db.Model):
    __tablename__ = 'files'
    __table_args__ = {'extend_existing': True, 'mysql_engine': 'InnoDB'}

    id = db.Column(db.Integer, primary_key=True)
    imgName = db.Column('img_name', db.String(255), nullable=False)
    hikeId = db.Column('hike_id', db.Integer, db.ForeignKey('hikes.id'), nullable=False)
    createdAt = db.Column('created_at', db.DateTime, nullable=False, default=datetime.datetime.now)
    hike = db.relationship('Hike', back_populates='files')

    def serialize(self):
        return {
            'id': self.id,
            'hikeId': self.hikeId,
            'imgName': self.imgName,
            'link': f'/smarthike/{self.hikeId}/{self.imgName}',
            'createdAt': self.createdAt.isoformat(),
        }