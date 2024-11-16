import os

class Config:
    SECRET_KEY = os.urandom(24)
    DEBUG = True  # Cambia a False en producción
    SQLALCHEMY_DATABASE_URI = 'postgresql://XeroClock_owner:5TfMW0owdsSV@ep-nameless-frost-a52b3mjg.us-east-2.aws.neon.tech/XeroClock?sslmode=require'  # Cambia esto con las credenciales correctas
    SQLALCHEMY_TRACK_MODIFICATIONS = False
