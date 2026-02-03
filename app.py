import os

from app.config import IS_DEV, DEBUG
from app import create_app

app = create_app()

if __name__ == "__main__":
  if IS_DEV:
    print("🔴 [DESAROLLO] - MDW | API-GIS")
    HOST = "127.0.0.2"

  else:
    print("🟢 MDW | API-GIS")
    HOST = "0.0.0.0"

  app.run(
    port=5000,
    debug=DEBUG,
    host=HOST,
    use_reloader=True,
    threaded=True,
  )