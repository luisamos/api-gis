--
-- FECHA DE CREACIÓN 	 : 22/10/2024
-- FECHA DE MODIFICACIÓN : 31/10/2025
--

-- 01. Cuenta con y/o sin ficha catastral
--DROP VIEW IF EXISTS geo.v_lotes;
CREATE OR REPLACE VIEW geo.v_lotes AS
SELECT DISTINCT
a.gid,
b.id_ficha,
c.imagen_plano AS fotografia,
b.id_lote,
a.cod_sector,
a.cod_mzna,
a.cod_sector || a.cod_mzna || a.cod_lote AS lotes_id,
a.cod_lote,
b.
CASE
	WHEN b.id_lote IS NULL AND c.imagen_plano IS NULL THEN 0
	WHEN b.id_lote IS NULL AND c.imagen_plano IS NOT NULL THEN 1
	WHEN b.id_lote IS NOT NULL AND c.imagen_plano IS NULL THEN 2
	ELSE 3
END AS existe,
CASE
	WHEN b.id_lote IS NULL THEN 2
	ELSE 1
END AS existe_ficha,
CASE
	WHEN e.tipo_doc = '0'  THEN 'RUC'
	WHEN e.tipo_doc = '2'  THEN 'DNI'
END AS tipo_doc,
e.nume_doc,
CASE
	WHEN e.tipo_persona = '1' THEN 'PERSONA NATURAL'
	WHEN e.tipo_persona = '2' THEN 'PERSONA JURIDICA'
END AS tipo_persona,
CASE
	WHEN e.tipo_persona = '1' THEN e.ape_paterno || ' ' || e.ape_materno || ' ' || e.nombres
	WHEN e.tipo_persona = '2' THEN e.razon_social
END AS ciudadano_razon_social,
round(a.area_grafi :: decimal,2) AS area_grafi,
round(a.peri_grafi :: decimal,2) AS peri_grafi,
geom
FROM geo.tg_lote a
LEFT JOIN catastro.tf_fichas b ON a.id_lote = b.id_lote
LEFT JOIN catastro.tf_fichas_individuales c ON b.id_ficha = c.id_ficha
LEFT JOIN catastro.tf_titulares d ON b.id_ficha = d.id_ficha
LEFT JOIN catastro.tf_personas e ON d.id_persona = e.id_persona
--WHERE (d.ape_paterno || ' ' || d.ape_materno || ' ' || d.nombres) != 'NNN NNN NNN'
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
ORDER BY existe_ficha;

SELECT * FROM catastro.tf_fichas;

--SELECT * FROM geo.v_lotes WHERE fotografia IS NOT NULL;
--SELECT * FROM geo.v_lotes LIMIT 1;

--SELECT count(*) FROM geo.tg_lote;

--SELECT * FROM catastro.v_lotes LIMIT 2;

--SELECT * FROM catastro.v_lotes WHERE nume_doc='00004431';

--SELECT * FROM catastro.personas WHERE nume_doc='23823831'

-- 02. Servicios básicos
--DROP VIEW IF EXISTS geo.v_servicios_basicos;
CREATE OR REPLACE VIEW geo.v_servicios_basicos AS
SELECT
a.gid,
b.id_lote,
CASE
	WHEN d.tipo_doc = '0'  THEN 'RUC'
	WHEN d.tipo_doc = '2'  THEN 'DNI'
END AS tipo_doc,
d.nume_doc,
CASE
	WHEN d.tipo_persona = '1' THEN 'PERSONA NATURAL'
	WHEN d.tipo_persona = '2' THEN 'PERSONA JURIDICA'
END AS tipo_persona,
CASE
	WHEN d.tipo_persona = '1' THEN d.ape_paterno || ' ' || d.ape_materno || ' ' || d.nombres
	WHEN d.tipo_persona = '2' THEN d.razon_social
END AS ciudadano_razon_social,
e.luz AS codi_luz,
e.agua AS codi_agua,
e.telefono AS codi_telefono,
e.desague AS codi_desague,
e.gas AS codi_gas,
e.internet AS codi_internet,
e.tvcable AS codi_tvcable,
CASE
	WHEN e.luz = '1' THEN 'SI'
	WHEN e.luz = '2' THEN 'NO'
END AS luz,
CASE
	WHEN e.agua = '1' THEN 'SI'
	WHEN e.agua = '2' THEN 'NO'
END AS agua,
CASE
	WHEN e.telefono = '1' THEN 'SI'
	WHEN e.telefono = '2' THEN 'NO'
END AS telefono,
CASE
	WHEN e.desague = '1' THEN 'SI'
	WHEN e.desague = '2' THEN 'NO'
END AS desague,
CASE
	WHEN e.gas = '1' THEN 'SI'
	WHEN e.gas = '2' THEN 'NO'
END AS gas,
CASE
	WHEN e.internet = '1' THEN 'SI'
	WHEN e.internet = '2' THEN 'NO'
END AS internet,
CASE
	WHEN e.tvcable = '1' THEN 'SI'
	WHEN e.tvcable = '2' THEN 'NO'
END AS tvcable,
a.geom
FROM geo.tg_lote a
JOIN catastro.tf_fichas b ON a.id_lote = b.id_lote
JOIN catastro.tf_titulares c ON b.id_ficha = c.id_ficha
JOIN catastro.tf_personas d ON c.id_persona = d.id_persona
JOIN catastro.tf_servicios_basicos e ON b.id_ficha = e.id_ficha
GROUP BY a.gid, b.id_lote, d.tipo_doc, d.nume_doc, d.tipo_persona, d.ape_paterno,  d.ape_materno, d.nombres, d.razon_social, e.luz, e.agua, e.telefono, e.desague, e.gas, e.internet, e.tvcable, a.geom
ORDER BY a.gid;

-- 03. Clasificación del Predio
--DROP VIEW IF EXISTS geo.v_clasificacion_predios;
CREATE OR REPLACE VIEW geo.v_clasificacion_predios AS
SELECT
a.gid,
b.id_lote,
CASE
	WHEN d.tipo_doc = '0'  THEN 'RUC'
	WHEN d.tipo_doc = '2'  THEN 'DNI'
END AS tipo_doc,
d.nume_doc,
CASE
	WHEN d.tipo_persona = '1' THEN 'PERSONA NATURAL'
	WHEN d.tipo_persona = '2' THEN 'PERSONA JURIDICA'
END AS tipo_persona,
CASE
	WHEN d.tipo_persona = '1' THEN d.ape_paterno || ' ' || d.ape_materno || ' ' || d.nombres
	WHEN d.tipo_persona = '2' THEN d.razon_social
END AS ciudadano_razon_social,
substring(e.clasificacion,1,2) AS codi_clasi,
CASE
	WHEN substring(e.clasificacion,1,2) = '01' THEN 'CASA HABITACITACIÓN'
	WHEN substring(e.clasificacion,1,2) = '02' THEN 'TIENDA - DEPÓSITO - ALMACEN'
	WHEN substring(e.clasificacion,1,2) = '03' THEN 'PREDIO EN EDIFICIO'
	WHEN substring(e.clasificacion,1,2) = '04' THEN 'OTROS'
	WHEN substring(e.clasificacion,1,2) = '05' THEN 'TERRENO SIN CONSTRUIR'
END AS clasificacion,
e.area_titulo, e.area_verificada, e.nume_habitantes, e.observaciones,
a.geom
FROM geo.tg_lote a
JOIN catastro.tf_fichas b ON a.id_lote = b.id_lote
JOIN catastro.tf_titulares c ON b.id_ficha = c.id_ficha
JOIN catastro.tf_personas d ON c.id_persona = d.id_persona
JOIN catastro.tf_fichas_individuales e ON b.id_ficha = e.id_ficha
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13
ORDER BY a.gid;

--SELECT * FROM geo.v_clasificacion_predios;

-- 04. Personas Natural / Persona Jurídica
--DROP VIEW IF EXISTS geo.v_tipos_personas;
CREATE OR REPLACE VIEW geo.v_tipos_personas AS
SELECT
a.gid,
b.id_lote,
CASE
	WHEN d.tipo_doc = '0'  THEN 'RUC'
	WHEN d.tipo_doc = '2'  THEN 'DNI'
END AS tipo_doc,
d.nume_doc,
CASE
	WHEN d.tipo_persona IS NULL THEN '0'
	ELSE d.tipo_persona
END AS tipo_persona,
CASE
	WHEN d.tipo_persona = '1' THEN 'PERSONA NATURAL'
	WHEN d.tipo_persona = '2' THEN 'PERSONA JURIDICA'
END AS persona,
CASE
	WHEN d.tipo_persona = '1' THEN d.ape_paterno || ' ' || d.ape_materno || ' ' || d.nombres
	WHEN d.tipo_persona = '2' THEN d.razon_social
END AS ciudadano_razon_social,
a.geom
FROM geo.tg_lote a
JOIN catastro.tf_fichas b ON a.id_lote = b.id_lote
JOIN catastro.tf_titulares c ON b.id_ficha = c.id_ficha
JOIN catastro.tf_personas d ON c.id_persona = d.id_persona
GROUP BY 1,2,3,4,5,6,7,8
ORDER BY a.gid;

-- 05. Tipo de uso
--DROP VIEW IF EXISTS geo.v_tipos_usos;
CREATE OR REPLACE VIEW geo.v_tipos_usos AS
SELECT
a.gid,
b.id_lote,
CASE
	WHEN d.tipo_doc = '0'  THEN 'RUC'
	WHEN d.tipo_doc = '2'  THEN 'DNI'
END AS tipo_doc,
d.nume_doc,
CASE
	WHEN d.tipo_persona IS NULL THEN '0'
	ELSE d.tipo_persona
END AS tipo_persona,
CASE
	WHEN d.tipo_persona = '1' THEN 'PERSONA NATURAL'
	WHEN d.tipo_persona = '2' THEN 'PERSONA JURIDICA'
END AS persona,
CASE
	WHEN d.tipo_persona = '1' THEN d.ape_paterno || ' ' || d.ape_materno || ' ' || d.nombres
	WHEN d.tipo_persona = '2' THEN d.razon_social
END AS ciudadano_razon_social,
f.codi_uso,
a.geom
FROM geo.tg_lote a
JOIN catastro.tf_fichas b ON a.id_lote = b.id_lote
JOIN catastro.tf_titulares c ON b.id_ficha = c.id_ficha
JOIN catastro.tf_personas d ON c.id_persona = d.id_persona
JOIN catastro.tf_fichas_individuales e ON e.id_ficha = b.id_ficha
JOIN catastro.tf_usos f ON f.codi_uso = e.codi_uso
WHERE b.tipo_ficha='01'
GROUP BY 1,2,3,4,5,6,7,8,9
ORDER BY a.gid;

-- 06. Material de construcción
--DROP VIEW IF EXISTS geo.v_material_construccion;
CREATE OR REPLACE VIEW geo.v_material_construccion AS
SELECT
a.gid,
b.id_lote,
CASE
	WHEN d.tipo_doc = '0'  THEN 'RUC'
	WHEN d.tipo_doc = '2'  THEN 'DNI'
END AS tipo_doc,
d.nume_doc,
CASE
	WHEN d.tipo_persona IS NULL THEN '0'
	ELSE d.tipo_persona
END AS tipo_persona,
CASE
	WHEN d.tipo_persona = '1' THEN 'PERSONA NATURAL'
	WHEN d.tipo_persona = '2' THEN 'PERSONA JURIDICA'
END AS persona,
CASE
	WHEN d.tipo_persona = '1' THEN d.ape_paterno || ' ' || d.ape_materno || ' ' || d.nombres
	WHEN d.tipo_persona = '2' THEN d.razon_social
END AS ciudadano_razon_social,
f.mep,
a.geom
FROM geo.tg_lote a
JOIN catastro.tf_fichas b ON a.id_lote = b.id_lote
JOIN catastro.tf_titulares c ON b.id_ficha = c.id_ficha
JOIN catastro.tf_personas d ON c.id_persona = d.id_persona
JOIN catastro.tf_fichas_individuales e ON e.id_ficha = b.id_ficha
JOIN catastro.tf_construcciones f ON f.id_ficha = e.id_ficha
WHERE b.tipo_ficha='01'
GROUP BY 1,2,3,4,5,6,7,8,9
ORDER BY a.gid;

-- 07. Estado de conservación
--DROP VIEW IF EXISTS geo.v_estado_conservacion;
CREATE OR REPLACE VIEW geo.v_estado_conservacion AS
SELECT
a.gid,
b.id_lote,
CASE
	WHEN d.tipo_doc = '0'  THEN 'RUC'
	WHEN d.tipo_doc = '2'  THEN 'DNI'
END AS tipo_doc,
d.nume_doc,
CASE
	WHEN d.tipo_persona IS NULL THEN '0'
	ELSE d.tipo_persona
END AS tipo_persona,
CASE
	WHEN d.tipo_persona = '1' THEN 'PERSONA NATURAL'
	WHEN d.tipo_persona = '2' THEN 'PERSONA JURIDICA'
END AS persona,
CASE
	WHEN d.tipo_persona = '1' THEN d.ape_paterno || ' ' || d.ape_materno || ' ' || d.nombres
	WHEN d.tipo_persona = '2' THEN d.razon_social
END AS ciudadano_razon_social,
f.ecs,
a.geom
FROM geo.tg_lote a
JOIN catastro.tf_fichas b ON a.id_lote = b.id_lote
JOIN catastro.tf_titulares c ON b.id_ficha = c.id_ficha
JOIN catastro.tf_personas d ON c.id_persona = d.id_persona
JOIN catastro.tf_fichas_individuales e ON e.id_ficha = b.id_ficha
JOIN catastro.tf_construcciones f ON f.id_ficha = e.id_ficha
WHERE b.tipo_ficha='01'
GROUP BY 1,2,3,4,5,6,7,8,9
ORDER BY a.gid;

-- 08. Estado de la construcción
--DROP VIEW IF EXISTS geo.v_estado_construccion;
CREATE OR REPLACE VIEW geo.v_estado_construccion AS
SELECT
a.gid,
b.id_lote,
CASE
	WHEN d.tipo_doc = '0'  THEN 'RUC'
	WHEN d.tipo_doc = '2'  THEN 'DNI'
END AS tipo_doc,
d.nume_doc,
CASE
	WHEN d.tipo_persona IS NULL THEN '0'
	ELSE d.tipo_persona
END AS tipo_persona,
CASE
	WHEN d.tipo_persona = '1' THEN 'PERSONA NATURAL'
	WHEN d.tipo_persona = '2' THEN 'PERSONA JURIDICA'
END AS persona,
CASE
	WHEN d.tipo_persona = '1' THEN d.ape_paterno || ' ' || d.ape_materno || ' ' || d.nombres
	WHEN d.tipo_persona = '2' THEN d.razon_social
END AS ciudadano_razon_social,
f.ecc,
a.geom
FROM geo.tg_lote a
JOIN catastro.tf_fichas b ON a.id_lote = b.id_lote
JOIN catastro.tf_titulares c ON b.id_ficha = c.id_ficha
JOIN catastro.tf_personas d ON c.id_persona = d.id_persona
JOIN catastro.tf_fichas_individuales e ON e.id_ficha = b.id_ficha
JOIN catastro.tf_construcciones f ON f.id_ficha = e.id_ficha
WHERE b.tipo_ficha='01'
GROUP BY 1,2,3,4,5,6,7,8,9
ORDER BY a.gid;

-- 09. Niveles de construcción
--DROP VIEW IF EXISTS geo.v_niveles_construccion;
CREATE OR REPLACE VIEW geo.v_niveles_construccion AS
SELECT
a.gid,
b.id_lote,
CASE
	WHEN d.tipo_doc = '0'  THEN 'RUC'
	WHEN d.tipo_doc = '2'  THEN 'DNI'
END AS tipo_doc,
d.nume_doc,
CASE
	WHEN d.tipo_persona IS NULL THEN '0'
	ELSE d.tipo_persona
END AS tipo_persona,
CASE
	WHEN d.tipo_persona = '1' THEN 'PERSONA NATURAL'
	WHEN d.tipo_persona = '2' THEN 'PERSONA JURIDICA'
END AS persona,
CASE
	WHEN d.tipo_persona = '1' THEN d.ape_paterno || ' ' || d.ape_materno || ' ' || d.nombres
	WHEN d.tipo_persona = '2' THEN d.razon_social
END AS ciudadano_razon_social,
f.nume_piso,
a.geom
FROM geo.tg_lote a
JOIN catastro.tf_fichas b ON a.id_lote = b.id_lote
JOIN catastro.tf_titulares c ON b.id_ficha = c.id_ficha
JOIN catastro.tf_personas d ON c.id_persona = d.id_persona
JOIN catastro.tf_fichas_individuales e ON b.id_ficha = e.id_ficha
JOIN catastro.tf_construcciones f ON e.id_ficha = f.id_ficha
WHERE b.tipo_ficha='01'
GROUP BY 1,2,3,4,5,6,7,8,9
ORDER BY a.gid;

-- 10. Actividades económicas
--DROP VIEW IF EXISTS geo.v_actividades_economicas;
CREATE VIEW geo.v_actividades_economicas AS
SELECT
a.gid AS gid,
b.id_lote,
CASE
	WHEN d.tipo_doc = '0'  THEN 'RUC'
	WHEN d.tipo_doc = '2'  THEN 'DNI'
END AS tipo_doc,
d.nume_doc,
CASE
	WHEN d.tipo_persona IS NULL THEN '0'
	ELSE d.tipo_persona
END AS tipo_persona,
CASE
	WHEN d.tipo_persona = '1' THEN 'PERSONA NATURAL'
	WHEN d.tipo_persona = '2' THEN 'PERSONA JURIDICA'
END AS persona,
CASE
	WHEN d.tipo_persona = '1' THEN d.ape_paterno || ' ' || d.ape_materno || ' ' || d.nombres
	WHEN d.tipo_persona = '2' THEN d.razon_social
END AS ciudadano_razon_social,
f.codi_actividad,
a.geom
FROM geo.tg_lote a
LEFT JOIN catastro.tf_fichas b ON a.id_lote = b.id_lote
LEFT JOIN catastro.tf_titulares c ON b.id_ficha = c.id_ficha
LEFT JOIN catastro.tf_personas d ON c.id_persona = d.id_persona
LEFT JOIN catastro.tf_tactividades_ficha e ON b.id_ficha = e.id_ficha
LEFT JOIN catastro.tf_actividades f ON e.codi_actividad = f.codi_actividad
WHERE b.tipo_ficha='03'
GROUP BY 1,2,3,4,5,6,7,8,9
ORDER BY a.gid;
