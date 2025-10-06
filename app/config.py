from dotenv import load_dotenv
import os
load_dotenv()

DB_USER= os.getenv('DB_USER')
DB_PASS= os.getenv('DB_PASS')
DB_HOST= os.getenv('DB_HOST')
DB_PORT= os.getenv('DB_PORT')
DB_NAME= os.getenv('DB_NAME')
IS_DEV = True

DB_URL= f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}?client_encoding=utf8"