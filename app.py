import config
from flask import Flask, request, jsonify
from datetime import datetime
import os, shutil, zipfile
from geoalchemy2 import Geometry
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from osgeo import ogr

is_dev = True
app = Flask(__name__)
if is_dev:
    print('\n🟢\t[DESAROLLO] - MDW | API-GIS\n')
    CORS(app, resources={r"/*": {"origins": "http://127.0.0.2:81"}}) # En desarrollo.
else:
    #CORS(app, supports_credentials=True, resources={r"/*": {"origins": ["http://209.45.78.210"]}}) # En producción.
    CORS(app)

BASE_DIR = os.path.abspath(os.path.dirname(__file__))
TMP_DIR = os.path.join(BASE_DIR, 'tmp')
UPLOADS_DIR = os.path.join(BASE_DIR, 'uploads')

os.makedirs(TMP_DIR, exist_ok=True)
os.makedirs(UPLOADS_DIR, exist_ok=True)

app.config["SQLALCHEMY_DATABASE_URI"] = config.DB_URL
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
db = SQLAlchemy(app)

ogr.UseExceptions()

class Lotes(db.Model):
    __tablename__ = 'tg_lote'
    __table_args__ = {'schema': 'geo'}
    gid = db.Column(db.Integer, primary_key=True)
    cod_sector = db.Column(db.String)
    id_ubigeo = db.Column(db.String)
    id_sector = db.Column(db.String)
    cod_mzna = db.Column(db.String)
    id_mzna = db.Column(db.String)
    cod_lote = db.Column(db.String)
    id_lote = db.Column(db.String)
    geom = db.Column(Geometry(geometry_type='POLYGON', srid=32719))


@app.route('/subir_shapefile', methods=['POST'])
def subir_shapefile():
    file = request.files.get('file')
    if not file or not file.filename.endswith('.zip'):
        return jsonify({"estado": False, "mensaje": "Archivo inválido"}), 400

    for f in os.listdir(TMP_DIR):
        path = os.path.join(TMP_DIR, f)
        os.remove(path) if os.path.isfile(path) else shutil.rmtree(path)

    zip_path = os.path.join(TMP_DIR, file.filename)
    file.save(zip_path)

    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        zip_ref.extractall(TMP_DIR)

    timestamp = datetime.now().strftime(f"%d%m%Y%H%M%S")
    final_path = os.path.join(UPLOADS_DIR, timestamp)

    if os.path.exists(final_path):
        shutil.rmtree(final_path)
    shutil.copytree(TMP_DIR, final_path)

    return jsonify({
        "estado": True,
        "mensaje": "Descomprimido correctamente",
        "nombreCarpeta": timestamp
    }), 200

@app.route('/insertar_datos', methods=['POST'])
def insertar_datos():
    try:
        # Obtener parámetros del request
        carpeta = request.json.get('nombreCarpeta')
        codigoSector = request.json.get('codigoSector')
        codigoManzana = request.json.get('codigoManzana')
        codigoLote = request.json.get('codigoLote')

        # Validar parámetros
        if not all([carpeta, codigoSector, codigoManzana, codigoLote]):
            return jsonify({
                "estado": False,
                "mensaje": "Faltan parámetros requeridos en la solicitud"
            }), 400

        # Construir ruta y buscar archivo SHP
        carpeta_path = os.path.join(UPLOADS_DIR, carpeta)
        shp_file = next((f for f in os.listdir(carpeta_path) if f.endswith(".shp")), None)

        if not shp_file:
            return jsonify({
                "estado": False,
                "mensaje": f"No se encontró archivo .shp en la carpeta: {carpeta}"
            }), 404

        # Abrir el datasource y mantener la referencia
        shp_path = os.path.join(carpeta_path, shp_file)
        datasource = ogr.Open(shp_path)

        if datasource is None:
            return jsonify({
                "estado": False,
                "mensaje": f"No se pudo abrir el archivo Shapefile: {shp_path}"
            }), 500

        # Obtener la capa
        layer = datasource.GetLayer()
        if layer is None:
            datasource = None  # Liberar recursos
            return jsonify({
                "estado": False,
                "mensaje": "El archivo Shapefile no contiene capas válidas"
            }), 500

        insertados = 0
        try:
            with db.session.begin():
                feature = layer.GetNextFeature()

                while feature is not None:
                    geometry = feature.GetGeometryRef()
                    if geometry.GetGeometryName() == 'POLYGON':
                        geometry.FlattenTo2D()
                    wkt_geom = geometry.ExportToWkt()
                    try:
                        sector = feature.GetField(codigoSector) or ""
                        mzna = feature.GetField(codigoManzana) or ""
                        lote = feature.GetField(codigoLote) or ""

                        nuevo = Lotes(
                            cod_sector=sector,
                            id_ubigeo='080108',
                            id_sector=f'080108{sector}',
                            cod_mzna=mzna,
                            id_mzna=f'080108{sector}{mzna}',
                            cod_lote=lote,
                            id_lote=f'080108{sector}{mzna}{lote}',
                            geom=wkt_geom
                        )

                        db.session.add(nuevo)
                        insertados += 1
                    finally:
                        feature = None

                    feature = layer.GetNextFeature()

            return jsonify({
                "estado": True,
                "mensaje": f"Datos migrados exitosamente. Registros insertados: {insertados}",
                "registrosInsertados": insertados
            }), 200

        except Exception as e:
            db.session.rollback()
            return jsonify({
                "estado": False,
                "mensaje": f"Error al procesar los datos: {str(e)}"
            }), 500

        finally:
            layer = None
            datasource = None

    except Exception as e:
        return jsonify({
            "estado": False,
            "mensaje": f"Error inesperado: {str(e)}"
        }), 500

if __name__ == "__main__":
    app.run(
        port=5000,
        debug=True,
        host='127.0.0.2' if is_dev else '209.45.78.210',
        use_reloader=True,
        threaded=True
    )