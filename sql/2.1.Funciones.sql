-- =========================================================
-- SETUP COMÚN (CTE base por lote)
-- Regla: Elegimos 1 ficha por lote (más reciente); 1 titular “preferido”;
-- agregamos pluralidades (servicios/usos/construcciones) sin duplicar filas.
-- =========================================================

-- 01) v_lotes ---------------------------------------------------------------
DROP VIEW IF EXISTS geo.v_lotes CASCADE;
CREATE OR REPLACE VIEW geo.v_lotes AS
WITH fe AS (
  SELECT b.*,
         ROW_NUMBER() OVER (PARTITION BY b.id_lote
                            ORDER BY b.fecha_creacion DESC NULLS LAST, b.id_ficha DESC) rn
  FROM catastro.tf_fichas b
),
tit AS (
  SELECT c.*,
         ROW_NUMBER() OVER (PARTITION BY c.id_ficha
                            ORDER BY c.es_principal DESC NULLS LAST, c.id_titular ASC) rn
  FROM catastro.tf_titulares c
),
indiv AS (
  SELECT i.*,
         ROW_NUMBER() OVER (PARTITION BY i.id_ficha
                            ORDER BY i.fecha_actualiza DESC NULLS LAST, i.id_ficha DESC) rn
  FROM catastro.tf_fichas_individuales i
),
cons AS (
  -- si hay varias construcciones por ficha, elige la más reciente; además exponemos nume_piso “preferido”
  SELECT x.*,
         ROW_NUMBER() OVER (PARTITION BY x.id_ficha
                            ORDER BY x.fecha_actualiza DESC NULLS LAST, x.id_construccion DESC) rn
  FROM catastro.tf_construcciones x
)
SELECT
  a.gid,
  fe1.id_ficha,
  ind1.imagen_plano AS fotografia,
  fe1.id_lote,
  a.cod_sector,
  a.cod_mzna,
  (a.cod_sector || a.cod_mzna || a.cod_lote) AS lotes_id,
  a.cod_lote,

  -- Existencias (misma lógica que tu vista, sin GROUP BY)
  CASE
    WHEN fe1.id_lote IS NULL AND ind1.imagen_plano IS NULL THEN 0
    WHEN fe1.id_lote IS NULL AND ind1.imagen_plano IS NOT NULL THEN 1
    WHEN fe1.id_lote IS NOT NULL AND ind1.imagen_plano IS NULL THEN 2
    ELSE 3
  END AS existe,
  CASE WHEN fe1.id_lote IS NULL THEN 2 ELSE 1 END AS existe_ficha,

  -- Persona
  CASE WHEN p.tipo_doc = '0' THEN 'RUC'
       WHEN p.tipo_doc = '2' THEN 'DNI' END AS tipo_doc,
  p.nume_doc,
  COALESCE(p.tipo_persona,'0') AS tipo_persona,
  CASE WHEN p.tipo_persona = '1' THEN 'PERSONA NATURAL'
       WHEN p.tipo_persona = '2' THEN 'PERSONA JURIDICA' END AS persona,
  CASE WHEN p.tipo_persona = '1'
       THEN p.ape_paterno || ' ' || p.ape_materno || ' ' || p.nombres
       WHEN p.tipo_persona = '2'
       THEN p.razon_social END AS ciudadano_razon_social,

  -- Un ejemplo de atributo de construcción representativo
  cons1.nume_piso,

  a.geom
FROM geo.tg_lote a
LEFT JOIN fe fe1            ON fe1.id_lote = a.id_lote AND fe1.rn = 1
LEFT JOIN tit t1            ON t1.id_ficha = fe1.id_ficha AND t1.rn = 1
LEFT JOIN catastro.tf_personas p ON p.id_persona = t1.id_persona
LEFT JOIN indiv ind1        ON ind1.id_ficha = fe1.id_ficha AND ind1.rn = 1
LEFT JOIN cons  cons1       ON cons1.id_ficha = ind1.id_ficha AND cons1.rn = 1
WHERE fe1.tipo_ficha = '01' OR fe1.id_ficha IS NULL;

-- 02) v_servicios_basicos ---------------------------------------------------
DROP VIEW IF EXISTS geo.v_servicios_basicos CASCADE;
CREATE OR REPLACE VIEW geo.v_servicios_basicos AS
WITH fe AS (
  SELECT b.*,
         ROW_NUMBER() OVER (PARTITION BY b.id_lote
                            ORDER BY b.fecha_creacion DESC NULLS LAST, b.id_ficha DESC) rn
  FROM catastro.tf_fichas b
),
tit AS (
  SELECT c.*,
         ROW_NUMBER() OVER (PARTITION BY c.id_ficha
                            ORDER BY c.es_principal DESC NULLS LAST, c.id_titular ASC) rn
  FROM catastro.tf_titulares c
),
serv AS (
  SELECT sb.id_ficha,
         jsonb_build_object(
           'luz', sb.luz, 'agua', sb.agua, 'telefono', sb.telefono,
           'desague', sb.desague, 'gas', sb.gas, 'internet', sb.internet, 'tvcable', sb.tvcable
         ) AS servicios_json
  FROM catastro.tf_servicios_basicos sb
)
SELECT
  a.gid,
  fe1.id_lote,
  CASE WHEN p.tipo_doc = '0' THEN 'RUC'
       WHEN p.tipo_doc = '2' THEN 'DNI' END AS tipo_doc,
  p.nume_doc,
  COALESCE(p.tipo_persona,'0') AS tipo_persona,
  CASE WHEN p.tipo_persona = '1' THEN 'PERSONA NATURAL'
       WHEN p.tipo_persona = '2' THEN 'PERSONA JURIDICA' END AS persona,
  CASE WHEN p.tipo_persona = '1'
       THEN p.ape_paterno || ' ' || p.ape_materno || ' ' || p.nombres
       WHEN p.tipo_persona = '2'
       THEN p.razon_social END AS ciudadano_razon_social,
  s.servicios_json,
  a.geom
FROM geo.tg_lote a
LEFT JOIN fe fe1            ON fe1.id_lote = a.id_lote AND fe1.rn = 1
LEFT JOIN tit t1            ON t1.id_ficha = fe1.id_ficha AND t1.rn = 1
LEFT JOIN catastro.tf_personas p ON p.id_persona = t1.id_persona
LEFT JOIN serv s            ON s.id_ficha = fe1.id_ficha;

-- 03) v_clasificacion_predios ----------------------------------------------
DROP VIEW IF EXISTS geo.v_clasificacion_predios CASCADE;
CREATE OR REPLACE VIEW geo.v_clasificacion_predios AS
WITH fe AS (
  SELECT b.*,
         ROW_NUMBER() OVER (PARTITION BY b.id_lote
                            ORDER BY b.fecha_creacion DESC NULLS LAST, b.id_ficha DESC) rn
  FROM catastro.tf_fichas b
),
tit AS (
  SELECT c.*,
         ROW_NUMBER() OVER (PARTITION BY c.id_ficha
                            ORDER BY c.es_principal DESC NULLS LAST, c.id_titular ASC) rn
  FROM catastro.tf_titulares c
),
indiv AS (
  SELECT i.*,
         ROW_NUMBER() OVER (PARTITION BY i.id_ficha
                            ORDER BY i.fecha_actualiza DESC NULLS LAST, i.id_ficha DESC) rn
  FROM catastro.tf_fichas_individuales i
)
SELECT
  a.gid,
  fe1.id_lote,
  CASE WHEN p.tipo_doc = '0' THEN 'RUC'
       WHEN p.tipo_doc = '2' THEN 'DNI' END AS tipo_doc,
  p.nume_doc,
  COALESCE(p.tipo_persona,'0') AS tipo_persona,
  CASE WHEN p.tipo_persona = '1' THEN 'PERSONA NATURAL'
       WHEN p.tipo_persona = '2' THEN 'PERSONA JURIDICA' END AS persona,
  CASE WHEN p.tipo_persona = '1'
       THEN p.ape_paterno || ' ' || p.ape_materno || ' ' || p.nombres
       WHEN p.tipo_persona = '2'
       THEN p.razon_social END AS ciudadano_razon_social,

  CASE
    WHEN substring(ind1.clasificacion,1,2) = '01' THEN 'CASA HABITACIÓN'
    WHEN substring(ind1.clasificacion,1,2) = '02' THEN 'TIENDA - DEPÓSITO - ALMACÉN'
    WHEN substring(ind1.clasificacion,1,2) = '03' THEN 'PREDIO EN EDIFICIO'
    WHEN substring(ind1.clasificacion,1,2) = '04' THEN 'OTROS'
    WHEN substring(ind1.clasificacion,1,2) = '05' THEN 'TERRENO SIN CONSTRUIR'
  END AS clasificacion,
  ind1.area_titulo,
  ind1.area_verificada,
  ind1.nume_habitantes,
  ind1.observaciones,
  a.geom
FROM geo.tg_lote a
LEFT JOIN fe    fe1         ON fe1.id_lote = a.id_lote AND fe1.rn = 1
LEFT JOIN tit   t1          ON t1.id_ficha = fe1.id_ficha AND t1.rn = 1
LEFT JOIN catastro.tf_personas p ON p.id_persona = t1.id_persona
LEFT JOIN indiv ind1        ON ind1.id_ficha = fe1.id_ficha AND ind1.rn = 1;

-- 04) v_tipos_personas ------------------------------------------------------
DROP VIEW IF EXISTS geo.v_tipos_personas CASCADE;
CREATE OR REPLACE VIEW geo.v_tipos_personas AS
WITH fe AS (
  SELECT b.*,
         ROW_NUMBER() OVER (PARTITION BY b.id_lote
                            ORDER BY b.fecha_creacion DESC NULLS LAST, b.id_ficha DESC) rn
  FROM catastro.tf_fichas b
),
tit AS (
  SELECT c.*,
         ROW_NUMBER() OVER (PARTITION BY c.id_ficha
                            ORDER BY c.es_principal DESC NULLS LAST, c.id_titular ASC) rn
  FROM catastro.tf_titulares c
)
SELECT
  a.gid,
  fe1.id_lote,
  CASE WHEN p.tipo_doc = '0' THEN 'RUC'
       WHEN p.tipo_doc = '2' THEN 'DNI' END AS tipo_doc,
  p.nume_doc,
  COALESCE(p.tipo_persona,'0') AS tipo_persona,
  CASE WHEN p.tipo_persona = '1' THEN 'PERSONA NATURAL'
       WHEN p.tipo_persona = '2' THEN 'PERSONA JURIDICA' END AS persona,
  CASE WHEN p.tipo_persona = '1'
       THEN p.ape_paterno || ' ' || p.ape_materno || ' ' || p.nombres
       WHEN p.tipo_persona = '2'
       THEN p.razon_social END AS ciudadano_razon_social,
  a.geom
FROM geo.tg_lote a
LEFT JOIN fe fe1            ON fe1.id_lote = a.id_lote AND fe1.rn = 1
LEFT JOIN tit t1            ON t1.id_ficha = fe1.id_ficha AND t1.rn = 1
LEFT JOIN catastro.tf_personas p ON p.id_persona = t1.id_persona;

-- 05) v_tipos_usos ----------------------------------------------------------
DROP VIEW IF EXISTS geo.v_tipos_usos CASCADE;
CREATE OR REPLACE VIEW geo.v_tipos_usos AS
WITH fe AS (
  SELECT b.*,
         ROW_NUMBER() OVER (PARTITION BY b.id_lote
                            ORDER BY b.fecha_creacion DESC NULLS LAST, b.id_ficha DESC) rn
  FROM catastro.tf_fichas b
),
tit AS (
  SELECT c.*,
         ROW_NUMBER() OVER (PARTITION BY c.id_ficha
                            ORDER BY c.es_principal DESC NULLS LAST, c.id_titular ASC) rn
  FROM catastro.tf_titulares c
),
indiv AS (
  SELECT i.*,
         ROW_NUMBER() OVER (PARTITION BY i.id_ficha
                            ORDER BY i.fecha_actualiza DESC NULLS LAST, i.id_ficha DESC) rn
  FROM catastro.tf_fichas_individuales i
),
usos AS (
  SELECT e.id_ficha,
         COALESCE(jsonb_agg(DISTINCT u.codi_uso) FILTER (WHERE u.codi_uso IS NOT NULL), '[]'::jsonb) AS usos_json
  FROM catastro.tf_fichas_individuales e
  LEFT JOIN catastro.tf_usos u ON u.codi_uso = e.codi_uso
  GROUP BY e.id_ficha
)
SELECT
  a.gid,
  fe1.id_lote,
  CASE WHEN p.tipo_doc = '0' THEN 'RUC'
       WHEN p.tipo_doc = '2' THEN 'DNI' END AS tipo_doc,
  p.nume_doc,
  COALESCE(p.tipo_persona,'0') AS tipo_persona,
  CASE WHEN p.tipo_persona = '1' THEN 'PERSONA NATURAL'
       WHEN p.tipo_persona = '2' THEN 'PERSONA JURIDICA' END AS persona,
  CASE WHEN p.tipo_persona = '1'
       THEN p.ape_paterno || ' ' || p.ape_materno || ' ' || p.nombres
       WHEN p.tipo_persona = '2'
       THEN p.razon_social END AS ciudadano_razon_social,
  u.usos_json,
  a.geom
FROM geo.tg_lote a
LEFT JOIN fe fe1            ON fe1.id_lote = a.id_lote AND fe1.rn = 1
LEFT JOIN tit t1            ON t1.id_ficha = fe1.id_ficha AND t1.rn = 1
LEFT JOIN catastro.tf_personas p ON p.id_persona = t1.id_persona
LEFT JOIN indiv ind1        ON ind1.id_ficha = fe1.id_ficha AND ind1.rn = 1
LEFT JOIN usos u            ON u.id_ficha = ind1.id_ficha
WHERE fe1.tipo_ficha = '01' OR fe1.id_ficha IS NULL;

-- 06) v_material_construccion ----------------------------------------------
DROP VIEW IF EXISTS geo.v_material_construccion CASCADE;
CREATE OR REPLACE VIEW geo.v_material_construccion AS
WITH fe AS (
  SELECT b.*,
         ROW_NUMBER() OVER (PARTITION BY b.id_lote
                            ORDER BY b.fecha_creacion DESC NULLS LAST, b.id_ficha DESC) rn
  FROM catastro.tf_fichas b
),
tit AS (
  SELECT c.*,
         ROW_NUMBER() OVER (PARTITION BY c.id_ficha
                            ORDER BY c.es_principal DESC NULLS LAST, c.id_titular ASC) rn
  FROM catastro.tf_titulares c
),
indiv AS (
  SELECT i.*,
         ROW_NUMBER() OVER (PARTITION BY i.id_ficha
                            ORDER BY i.fecha_actualiza DESC NULLS LAST, i.id_ficha DESC) rn
  FROM catastro.tf_fichas_individuales i
),
cons_agg AS (
  SELECT x.id_ficha,
         COALESCE(array_agg(DISTINCT x.mep) FILTER (WHERE x.mep IS NOT NULL), ARRAY[]::text[]) AS materiales
  FROM catastro.tf_construcciones x
  GROUP BY x.id_ficha
)
SELECT
  a.gid,
  fe1.id_lote,
  CASE WHEN p.tipo_doc = '0' THEN 'RUC'
       WHEN p.tipo_doc = '2' THEN 'DNI' END AS tipo_doc,
  p.nume_doc,
  COALESCE(p.tipo_persona,'0') AS tipo_persona,
  CASE WHEN p.tipo_persona = '1' THEN 'PERSONA NATURAL'
       WHEN p.tipo_persona = '2' THEN 'PERSONA JURIDICA' END AS persona,
  CASE WHEN p.tipo_persona = '1'
       THEN p.ape_paterno || ' ' || p.ape_materno || ' ' || p.nombres
       WHEN p.tipo_persona = '2'
       THEN p.razon_social END AS ciudadano_razon_social,
  ca.materiales,  -- pluralidad sin duplicados
  a.geom
FROM geo.tg_lote a
LEFT JOIN fe fe1            ON fe1.id_lote = a.id_lote AND fe1.rn = 1
LEFT JOIN tit t1            ON t1.id_ficha = fe1.id_ficha AND t1.rn = 1
LEFT JOIN catastro.tf_personas p ON p.id_persona = t1.id_persona
LEFT JOIN indiv ind1        ON ind1.id_ficha = fe1.id_ficha AND ind1.rn = 1
LEFT JOIN cons_agg ca       ON ca.id_ficha = ind1.id_ficha
WHERE fe1.tipo_ficha = '01' OR fe1.id_ficha IS NULL;

-- 07) v_estado_conservacion -------------------------------------------------
DROP VIEW IF EXISTS geo.v_estado_conservacion CASCADE;
CREATE OR REPLACE VIEW geo.v_estado_conservacion AS
WITH fe AS (
  SELECT b.*,
         ROW_NUMBER() OVER (PARTITION BY b.id_lote
                            ORDER BY b.fecha_creacion DESC NULLS LAST, b.id_ficha DESC) rn
  FROM catastro.tf_fichas b
),
tit AS (
  SELECT c.*,
         ROW_NUMBER() OVER (PARTITION BY c.id_ficha
                            ORDER BY c.es_principal DESC NULLS LAST, c.id_titular ASC) rn
  FROM catastro.tf_titulares c
),
indiv AS (
  SELECT i.*,
         ROW_NUMBER() OVER (PARTITION BY i.id_ficha
                            ORDER BY i.fecha_actualiza DESC NULLS LAST, i.id_ficha DESC) rn
  FROM catastro.tf_fichas_individuales i
),
cons_agg AS (
  SELECT x.id_ficha,
         COALESCE(array_agg(DISTINCT x.ecs) FILTER (WHERE x.ecs IS NOT NULL), ARRAY[]::text[]) AS estados_conservacion
  FROM catastro.tf_construcciones x
  GROUP BY x.id_ficha
)
SELECT
  a.gid,
  fe1.id_lote,
  CASE WHEN p.tipo_doc = '0' THEN 'RUC'
       WHEN p.tipo_doc = '2' THEN 'DNI' END AS tipo_doc,
  p.nume_doc,
  COALESCE(p.tipo_persona,'0') AS tipo_persona,
  CASE WHEN p.tipo_persona = '1' THEN 'PERSONA NATURAL'
       WHEN p.tipo_persona = '2' THEN 'PERSONA JURIDICA' END AS persona,
  CASE WHEN p.tipo_persona = '1'
       THEN p.ape_paterno || ' ' || p.ape_materno || ' ' || p.nombres
       WHEN p.tipo_persona = '2'
       THEN p.razon_social END AS ciudadano_razon_social,
  ca.estados_conservacion,
  a.geom
FROM geo.tg_lote a
LEFT JOIN fe fe1            ON fe1.id_lote = a.id_lote AND fe1.rn = 1
LEFT JOIN tit t1            ON t1.id_ficha = fe1.id_ficha AND t1.rn = 1
LEFT JOIN catastro.tf_personas p ON p.id_persona = t1.id_persona
LEFT JOIN indiv ind1        ON ind1.id_ficha = fe1.id_ficha AND ind1.rn = 1
LEFT JOIN cons_agg ca       ON ca.id_ficha = ind1.id_ficha
WHERE fe1.tipo_ficha = '01' OR fe1.id_ficha IS NULL;

-- 08) v_estado_construccion -------------------------------------------------
DROP VIEW IF EXISTS geo.v_estado_construccion CASCADE;
CREATE OR REPLACE VIEW geo.v_estado_construccion AS
WITH fe AS (
  SELECT b.*,
         ROW_NUMBER() OVER (PARTITION BY b.id_lote
                            ORDER BY b.fecha_creacion DESC NULLS LAST, b.id_ficha DESC) rn
  FROM catastro.tf_fichas b
),
tit AS (
  SELECT c.*,
         ROW_NUMBER() OVER (PARTITION BY c.id_ficha
                            ORDER BY c.es_principal DESC NULLS LAST, c.id_titular ASC) rn
  FROM catastro.tf_titulares c
),
indiv AS (
  SELECT i.*,
         ROW_NUMBER() OVER (PARTITION BY i.id_ficha
                            ORDER BY i.fecha_actualiza DESC NULLS LAST, i.id_ficha DESC) rn
  FROM catastro.tf_fichas_individuales i
),
cons_agg AS (
  SELECT x.id_ficha,
         COALESCE(array_agg(DISTINCT x.ecc) FILTER (WHERE x.ecc IS NOT NULL), ARRAY[]::text[]) AS estados_construccion
  FROM catastro.tf_construcciones x
  GROUP BY x.id_ficha
)
SELECT
  a.gid,
  fe1.id_lote,
  CASE WHEN p.tipo_doc = '0' THEN 'RUC'
       WHEN p.tipo_doc = '2' THEN 'DNI' END AS tipo_doc,
  p.nume_doc,
  COALESCE(p.tipo_persona,'0') AS tipo_persona,
  CASE WHEN p.tipo_persona = '1' THEN 'PERSONA NATURAL'
       WHEN p.tipo_persona = '2' THEN 'PERSONA JURIDICA' END AS persona,
  CASE WHEN p.tipo_persona = '1'
       THEN p.ape_paterno || ' ' || p.ape_materno || ' ' || p.nombres
       WHEN p.tipo_persona = '2'
       THEN p.razon_social END AS ciudadano_razon_social,
  ca.estados_construccion,
  a.geom
FROM geo.tg_lote a
LEFT JOIN fe fe1            ON fe1.id_lote = a.id_lote AND fe1.rn = 1
LEFT JOIN tit t1            ON t1.id_ficha = fe1.id_ficha AND t1.rn = 1
LEFT JOIN catastro.tf_personas p ON p.id_persona = t1.id_persona
LEFT JOIN indiv ind1        ON ind1.id_ficha = fe1.id_ficha AND ind1.rn = 1
LEFT JOIN cons_agg ca       ON ca.id_ficha = ind1.id_ficha
WHERE fe1.tipo_ficha = '01' OR fe1.id_ficha IS NULL;

-- 09) v_niveles_construccion -----------------------------------------------
DROP VIEW IF EXISTS geo.v_niveles_construccion CASCADE;
CREATE OR REPLACE VIEW geo.v_niveles_construccion AS
WITH fe AS (
  SELECT b.*,
         ROW_NUMBER() OVER (PARTITION BY b.id_lote
                            ORDER BY b.fecha_creacion DESC NULLS LAST, b.id_ficha DESC) rn
  FROM catastro.tf_fichas b
),
tit AS (
  SELECT c.*,
         ROW_NUMBER() OVER (PARTITION BY c.id_ficha
                            ORDER BY c.es_principal DESC NULLS LAST, c.id_titular ASC) rn
  FROM catastro.tf_titulares c
),
indiv AS (
  SELECT i.*,
         ROW_NUMBER() OVER (PARTITION BY i.id_ficha
                            ORDER BY i.fecha_actualiza DESC NULLS LAST, i.id_ficha DESC) rn
  FROM catastro.tf_fichas_individuales i
),
cons_agg AS (
  SELECT x.id_ficha,
         MAX(x.nume_piso) AS nume_piso_max,  -- si hay varios, devuelve el máximo
         COALESCE(array_agg(DISTINCT x.nume_piso) FILTER (WHERE x.nume_piso IS NOT NULL), ARRAY[]::int[]) AS niveles
  FROM catastro.tf_construcciones x
  GROUP BY x.id_ficha
)
SELECT
  a.gid,
  fe1.id_lote,
  CASE WHEN p.tipo_doc = '0' THEN 'RUC'
       WHEN p.tipo_doc = '2' THEN 'DNI' END AS tipo_doc,
  p.nume_doc,
  COALESCE(p.tipo_persona,'0') AS tipo_persona,
  CASE WHEN p.tipo_persona = '1' THEN 'PERSONA NATURAL'
       WHEN p.tipo_persona = '2' THEN 'PERSONA JURIDICA' END AS persona,
  CASE WHEN p.tipo_persona = '1'
       THEN p.ape_paterno || ' ' || p.ape_materno || ' ' || p.nombres
       WHEN p.tipo_persona = '2'
       THEN p.razon_social END AS ciudadano_razon_social,
  ca.nume_piso_max,
  ca.niveles,
  a.geom
FROM geo.tg_lote a
LEFT JOIN fe fe1            ON fe1.id_lote = a.id_lote AND fe1.rn = 1
LEFT JOIN tit t1            ON t1.id_ficha = fe1.id_ficha AND t1.rn = 1
LEFT JOIN catastro.tf_personas p ON p.id_persona = t1.id_persona
LEFT JOIN indiv ind1        ON ind1.id_ficha = fe1.id_ficha AND ind1.rn = 1
LEFT JOIN cons_agg ca       ON ca.id_ficha = ind1.id_ficha
WHERE fe1.tipo_ficha = '01' OR fe1.id_ficha IS NULL;
