--
-- FECHA DE CREACIÓN 	 : 22/10/2024
-- FECHA DE MODIFICACIÓN : 26/02/2026
--

-- 01. Lotes con y sin ficha catastral
DROP VIEW IF EXISTS geo.v_lote;
CREATE OR REPLACE VIEW geo.v_lote AS
WITH fichas_lote AS (
    SELECT DISTINCT ON (b.id_lote)
        b.id_lote,
        b.id_ficha,
        c.imagen_lote,
        c.area_verificada
    FROM catastro.tf_fichas b
    LEFT JOIN catastro.tf_fichas_individuales c ON b.id_ficha = c.id_ficha
    ORDER BY b.id_lote, b.tipo_ficha NULLS LAST
)
SELECT
    a.gid,
	fl.id_lote,
    fl.imagen_lote                                          AS foto_lote,
    a.cuc,
    a.cod_sector,
    a.cod_mzna,
    a.cod_lote,
    ROUND(ST_Area(a.geom)::decimal, 2)                      AS a_grafi,
    COALESCE(ROUND(fl.area_verificada::decimal, 2), 0)      AS a_verifi,
    CASE
        WHEN fl.id_lote IS NOT NULL THEN 1
        ELSE 2
    END                                                     AS ficha,
	a.cod_sector || a.cod_mzna || a. cod_lote				AS idlote,
	a.geom
FROM geo.tg_lote a
LEFT JOIN fichas_lote fl ON a.id_lote = fl.id_lote
ORDER BY a.cod_sector, a.cod_mzna, a.cod_lote;

SELECT * FROM geo.v_lote;

-- 02. Servicios básicos
DROP VIEW IF EXISTS geo.v_servicio_basico;
CREATE OR REPLACE VIEW geo.v_servicio_basico AS
WITH ficha_principal AS (
    SELECT DISTINCT ON (b.id_lote)
        b.id_lote,
        b.id_ficha
    FROM catastro.tf_fichas b
    ORDER BY b.id_lote, b.tipo_ficha NULLS LAST
),
titular_principal AS (
    SELECT DISTINCT ON (c.id_ficha)
        c.id_ficha,
        d.tipo_doc,
        d.nume_doc,
        d.tipo_persona,
        d.ape_paterno,
        d.ape_materno,
        d.nombres,
        d.razon_social
    FROM catastro.tf_titulares c
    JOIN catastro.tf_personas d ON c.id_persona = d.id_persona
    ORDER BY c.id_ficha
)
SELECT
    a.gid,
    fp.id_lote,
    CASE
        WHEN tp.tipo_doc = '0' THEN 'RUC'
        WHEN tp.tipo_doc = '2' THEN 'DNI'
    END                                                     AS tipo_doc,
    tp.nume_doc,
    CASE
        WHEN tp.tipo_persona = '1' THEN 'PERSONA NATURAL'
        WHEN tp.tipo_persona = '2' THEN 'PERSONA JURIDICA'
    END                                                     AS tipo_persona,
    CASE
        WHEN tp.tipo_persona = '1' THEN tp.ape_paterno || ' ' || tp.ape_materno || ' ' || tp.nombres
        WHEN tp.tipo_persona = '2' THEN tp.razon_social
    END                                                     AS ciudadano_razon_social,
    e.luz                                                   AS codi_luz,
    e.agua                                                  AS codi_agua,
    e.telefono                                              AS codi_telefono,
    e.desague                                               AS codi_desague,
    e.gas                                                   AS codi_gas,
    e.internet                                              AS codi_internet,
    e.tvcable                                               AS codi_tvcable,
    CASE WHEN e.luz      = '1' THEN 'SI' WHEN e.luz      = '2' THEN 'NO' END AS luz,
    CASE WHEN e.agua     = '1' THEN 'SI' WHEN e.agua     = '2' THEN 'NO' END AS agua,
    CASE WHEN e.telefono = '1' THEN 'SI' WHEN e.telefono = '2' THEN 'NO' END AS telefono,
    CASE WHEN e.desague  = '1' THEN 'SI' WHEN e.desague  = '2' THEN 'NO' END AS desague,
    CASE WHEN e.gas      = '1' THEN 'SI' WHEN e.gas      = '2' THEN 'NO' END AS gas,
    CASE WHEN e.internet = '1' THEN 'SI' WHEN e.internet = '2' THEN 'NO' END AS internet,
    CASE WHEN e.tvcable  = '1' THEN 'SI' WHEN e.tvcable  = '2' THEN 'NO' END AS tvcable,
    a.geom
FROM geo.tg_lote a
LEFT JOIN ficha_principal fp           ON a.id_lote = fp.id_lote
LEFT JOIN titular_principal tp         ON fp.id_ficha = tp.id_ficha
LEFT JOIN catastro.tf_servicios_basicos e ON fp.id_ficha = e.id_ficha
ORDER BY a.gid;

--SELECT * FROM geo.v_servicio_basico;

-- 03. Clasificación del Predio
DROP VIEW IF EXISTS geo.v_clasificacion_predio;
CREATE OR REPLACE VIEW geo.v_clasificacion_predio AS
WITH ficha_principal AS (
    SELECT DISTINCT ON (b.id_lote)
        b.id_lote,
        b.id_ficha
    FROM catastro.tf_fichas b
    ORDER BY b.id_lote, b.tipo_ficha NULLS LAST
),
titular_principal AS (
    SELECT DISTINCT ON (c.id_ficha)
        c.id_ficha,
        d.tipo_doc,
        d.nume_doc,
        d.tipo_persona,
        d.ape_paterno,
        d.ape_materno,
        d.nombres,
        d.razon_social
    FROM catastro.tf_titulares c
    JOIN catastro.tf_personas d ON c.id_persona = d.id_persona
    ORDER BY c.id_ficha
)
SELECT
    a.gid,
    fp.id_lote,
    CASE
        WHEN tp.tipo_doc = '0' THEN 'RUC'
        WHEN tp.tipo_doc = '2' THEN 'DNI'
    END                                                     AS tipo_doc,
    tp.nume_doc,
    CASE
        WHEN tp.tipo_persona = '1' THEN 'PERSONA NATURAL'
        WHEN tp.tipo_persona = '2' THEN 'PERSONA JURIDICA'
    END                                                     AS tipo_persona,
    CASE
        WHEN tp.tipo_persona = '1' THEN tp.ape_paterno || ' ' || tp.ape_materno || ' ' || tp.nombres
        WHEN tp.tipo_persona = '2' THEN tp.razon_social
    END                                                     AS ciudadano_razon_social,
    substring(e.clasificacion, 1, 2)                        AS codi_clasi,
    CASE
        WHEN substring(e.clasificacion, 1, 2) = '01' THEN 'CASA HABITACIÓN'
        WHEN substring(e.clasificacion, 1, 2) = '02' THEN 'TIENDA - DEPÓSITO - ALMACÉN'
        WHEN substring(e.clasificacion, 1, 2) = '03' THEN 'PREDIO EN EDIFICIO'
        WHEN substring(e.clasificacion, 1, 2) = '04' THEN 'OTROS'
        WHEN substring(e.clasificacion, 1, 2) = '05' THEN 'TERRENO SIN CONSTRUIR'
    END                                                     AS clasificacion,
    e.area_titulo,
    e.area_verificada,
    e.nume_habitantes,
    e.observaciones,
    a.geom
FROM geo.tg_lote a
LEFT JOIN ficha_principal fp                ON a.id_lote = fp.id_lote
LEFT JOIN titular_principal tp              ON fp.id_ficha = tp.id_ficha
LEFT JOIN catastro.tf_fichas_individuales e ON fp.id_ficha = e.id_ficha
ORDER BY a.gid;

--SELECT * FROM geo.v_clasificacion_predio;

-- 04. Personas Natural / Persona Jurídica
DROP VIEW IF EXISTS geo.v_tipo_persona;
CREATE OR REPLACE VIEW geo.v_tipo_persona AS
WITH ficha_principal AS (
    SELECT DISTINCT ON (b.id_lote)
        b.id_lote,
        b.id_ficha
    FROM catastro.tf_fichas b
    ORDER BY b.id_lote, b.tipo_ficha NULLS LAST
),
titular_principal AS (
    SELECT DISTINCT ON (c.id_ficha)
        c.id_ficha,
        d.tipo_doc,
        d.nume_doc,
        d.tipo_persona,
        d.ape_paterno,
        d.ape_materno,
        d.nombres,
        d.razon_social
    FROM catastro.tf_titulares c
    JOIN catastro.tf_personas d ON c.id_persona = d.id_persona
    ORDER BY c.id_ficha
)
SELECT
    a.gid,
    fp.id_lote,
    CASE
        WHEN tp.tipo_doc = '0' THEN 'RUC'
        WHEN tp.tipo_doc = '2' THEN 'DNI'
    END                                                     AS tipo_doc,
    tp.nume_doc,
    COALESCE(tp.tipo_persona, '0')                          AS tipo_persona,
    CASE
        WHEN tp.tipo_persona = '1' THEN 'PERSONA NATURAL'
        WHEN tp.tipo_persona = '2' THEN 'PERSONA JURIDICA'
    END                                                     AS persona,
    CASE
        WHEN tp.tipo_persona = '1' THEN tp.ape_paterno || ' ' || tp.ape_materno || ' ' || tp.nombres
        WHEN tp.tipo_persona = '2' THEN tp.razon_social
    END                                                     AS ciudadano_razon_social,
    a.geom
FROM geo.tg_lote a
LEFT JOIN ficha_principal fp   ON a.id_lote = fp.id_lote
LEFT JOIN titular_principal tp ON fp.id_ficha = tp.id_ficha
ORDER BY a.gid;

--SELECT * FROM geo.v_tipo_persona;

-- 05. Tipo de uso
DROP VIEW IF EXISTS geo.v_tipo_uso;
CREATE OR REPLACE VIEW geo.v_tipo_uso AS
WITH ficha_principal AS (
    SELECT DISTINCT ON (b.id_lote)
        b.id_lote,
        b.id_ficha
    FROM catastro.tf_fichas b
    WHERE b.tipo_ficha = '01'
    ORDER BY b.id_lote, b.id_ficha
),
titular_principal AS (
    SELECT DISTINCT ON (c.id_ficha)
        c.id_ficha,
        d.tipo_doc,
        d.nume_doc,
        d.tipo_persona,
        d.ape_paterno,
        d.ape_materno,
        d.nombres,
        d.razon_social
    FROM catastro.tf_titulares c
    JOIN catastro.tf_personas d ON c.id_persona = d.id_persona
    ORDER BY c.id_ficha
)
SELECT
    a.gid,
    fp.id_lote,
    CASE
        WHEN tp.tipo_doc = '0' THEN 'RUC'
        WHEN tp.tipo_doc = '2' THEN 'DNI'
    END                                                     AS tipo_doc,
    tp.nume_doc,
    COALESCE(tp.tipo_persona, '0')                          AS tipo_persona,
    CASE
        WHEN tp.tipo_persona = '1' THEN 'PERSONA NATURAL'
        WHEN tp.tipo_persona = '2' THEN 'PERSONA JURIDICA'
    END                                                     AS persona,
    CASE
        WHEN tp.tipo_persona = '1' THEN tp.ape_paterno || ' ' || tp.ape_materno || ' ' || tp.nombres
        WHEN tp.tipo_persona = '2' THEN tp.razon_social
    END                                                     AS ciudadano_razon_social,
    u.codi_uso,
    a.geom
FROM geo.tg_lote a
LEFT JOIN ficha_principal fp                ON a.id_lote = fp.id_lote
LEFT JOIN titular_principal tp              ON fp.id_ficha = tp.id_ficha
LEFT JOIN catastro.tf_fichas_individuales e ON fp.id_ficha = e.id_ficha
LEFT JOIN catastro.tf_usos u               ON u.codi_uso = e.codi_uso
ORDER BY a.gid;

--SELECT * FROM geo.v_tipo_uso;

-- 06. Material de construcción
DROP VIEW IF EXISTS geo.v_material_construccion;
CREATE OR REPLACE VIEW geo.v_material_construccion AS
WITH ficha_principal AS (
    SELECT DISTINCT ON (b.id_lote)
        b.id_lote,
        b.id_ficha
    FROM catastro.tf_fichas b
    WHERE b.tipo_ficha = '01'
    ORDER BY b.id_lote, b.id_ficha
),
titular_principal AS (
    SELECT DISTINCT ON (c.id_ficha)
        c.id_ficha,
        d.tipo_doc,
        d.nume_doc,
        d.tipo_persona,
        d.ape_paterno,
        d.ape_materno,
        d.nombres,
        d.razon_social
    FROM catastro.tf_titulares c
    JOIN catastro.tf_personas d ON c.id_persona = d.id_persona
    ORDER BY c.id_ficha
),
construccion_principal AS (
    SELECT DISTINCT ON (id_ficha)
        id_ficha,
        mep
    FROM catastro.tf_construcciones
    ORDER BY id_ficha, codi_construccion
)
SELECT
    a.gid,
    fp.id_lote,
    CASE
        WHEN tp.tipo_doc = '0' THEN 'RUC'
        WHEN tp.tipo_doc = '2' THEN 'DNI'
    END                                                     AS tipo_doc,
    tp.nume_doc,
    COALESCE(tp.tipo_persona, '0')                          AS tipo_persona,
    CASE
        WHEN tp.tipo_persona = '1' THEN 'PERSONA NATURAL'
        WHEN tp.tipo_persona = '2' THEN 'PERSONA JURIDICA'
    END                                                     AS persona,
    CASE
        WHEN tp.tipo_persona = '1' THEN tp.ape_paterno || ' ' || tp.ape_materno || ' ' || tp.nombres
        WHEN tp.tipo_persona = '2' THEN tp.razon_social
    END                                                     AS ciudadano_razon_social,
    cp.mep,
    a.geom
FROM geo.tg_lote a
LEFT JOIN ficha_principal fp         ON a.id_lote = fp.id_lote
LEFT JOIN titular_principal tp       ON fp.id_ficha = tp.id_ficha
LEFT JOIN construccion_principal cp  ON fp.id_ficha = cp.id_ficha
ORDER BY a.gid;

--SELECT * FROM geo.v_material_construccion;

-- 07. Estado de conservación
DROP VIEW IF EXISTS geo.v_estado_conservacion;
CREATE OR REPLACE VIEW geo.v_estado_conservacion AS
WITH ficha_principal AS (
    SELECT DISTINCT ON (b.id_lote)
        b.id_lote,
        b.id_ficha
    FROM catastro.tf_fichas b
    WHERE b.tipo_ficha = '01'
    ORDER BY b.id_lote, b.id_ficha
),
titular_principal AS (
    SELECT DISTINCT ON (c.id_ficha)
        c.id_ficha,
        d.tipo_doc,
        d.nume_doc,
        d.tipo_persona,
        d.ape_paterno,
        d.ape_materno,
        d.nombres,
        d.razon_social
    FROM catastro.tf_titulares c
    JOIN catastro.tf_personas d ON c.id_persona = d.id_persona
    ORDER BY c.id_ficha
),
construccion_principal AS (
    SELECT DISTINCT ON (id_ficha)
        id_ficha,
        ecs
    FROM catastro.tf_construcciones
    ORDER BY id_ficha, codi_construccion
)
SELECT
    a.gid,
    fp.id_lote,
    CASE
        WHEN tp.tipo_doc = '0' THEN 'RUC'
        WHEN tp.tipo_doc = '2' THEN 'DNI'
    END                                                     AS tipo_doc,
    tp.nume_doc,
    COALESCE(tp.tipo_persona, '0')                          AS tipo_persona,
    CASE
        WHEN tp.tipo_persona = '1' THEN 'PERSONA NATURAL'
        WHEN tp.tipo_persona = '2' THEN 'PERSONA JURIDICA'
    END                                                     AS persona,
    CASE
        WHEN tp.tipo_persona = '1' THEN tp.ape_paterno || ' ' || tp.ape_materno || ' ' || tp.nombres
        WHEN tp.tipo_persona = '2' THEN tp.razon_social
    END                                                     AS ciudadano_razon_social,
    cp.ecs,
    a.geom
FROM geo.tg_lote a
LEFT JOIN ficha_principal fp         ON a.id_lote = fp.id_lote
LEFT JOIN titular_principal tp       ON fp.id_ficha = tp.id_ficha
LEFT JOIN construccion_principal cp  ON fp.id_ficha = cp.id_ficha
ORDER BY a.gid;

--SELECT * FROM geo.v_estado_conservacion;

-- 08. Estado de la construcción
DROP VIEW IF EXISTS geo.v_estado_construccion;
CREATE OR REPLACE VIEW geo.v_estado_construccion AS
WITH ficha_principal AS (
    SELECT DISTINCT ON (b.id_lote)
        b.id_lote,
        b.id_ficha
    FROM catastro.tf_fichas b
    WHERE b.tipo_ficha = '01'
    ORDER BY b.id_lote, b.id_ficha
),
titular_principal AS (
    SELECT DISTINCT ON (c.id_ficha)
        c.id_ficha,
        d.tipo_doc,
        d.nume_doc,
        d.tipo_persona,
        d.ape_paterno,
        d.ape_materno,
        d.nombres,
        d.razon_social
    FROM catastro.tf_titulares c
    JOIN catastro.tf_personas d ON c.id_persona = d.id_persona
    ORDER BY c.id_ficha
),
construccion_principal AS (
    SELECT DISTINCT ON (id_ficha)
        id_ficha,
        ecc
    FROM catastro.tf_construcciones
    ORDER BY id_ficha, codi_construccion
)
SELECT
    a.gid,
    fp.id_lote,
    CASE
        WHEN tp.tipo_doc = '0' THEN 'RUC'
        WHEN tp.tipo_doc = '2' THEN 'DNI'
    END                                                     AS tipo_doc,
    tp.nume_doc,
    COALESCE(tp.tipo_persona, '0')                          AS tipo_persona,
    CASE
        WHEN tp.tipo_persona = '1' THEN 'PERSONA NATURAL'
        WHEN tp.tipo_persona = '2' THEN 'PERSONA JURIDICA'
    END                                                     AS persona,
    CASE
        WHEN tp.tipo_persona = '1' THEN tp.ape_paterno || ' ' || tp.ape_materno || ' ' || tp.nombres
        WHEN tp.tipo_persona = '2' THEN tp.razon_social
    END                                                     AS ciudadano_razon_social,
    cp.ecc,
    a.geom
FROM geo.tg_lote a
LEFT JOIN ficha_principal fp         ON a.id_lote = fp.id_lote
LEFT JOIN titular_principal tp       ON fp.id_ficha = tp.id_ficha
LEFT JOIN construccion_principal cp  ON fp.id_ficha = cp.id_ficha
ORDER BY a.gid;

--SELECT * FROM geo.v_estado_construccion;

-- 09. Nivel de construcción
DROP VIEW IF EXISTS geo.v_nivel_construccion;
CREATE OR REPLACE VIEW geo.v_nivel_construccion AS
WITH ficha_principal AS (
    SELECT DISTINCT ON (b.id_lote)
        b.id_lote,
        b.id_ficha
    FROM catastro.tf_fichas b
    WHERE b.tipo_ficha = '01'
    ORDER BY b.id_lote, b.id_ficha
),
titular_principal AS (
    SELECT DISTINCT ON (c.id_ficha)
        c.id_ficha,
        d.tipo_doc,
        d.nume_doc,
        d.tipo_persona,
        d.ape_paterno,
        d.ape_materno,
        d.nombres,
        d.razon_social
    FROM catastro.tf_titulares c
    JOIN catastro.tf_personas d ON c.id_persona = d.id_persona
    ORDER BY c.id_ficha
),
nivel_agg AS (
    SELECT
        id_ficha,
        COUNT(id_construccion)          AS total_pisos,
        MAX(TRIM(nume_piso))            AS piso_maximo
    FROM catastro.tf_construcciones
    GROUP BY id_ficha
)
SELECT
    a.gid,
    fp.id_lote,
    CASE
        WHEN tp.tipo_doc = '0' THEN 'RUC'
        WHEN tp.tipo_doc = '2' THEN 'DNI'
    END                                                     AS tipo_doc,
    tp.nume_doc,
    COALESCE(tp.tipo_persona, '0')                          AS tipo_persona,
    CASE
        WHEN tp.tipo_persona = '1' THEN 'PERSONA NATURAL'
        WHEN tp.tipo_persona = '2' THEN 'PERSONA JURIDICA'
    END                                                     AS persona,
    CASE
        WHEN tp.tipo_persona = '1' THEN tp.ape_paterno || ' ' || tp.ape_materno || ' ' || tp.nombres
        WHEN tp.tipo_persona = '2' THEN tp.razon_social
    END                                                     AS ciudadano_razon_social,
    COALESCE(na.total_pisos, 0)                             AS total_pisos,
    na.piso_maximo,
    a.geom
FROM geo.tg_lote a
LEFT JOIN ficha_principal fp   ON a.id_lote = fp.id_lote
LEFT JOIN titular_principal tp ON fp.id_ficha = tp.id_ficha
LEFT JOIN nivel_agg na         ON fp.id_ficha = na.id_ficha
ORDER BY a.gid;

--SELECT * FROM geo.v_nivel_construccion;

-- 10. Actividades económicas
DROP VIEW IF EXISTS geo.v_actividad_economica;
CREATE OR REPLACE VIEW geo.v_actividad_economica AS
WITH ficha_principal AS (
  SELECT DISTINCT ON (b.id_lote)
    b.id_lote,
    b.id_ficha
  FROM catastro.tf_fichas b
  WHERE b.tipo_ficha = '03'
  ORDER BY b.id_lote, b.id_ficha
),
titular_principal AS (
  SELECT DISTINCT ON (c.id_ficha)
      c.id_ficha,
      d.tipo_doc,
      d.nume_doc,
      d.tipo_persona,
      d.ape_paterno,
      d.ape_materno,
      d.nombres,
      d.razon_social
  FROM catastro.tf_titulares c
  JOIN catastro.tf_personas d ON c.id_persona = d.id_persona
  ORDER BY c.id_ficha
),
actividad_principal AS (
  SELECT DISTINCT ON (e.id_ficha)
      e.id_ficha,
      f.codi_actividad
  FROM catastro.tf_autorizaciones_funcionamiento e
  JOIN catastro.tf_actividades f ON e.codi_actividad = f.codi_actividad
  ORDER BY e.id_ficha, f.codi_actividad
)
SELECT
  a.gid,
  fp.id_lote,
  CASE
      WHEN tp.tipo_doc = '0' THEN 'RUC'
      WHEN tp.tipo_doc = '2' THEN 'DNI'
  END                                                     AS tipo_doc,
  tp.nume_doc,
  COALESCE(tp.tipo_persona, '0')                          AS tipo_persona,
  CASE
      WHEN tp.tipo_persona = '1' THEN 'PERSONA NATURAL'
      WHEN tp.tipo_persona = '2' THEN 'PERSONA JURIDICA'
  END                                                     AS persona,
  CASE
      WHEN tp.tipo_persona = '1' THEN tp.ape_paterno || ' ' || tp.ape_materno || ' ' || tp.nombres
      WHEN tp.tipo_persona = '2' THEN tp.razon_social
  END                                                     AS ciudadano_razon_social,
  ap.codi_actividad,
  a.geom
FROM geo.tg_lote a
LEFT JOIN ficha_principal fp      ON a.id_lote = fp.id_lote
LEFT JOIN titular_principal tp    ON fp.id_ficha = tp.id_ficha
LEFT JOIN actividad_principal ap  ON fp.id_ficha = ap.id_ficha
ORDER BY a.gid;

--SELECT * FROM geo.v_actividad_economica;