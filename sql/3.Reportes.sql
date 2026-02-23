-- Fecha de creación: 13/09/2023
-- Fecha de actualización: 14/03/2024

-- 01. Cuenta con y/o sin ficha catastral
DROP VIEW IF EXISTS geo.v_lotes_con_sin_ficha;
CREATE VIEW geo.v_lotes_con_sin_ficha AS
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

SELECT gid, cod_sector, CASE WHEN con_ficha IS NULL THEN 0 ELSE con_ficha END AS con_ficha, CASE WHEN sin_ficha IS NULL THEN 0 ELSE sin_ficha END AS sin_ficha, geom FROM geo.v_lotes_con_sin_ficha;

--
-- 2. Obtener coordenadas por Lote
--
CREATE OR REPLACE FUNCTION geo.obtenerCoordenadasLote(pId_lote character varying)
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

