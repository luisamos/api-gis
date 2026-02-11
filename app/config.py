from dotenv import load_dotenv
import os
load_dotenv()

DB_USER= os.getenv('DB_USER')
DB_PASS= os.getenv('DB_PASS')
DB_HOST= os.getenv('DB_HOST')
DB_PORT= os.getenv('DB_PORT')
DB_NAME= os.getenv('DB_NAME')
APP_HOST = os.getenv('APP_HOST')
DEV_FRONTEND_ORIGIN = os.getenv('DEV_FRONTEND_ORIGIN')
IS_DEV = True
ID_UBIGEO = "080108"
ENV = "Development"
DEBUG = True

DB_URL= f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}?client_encoding=utf8"
