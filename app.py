import os

from app.config import IS_DEV
from app import create_app

app = create_app(is_dev=IS_DEV)

if __name__ == "__main__":
  if IS_DEV:
    print("🔴 [DESAROLLO] - MDW | API-GIS")
  else:
    print("🟢 MDW | API-GIS")

  host = os.getenv("APP_HOST", "127.0.0.2" if IS_DEV else "0.0.0.0")
  default_port = 5000 if IS_DEV else 9101
  port = int(os.getenv("APP_PORT", default_port))

  app.run(
    port=port,
    debug=True,
    host=host,
    use_reloader=True,
    threaded=True,
  )