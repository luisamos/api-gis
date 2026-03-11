-- Fecha de creación: 13/09/2023
-- Fecha de actualización: 14/03/2024

--
-- 0. Obtener coordenadas por Lote
--
CREATE OR REPLACE FUNCTION geo.obtener_coordenada_lote(pId_lote character varying)
RETURNS TABLE(id_lote character varying, x decimal, y decimal, geom geometry) AS
$BODY$
BEGIN
    RETURN QUERY
    SELECT a.id_lote,
	ROUND(ST_X((ST_DumpPoints(a.geom)).geom):: decimal, 2) AS x,
    ROUND(ST_Y((ST_DumpPoints(a.geom)).geom):: decimal, 2) AS y,
	ST_SetSRID(ST_MakePoint(ST_X((ST_DumpPoints(a.geom)).geom), ST_Y((ST_DumpPoints(a.geom)).geom)), 32718) as geom
FROM geo.tg_lote a
WHERE a.id_lote = pId_lote
LIMIT (SELECT ST_NPoints(b.geom) - 1 FROM geo.tg_lote b WHERE b.id_lote = pId_lote);
END;
$BODY$ LANGUAGE plpgsql;

/*
SELECT ROW_NUMBER() OVER (ORDER BY id_lote) AS gid, x, y, geom FROM public.obtenerCoordenadasLote('08010807');

SELECT id_lote,
	ST_X((ST_DumpPoints(geom)).geom) AS x,
    ST_Y((ST_DumpPoints(geom)).geom) AS y,
	ST_SetSRID(ST_MakePoint(ST_X((ST_DumpPoints(geom)).geom), ST_Y((ST_DumpPoints(geom)).geom)), 4326) as geom
FROM geo.tg_lote
WHERE id_lote = '08130101002004';

SELECT round(st_xmin(st_extent(geom)) :: decimal,0) || ',' ||
	round(st_ymin(st_extent(geom)):: decimal,0)  || ',' ||
	round(st_xmax(st_extent(geom)):: decimal,0) || ',' ||
	round(st_ymax(st_extent(geom)):: decimal,0) AS extent FROM geo.tg_lote
	WHERE id_lote= '08130101020023';


SELECT st_xmin(st_extent(geom)) || ',' ||
	st_ymin(st_extent(geom)) || ',' ||
	st_xmax(st_extent(geom)) || ',' ||
	st_ymax(st_extent(geom)) AS extent FROM geo.tg_lote
	WHERE id_lote= '08130101020023';

SELECT
    ST_XMin(extent) AS min_x,
    ST_YMin(extent) AS min_y,
    ST_XMax(extent) AS max_x,
    ST_YMax(extent) AS max_y
FROM (
    SELECT ST_Expand(ST_Extent(geom), 5) AS extent
    FROM geo.tg_lote
	WHERE id_lote= '08130101002004'
) AS subconsulta;

SELECT * FROM geo.tg_lote;
*/

--
-- 01. Cuenta con y/o sin ficha catastral
--
DROP VIEW IF EXISTS geo.v_reporte_lote;
CREATE VIEW geo.v_reporte_lote AS
SELECT
row_number() OVER(order by a.cod_sector) AS gid,
a.cod_sector,
SUM(d.con_ficha) AS con_ficha,
SUM(e.sin_ficha) AS sin_ficha,
st_geomfromtext('POINT (0 0)',4326) AS geom
FROM geo.tg_lote a
LEFT JOIN (SELECT b.id_lote, b.cod_sector, 1 AS con_ficha
			FROM geo.tg_lote b
			LEFT JOIN catastro.tf_fichas c
			ON b.id_lote = c.id_lote
		    WHERE c.id_lote IS NOT NULL
			GROUP BY 1,2
			ORDER BY 1) d ON a.id_lote = d.id_lote
LEFT JOIN (SELECT b.id_lote, b.cod_sector, 1 AS sin_ficha
			FROM geo.tg_lote b
			LEFT JOIN catastro.tf_fichas c
			ON b.id_lote = c.id_lote
		    WHERE c.id_lote IS NULL
			GROUP BY 1,2
			ORDER BY 1) e ON a.id_lote = e.id_lote
GROUP BY 2
ORDER BY 1;

SELECT gid, cod_sector, CASE WHEN con_ficha IS NULL THEN 0 ELSE con_ficha END AS con_ficha, CASE WHEN sin_ficha IS NULL THEN 0 ELSE sin_ficha END AS sin_ficha, geom FROM geo.v_reporte_lote;

--
-- 2. Servicios básicos
--
DROP VIEW IF EXISTS geo.v_reporte_servicio_basico;
CREATE VIEW geo.v_reporte_servicio_basico AS
WITH servicio_por_lote AS (
    SELECT
        f.id_lote,
        bool_or(sb.agua = 1) AS agua_con,
        bool_or(sb.agua = 2) AS agua_sin,
        bool_or(sb.luz = 1) AS luz_con,
        bool_or(sb.luz = 2) AS luz_sin,
        bool_or(sb.desague = 1) AS desague_con,
        bool_or(sb.desague = 2) AS desague_sin,
        bool_or(sb.telefono = 1) AS telefono_con,
        bool_or(sb.telefono = 2) AS telefono_sin,
        bool_or(sb.gas = 1) AS gas_con,
        bool_or(sb.gas = 2) AS gas_sin,
        bool_or(sb.internet = 1) AS internet_con,
        bool_or(sb.internet = 2) AS internet_sin,
        bool_or(sb.tvcable = 1) AS tvcable_con,
        bool_or(sb.tvcable = 2) AS tvcable_sin
    FROM catastro.tf_fichas f
    LEFT JOIN catastro.tf_servicios_basicos sb
        ON sb.id_ficha = f.id_ficha
    GROUP BY f.id_lote
)
SELECT
    row_number() OVER (ORDER BY s.cod_sector) AS gid,
    s.cod_sector,
    COUNT(DISTINCT l.id_lote) AS total_predios,
    COUNT(DISTINCT CASE WHEN spl.agua_con THEN l.id_lote END) AS predios_con_agua,
    COUNT(DISTINCT CASE WHEN COALESCE(spl.agua_con, FALSE) = FALSE THEN l.id_lote END) AS predios_sin_agua,
    COUNT(DISTINCT CASE WHEN spl.luz_con THEN l.id_lote END) AS predios_con_luz,
    COUNT(DISTINCT CASE WHEN COALESCE(spl.luz_con, FALSE) = FALSE THEN l.id_lote END) AS predios_sin_luz,
    COUNT(DISTINCT CASE WHEN spl.desague_con THEN l.id_lote END) AS predios_con_desague,
    COUNT(DISTINCT CASE WHEN COALESCE(spl.desague_con, FALSE) = FALSE THEN l.id_lote END) AS predios_sin_desague,
    COUNT(DISTINCT CASE WHEN spl.telefono_con THEN l.id_lote END) AS predios_con_telefono,
    COUNT(DISTINCT CASE WHEN COALESCE(spl.telefono_con, FALSE) = FALSE THEN l.id_lote END) AS predios_sin_telefono,
    COUNT(DISTINCT CASE WHEN spl.gas_con THEN l.id_lote END) AS predios_con_gas,
    COUNT(DISTINCT CASE WHEN COALESCE(spl.gas_con, FALSE) = FALSE THEN l.id_lote END) AS predios_sin_gas,
    COUNT(DISTINCT CASE WHEN spl.internet_con THEN l.id_lote END) AS predios_con_internet,
    COUNT(DISTINCT CASE WHEN COALESCE(spl.internet_con, FALSE) = FALSE THEN l.id_lote END) AS predios_sin_internet,
    COUNT(DISTINCT CASE WHEN spl.tvcable_con THEN l.id_lote END) AS predios_con_tvcable,
    COUNT(DISTINCT CASE WHEN COALESCE(spl.tvcable_con, FALSE) = FALSE THEN l.id_lote END) AS predios_sin_tvcable,
    ST_GeomFromText('POINT (0 0)', 4326) AS geom
FROM (
    SELECT DISTINCT cod_sector
    FROM geo.tg_lote
    WHERE cod_sector IS NOT NULL
) s
LEFT JOIN geo.tg_lote l
    ON l.cod_sector = s.cod_sector
LEFT JOIN servicio_por_lote spl
    ON spl.id_lote = l.id_lote
GROUP BY s.cod_sector
ORDER BY s.cod_sector;

SELECT * FROM geo.v_reporte_servicio_basico;