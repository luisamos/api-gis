--
-- FECHA DE CREACIÓN 	: 22/10/2024
-- FECHA DE MODIFICACIÓN: 02/11/2024
--

-- Table: geo.tg_sectores
DROP TABLE IF EXISTS geo.tg_sectores;
CREATE TABLE IF NOT EXISTS geo.tg_sectores
(
    gid serial,
    cod_sector character varying(2),
    id_ubigeo character varying(6),
    id_sector character varying(8),
    area_grafi numeric,
    CONSTRAINT tg_sectores_pkey PRIMARY KEY (gid)
)
TABLESPACE pg_default;

SELECT AddGeometryColumn('geo','tg_sectores','geom','32719','Polygon',2);
SELECT AddGeometryColumn('geo','tg_sectores','geom1','32719','MultiLineString',2);

ALTER TABLE IF EXISTS geo.tg_sectores
    OWNER to postgres;
	
DROP INDEX IF EXISTS geo.tg_sectores_geom_idx;
CREATE INDEX IF NOT EXISTS tg_sectores_geom_idx
    ON geo.tg_sectores USING gist
    (geom)
    TABLESPACE pg_default;
	
-- Table: geo.tg_manzana
DROP TABLE IF EXISTS geo.tg_manzana;
CREATE TABLE IF NOT EXISTS geo.tg_manzana
(
    gid serial,
    cod_sector character varying(2),
    id_ubigeo character varying(6),
    id_sector character varying(8),
    cod_mzna character varying(3),
    id_mzna character varying(11),
    area_grafi numeric,
    peri_grafi numeric,
    fech_actua date,
    CONSTRAINT tg_manzana_pkey PRIMARY KEY (gid)
)
TABLESPACE pg_default;

SELECT AddGeometryColumn('geo','tg_manzana','geom','32719','MultiPolygon',2);

ALTER TABLE IF EXISTS geo.tg_manzana
    OWNER to postgres;

DROP INDEX IF EXISTS geo.tg_manzana_geom_idx;
CREATE INDEX IF NOT EXISTS tg_manzana_geom_idx
    ON geo.tg_manzana USING gist
    (geom)
    TABLESPACE pg_default;

-- Table: geo.tg_lote

DROP TABLE IF EXISTS geo.tg_lote;
CREATE TABLE IF NOT EXISTS geo.tg_lote
(
    gid serial,
    cod_sector character varying(2),
    id_ubigeo character varying(6),
    id_sector character varying(8),
    cod_mzna character varying(3),
    id_mzna character varying(11),
    cod_lote character varying(3),
    id_lote character varying(14),
    area_grafi double precision,
    peri_grafi double precision,
    fech_actua date,
    cuc character varying(12),
    CONSTRAINT tg_lote_pkey PRIMARY KEY (gid)
)
WITH (OIDS = FALSE)
TABLESPACE pg_default;

SELECT AddGeometryColumn('geo','tg_lote','geom','32719','Polygon',2);

ALTER TABLE IF EXISTS geo.tg_lote
    OWNER to postgres;

DROP INDEX IF EXISTS geo.tg_lote_geom_idx;
CREATE INDEX IF NOT EXISTS tg_lote_geom_idx
    ON geo.tg_lote USING gist
    (geom)
    TABLESPACE pg_default;

-- Table: geo.tg_hab_urb
DROP TABLE IF EXISTS geo.tg_hab_urb;
CREATE TABLE IF NOT EXISTS geo.tg_hab_urb
(
    gid serial,
    area_grafi double precision,
    peri_grafi double precision,
    id_hab_urb character varying(10),
	fech_actua date,
	tipo_habilita character varying(6),
	nomb_habilita character varying(254),
    etap_habilita character varying(200),
    expediente character varying(200), 
    CONSTRAINT tg_hab_urb_pkey PRIMARY KEY (gid)
)
WITH (OIDS = FALSE)
TABLESPACE pg_default;

SELECT AddGeometryColumn('geo','tg_hab_urb','geom','32719','Polygon',2);

ALTER TABLE IF EXISTS geo.tg_hab_urb
    OWNER to postgres;

DROP INDEX IF EXISTS geo.tg_hab_urb_geom_idx;
CREATE INDEX IF NOT EXISTS tg_hab_urb_geom_idx
    ON geo.tg_hab_urb USING gist
    (geom)
    TABLESPACE pg_default;

