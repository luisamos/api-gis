from dotenv import load_dotenv
import os
load_dotenv()

def env_to_bool(value: str | None, default: bool = False) -> bool:
  if value is None:
    return default
  return value.strip().lower() in {"1", "true", "t", "yes", "y", "on"}

IS_DEV = env_to_bool(os.getenv('IS_DEV'), default=False)

DB_USER= os.getenv('DB_USER')
DB_PASS= os.getenv('DB_PASS')
DB_HOST= os.getenv('DB_HOST')
DB_PORT= os.getenv('DB_PORT')
DB_NAME= os.getenv('DB_NAME')

APP_HOST = os.getenv('APP_HOST')
DEV_FRONTEND_ORIGIN = os.getenv('DEV_FRONTEND_ORIGIN')

ID_UBIGEO = os.getenv('ID_UBIGEO')
DEBUG = env_to_bool(os.getenv('DEBUG'), default=False)
JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY')

COOKIE_SECURE = env_to_bool(os.getenv('COOKIE_SECURE'), default=not IS_DEV)
COOKIE_SAMESITE = os.getenv('COOKIE_SAMESITE', 'Lax')
COOKIE_PARTITIONED = env_to_bool(os.getenv('COOKIE_PARTITIONED'), default=False)

DB_URL= f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}?client_encoding=utf8"