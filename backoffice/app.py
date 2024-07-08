import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from flask_cors import CORS

app = Flask(__name__)

app.config.update(
    SECRET_KEY = os.environ.get('SECRET_KEY'),
    JWT_KEY = os.environ.get('JWT_KEY'),
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URI'),
    SQLALCHEMY_TRACK_MODIFICATIONS = False
)
db = SQLAlchemy()
login_manager = LoginManager()

from controllers import *
from commands import *
import services.authorization

db.init_app(app)
login_manager.init_app(app)
cors = CORS(app, resources={r"/*": {"origins": "*", "allow_headers": ["Content-Type", "Authorization"]}})