import os

from app.config import IS_DEV, DEBUG, APP_HOST
from app import create_app

app = create_app()

if __name__ == "__main__":
  if IS_DEV:
    print("[DESAROLLO] - GEO - KAYPACHA | ALLPA | API-GIS")

  else:
    print("GEO- KAYPACHA | ALLPA | API-GIS")

  app.run(
    port=5000,
    debug=DEBUG,
    host=APP_HOST,
    use_reloader=True,
    threaded=True,
  )