-- ============================================================
-- REPORTE: LOTES CON Y SIN PROPIETARIO
-- Cruza geo.tg_lote con catastro (fichas individuales +
-- fichas de cotitularidad) para determinar qué lotes tienen
-- propietario registrado y cuáles no.
-- ============================================================


-- ============================================================
-- 1. RESUMEN GENERAL
--    Total de lotes, cuántos tienen propietario y cuántos no.
-- ============================================================
SELECT
    COUNT(*)                                                        AS total_lotes,
    COUNT(*) FILTER (WHERE tiene_propietario)                       AS lotes_con_propietario,
    COUNT(*) FILTER (WHERE NOT tiene_propietario)                   AS lotes_sin_propietario,
    ROUND(
        COUNT(*) FILTER (WHERE tiene_propietario) * 100.0 / COUNT(*), 2
    )                                                               AS porcentaje_con_propietario
FROM (
    SELECT
        l.id_lote,
        EXISTS (
            SELECT 1
            FROM catastro.tf_fichas      f
            JOIN catastro.tf_titulares   t  ON t.id_ficha   = f.id_ficha
            JOIN catastro.tf_personas    p  ON p.id_persona = t.id_persona
            WHERE f.id_lote = l.id_lote
              AND (p.nume_doc IS NOT NULL OR p.razon_social IS NOT NULL)
        ) AS tiene_propietario
    FROM geo.tg_lote l
) sub;


-- ============================================================
-- 2. RESUMEN POR TIPO DE FICHA
--    Lotes con: solo ficha individual, solo cotitularidad,
--    ambas, o ninguna.
-- ============================================================
SELECT
    CASE
        WHEN tiene_individual AND tiene_cotitularidad THEN 'Individual + Cotitularidad'
        WHEN tiene_individual                         THEN 'Solo Individual'
        WHEN tiene_cotitularidad                      THEN 'Solo Cotitularidad'
        ELSE                                               'Sin ficha'
    END                             AS tipo_cobertura,
    COUNT(*)                        AS cantidad_lotes
FROM (
    SELECT
        l.id_lote,
        EXISTS (
            SELECT 1
            FROM catastro.tf_fichas             f
            JOIN catastro.tf_fichas_individuales fi ON fi.id_ficha = f.id_ficha
            WHERE f.id_lote = l.id_lote
        ) AS tiene_individual,
        EXISTS (
            SELECT 1
            FROM catastro.tf_fichas              f
            JOIN catastro.tf_fichas_cotitularidades fc ON fc.id_ficha = f.id_ficha
            WHERE f.id_lote = l.id_lote
        ) AS tiene_cotitularidad
    FROM geo.tg_lote l
) sub
GROUP BY tipo_cobertura
ORDER BY cantidad_lotes DESC;


-- ============================================================
-- 3. DETALLE POR LOTE
--    Cada lote con su estado, tipo de ficha y número de
--    propietarios registrados.
-- ============================================================
SELECT
    l.id_lote,
    l.id_ubigeo,
    l.id_sector,
    l.id_mzna,
    l.cod_lote,
    l.area_grafi,
    -- Tipo de ficha presente
    CASE
        WHEN fi_cnt.total > 0 AND fc_cnt.total > 0 THEN 'Individual + Cotitularidad'
        WHEN fi_cnt.total > 0                       THEN 'Individual'
        WHEN fc_cnt.total > 0                       THEN 'Cotitularidad'
        ELSE                                             'Sin ficha'
    END                                                         AS tipo_ficha,
    COALESCE(fi_cnt.total, 0)                                   AS fichas_individuales,
    COALESCE(fc_cnt.total, 0)                                   AS fichas_cotitularidad,
    COALESCE(prop.total_propietarios, 0)                        AS total_propietarios,
    CASE
        WHEN COALESCE(prop.total_propietarios, 0) > 0 THEN 'CON PROPIETARIO'
        ELSE                                               'SIN PROPIETARIO'
    END                                                         AS estado_propietario
FROM geo.tg_lote l

-- Fichas individuales ligadas al lote
LEFT JOIN (
    SELECT f.id_lote, COUNT(*) AS total
    FROM catastro.tf_fichas f
    JOIN catastro.tf_fichas_individuales fi ON fi.id_ficha = f.id_ficha
    GROUP BY f.id_lote
) fi_cnt ON fi_cnt.id_lote = l.id_lote

-- Fichas de cotitularidad ligadas al lote
LEFT JOIN (
    SELECT f.id_lote, COUNT(*) AS total
    FROM catastro.tf_fichas f
    JOIN catastro.tf_fichas_cotitularidades fc ON fc.id_ficha = f.id_ficha
    GROUP BY f.id_lote
) fc_cnt ON fc_cnt.id_lote = l.id_lote

-- Total de propietarios únicos (de ambos tipos de ficha)
LEFT JOIN (
    SELECT f.id_lote, COUNT(DISTINCT t.id_persona) AS total_propietarios
    FROM catastro.tf_fichas    f
    JOIN catastro.tf_titulares t  ON t.id_ficha   = f.id_ficha
    JOIN catastro.tf_personas  p  ON p.id_persona = t.id_persona
    WHERE p.nume_doc IS NOT NULL
       OR p.razon_social IS NOT NULL
    GROUP BY f.id_lote
) prop ON prop.id_lote = l.id_lote

ORDER BY
    estado_propietario DESC,
    l.id_sector,
    l.id_mzna,
    l.cod_lote;


-- ============================================================
-- 4. RESUMEN POR SECTOR
--    Agrupado por sector: total lotes, con y sin propietario.
-- ============================================================
SELECT
    l.id_sector,
    COUNT(*)                                                        AS total_lotes,
    COUNT(*) FILTER (WHERE COALESCE(prop.total_propietarios,0) > 0) AS con_propietario,
    COUNT(*) FILTER (WHERE COALESCE(prop.total_propietarios,0) = 0) AS sin_propietario,
    ROUND(
        COUNT(*) FILTER (WHERE COALESCE(prop.total_propietarios,0) > 0) * 100.0 / COUNT(*), 2
    )                                                               AS porcentaje_cubierto
FROM geo.tg_lote l
LEFT JOIN (
    SELECT f.id_lote, COUNT(DISTINCT t.id_persona) AS total_propietarios
    FROM catastro.tf_fichas    f
    JOIN catastro.tf_titulares t ON t.id_ficha   = f.id_ficha
    JOIN catastro.tf_personas  p ON p.id_persona = t.id_persona
    WHERE p.nume_doc IS NOT NULL
       OR p.razon_social IS NOT NULL
    GROUP BY f.id_lote
) prop ON prop.id_lote = l.id_lote
GROUP BY l.id_sector
ORDER BY sin_propietario DESC;
