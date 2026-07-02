-- Table: catastro.tf_backup_config

-- DROP TABLE IF EXISTS catastro.tf_backup_config;

CREATE TABLE IF NOT EXISTS catastro.tf_backup_config
(
    id serial,
    ruta_destino character varying(500) COLLATE pg_catalog."default" NOT NULL,
    frecuencia_tipo character varying(20) COLLATE pg_catalog."default" NOT NULL,
    hora_backup time without time zone NOT NULL,
    activo boolean NOT NULL,
    fecha_creacion timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    CONSTRAINT tf_backup_config_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS catastro.tf_backup_config
    OWNER to kaypacha;


    -- Table: catastro.tf_backup_log

-- DROP TABLE IF EXISTS catastro.tf_backup_log;

CREATE TABLE IF NOT EXISTS catastro.tf_backup_log
(
    id serial,
    fecha_backup timestamp without time zone,
    esquema character varying(20) COLLATE pg_catalog."default" NOT NULL,
    exitoso boolean NOT NULL,
    ruta_archivo character varying(500) COLLATE pg_catalog."default",
    mensaje text COLLATE pg_catalog."default",
    tamano_bytes bigint,
    duracion_segundos double precision,
    CONSTRAINT tf_backup_log_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS catastro.tf_backup_log
    OWNER to kaypacha;