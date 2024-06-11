import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

app.config.update(
    SECRET_KEY = os.environ.get('SECRET_KEY'),
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URI'),
    SQLALCHEMY_TRACK_MODIFICATIONS = False
)
db = SQLAlchemy()

from controllers import *
from models import *

db.init_app(app)

with app.app_context():
    db.create_all()