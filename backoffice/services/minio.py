import os
import io
from minio import Minio
import uuid

MINIO_ACCESS_KEY = os.environ.get('MINIO_ACCESS_KEY')
MINIO_SECRET_KEY = os.environ.get('MINIO_SECRET_KEY')

class MinioClient:
    def __init__(self):
        self.bucketName = 'smarthike'
        self.client = Minio(
            endpoint='minio:9000',
            access_key=MINIO_ACCESS_KEY,
            secret_key=MINIO_SECRET_KEY,
            secure=False
        )

    def checkIfHikeImageExist(self, hike_id, file_name):
        try:
            self.client.stat_object(
                self.bucketName,
                f'{hike_id}/{file_name}'
            )
            return True
        except Exception as e:
            print(f"Error getting file: {str(e)}")
            return False

    def uploadHikeImage(self, hike_id, file):
        extension = os.path.splitext(file.filename)[1]
        file_name = str(uuid.uuid4()) + extension
        file_content = file.read()
        try:
            self.client.put_object(
                self.bucketName,
                f'{hike_id}/{file_name}',
                io.BytesIO(file_content),
                len(file_content),
                file.content_type
            )
            return file_name
        except Exception as e:
            print(f"Error uploading file: {str(e)}")
            return None
        
    def removeHikeImage(self, hike_id, file_name):
        try:
            self.client.remove_object(
                self.bucketName,
                f'{hike_id}/{file_name}'
            )
            return True
        except Exception as e:
            print(f"Error removing file: {str(e)}")
            return False
