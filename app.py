from app.config import IS_DEV
from app import create_app

app = create_app(is_dev=IS_DEV)

if __name__ == "__main__":

  if IS_DEV:
    print("🔴 [DESAROLLO] - MDW | API-GIS")
  else : print("🟢 MDW | API-GIS")

  app.run(
    port=5000 if IS_DEV else 81,
    debug=True,
    host="127.0.0.2" if IS_DEV else "192.168.1.16",
    use_reloader=True,
    threaded=True
  )