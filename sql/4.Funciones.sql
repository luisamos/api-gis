SELECT DISTINCT
a.gid,
f.id_lote,
a.cod_sector || a.cod_mzna || a.cod_lote AS lotes_id,
--string_agg('"' || f.ciudadano_razon_social || '""', ', ') AS ciudadano_razon_social,
a.cod_sector,
a.cod_mzna,
a.cod_lote,
round(a.area_grafi :: decimal,2) AS area_grafi,
round(a.peri_grafi :: decimal,2) AS peri_grafi,
geom
FROM geo.tg_lote a
LEFT JOIN (
	SELECT DISTINCT
	b.id_lote,
	b.id_ficha	
	FROM catastro.tf_fichas b		
	WHERE b.tipo_ficha = '01'
	GROUP BY b.id_lote,
	b.id_ficha	
	ORDER BY 1,2
	) f
ON a.id_lote = f.id_lote
ORDER BY 4;

SELECT * FROM geo.tg_lote;

/*
SELECT * FROM geo.tg_lote;

SELECT DISTINCT c.id_ficha, string_agg(d.ape_paterno || ' ' || d.ape_materno || ' ' || d.nombres, ', ') AS ciudadano_razon_social
	FROM catastro.tf_titulares c
	JOIN catastro.tf_personas d ON c.id_persona = d.id_persona
	WHERE c.id_ficha = '2024080108020000043'
	GROUP BY 1
	ORDER BY 1;

SELECT * FROM catastro.tf_titulares;
*/