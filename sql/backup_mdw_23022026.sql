--
-- PostgreSQL database dump
--

\restrict ZOpf0WltR96KmvbTfJ6NWFXFkf9ahjWWMsxnUjFGPlh18SOhIhJJfmNuAnptgJS

-- Dumped from database version 16.12
-- Dumped by pg_dump version 16.12

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: catastro; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA catastro;


ALTER SCHEMA catastro OWNER TO postgres;

--
-- Name: geo; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA geo;


ALTER SCHEMA geo OWNER TO postgres;

--
-- Name: ign; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA ign;


ALTER SCHEMA ign OWNER TO postgres;

--
-- Name: sbn; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA sbn;


ALTER SCHEMA sbn OWNER TO postgres;

--
-- Name: tmp; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tmp;


ALTER SCHEMA tmp OWNER TO postgres;

--
-- Name: vinculacion; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA vinculacion;


ALTER SCHEMA vinculacion OWNER TO postgres;

--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- Name: calcular_digito_control(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calcular_digito_control(texto text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    suma INTEGER := 0;
    i INTEGER;
    digito INTEGER;
BEGIN
    FOR i IN 1..length(texto) LOOP
        digito := CAST(SUBSTRING(texto, i, 1) AS INTEGER);
        suma := suma + digito;
        IF suma >= 9 THEN
            suma := suma - 9;
        END IF;
    END LOOP;
    RETURN suma;
END;
$$;


ALTER FUNCTION public.calcular_digito_control(texto text) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: archivos; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.archivos (
    id bigint NOT NULL,
    imagen1 character varying(255),
    imagen2 character varying(255),
    imagen3 character varying(255),
    rentas character varying(255),
    sunarp character varying(255),
    plano character varying(255),
    id_ficha character varying(19) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE catastro.archivos OWNER TO postgres;

--
-- Name: archivos_id_seq; Type: SEQUENCE; Schema: catastro; Owner: postgres
--

CREATE SEQUENCE catastro.archivos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catastro.archivos_id_seq OWNER TO postgres;

--
-- Name: archivos_id_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.archivos_id_seq OWNED BY catastro.archivos.id;


--
-- Name: audits; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.audits (
    id bigint NOT NULL,
    user_type character varying(255),
    user_id bigint,
    event character varying(255) NOT NULL,
    auditable_type text NOT NULL,
    auditable_id text NOT NULL,
    old_values text,
    new_values text,
    url text,
    ip_address inet,
    user_agent character varying(1023),
    tags character varying(255),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE catastro.audits OWNER TO postgres;

--
-- Name: audits_id_seq; Type: SEQUENCE; Schema: catastro; Owner: postgres
--

CREATE SEQUENCE catastro.audits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catastro.audits_id_seq OWNER TO postgres;

--
-- Name: audits_id_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.audits_id_seq OWNED BY catastro.audits.id;


--
-- Name: c_hoja_informativas; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.c_hoja_informativas (
    id bigint NOT NULL,
    id_ficha character varying(19) NOT NULL,
    ubicacion text NOT NULL,
    fecha_generacion date,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE catastro.c_hoja_informativas OWNER TO postgres;

--
-- Name: c_hoja_informativas_id_seq; Type: SEQUENCE; Schema: catastro; Owner: postgres
--

CREATE SEQUENCE catastro.c_hoja_informativas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catastro.c_hoja_informativas_id_seq OWNER TO postgres;

--
-- Name: c_hoja_informativas_id_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.c_hoja_informativas_id_seq OWNED BY catastro.c_hoja_informativas.id;


--
-- Name: c_numeracions; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.c_numeracions (
    id bigint NOT NULL,
    id_ficha character varying(19) NOT NULL,
    ubicacion text NOT NULL,
    fecha_generacion date,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE catastro.c_numeracions OWNER TO postgres;

--
-- Name: c_numeracions_id_seq; Type: SEQUENCE; Schema: catastro; Owner: postgres
--

CREATE SEQUENCE catastro.c_numeracions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catastro.c_numeracions_id_seq OWNER TO postgres;

--
-- Name: c_numeracions_id_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.c_numeracions_id_seq OWNED BY catastro.c_numeracions.id;


--
-- Name: construccion_certificados; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.construccion_certificados (
    id bigint NOT NULL,
    codi_construccion integer,
    nume_piso character varying(2),
    fecha date,
    mep character varying(2),
    ecs character varying(2),
    ecc character varying(2),
    estr_muro_col character varying(1),
    estr_techo character varying(1),
    acab_piso character varying(1),
    acab_puerta_ven character varying(1),
    acab_revest character varying(1),
    acab_bano character varying(1),
    inst_elect_sanita character varying(1),
    area_declarada numeric(8,2),
    area_verificada numeric(8,2),
    uca character varying(2),
    bloque character varying(2),
    certificado_id bigint
);


ALTER TABLE catastro.construccion_certificados OWNER TO postgres;

--
-- Name: construccion_certificados_id_seq; Type: SEQUENCE; Schema: catastro; Owner: postgres
--

CREATE SEQUENCE catastro.construccion_certificados_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catastro.construccion_certificados_id_seq OWNER TO postgres;

--
-- Name: construccion_certificados_id_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.construccion_certificados_id_seq OWNED BY catastro.construccion_certificados.id;


--
-- Name: cuc07; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.cuc07 (
    id_lote character varying(14),
    cuc character varying(12)
);


ALTER TABLE catastro.cuc07 OWNER TO postgres;

--
-- Name: cuc08; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.cuc08 (
    id_lote character varying(14),
    cuc character varying(12)
);


ALTER TABLE catastro.cuc08 OWNER TO postgres;

--
-- Name: failed_jobs; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE catastro.failed_jobs OWNER TO postgres;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: catastro; Owner: postgres
--

CREATE SEQUENCE catastro.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catastro.failed_jobs_id_seq OWNER TO postgres;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.failed_jobs_id_seq OWNED BY catastro.failed_jobs.id;


--
-- Name: generar_certificados; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.generar_certificados (
    id bigint NOT NULL,
    id_uni_cat character varying(23) NOT NULL,
    dc character varying(1),
    area_declarada numeric(7,2),
    area_verificada numeric(7,2),
    porc_bc_terr_legal numeric(7,2),
    porc_bc_terr_fisc numeric(7,2),
    clasificacion character varying(4),
    codi_uso character varying(6) NOT NULL,
    tipo_edificacion character varying(15),
    cont_en character varying(2),
    fren_campo character varying(20),
    fren_colinda_campo character varying(20),
    dere_campo character varying(20),
    dere_colinda_campo character varying(20),
    izqu_campo character varying(20),
    izqu_colinda_campo character varying(20),
    fond_campo character varying(20),
    fond_colinda_campo character varying(20),
    nombresolicitud text,
    observaciones text,
    id_ficha character varying(19) NOT NULL,
    fecha_emision date NOT NULL,
    id_usuario bigint NOT NULL
);


ALTER TABLE catastro.generar_certificados OWNER TO postgres;

--
-- Name: generar_certificados_id_seq; Type: SEQUENCE; Schema: catastro; Owner: postgres
--

CREATE SEQUENCE catastro.generar_certificados_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catastro.generar_certificados_id_seq OWNER TO postgres;

--
-- Name: generar_certificados_id_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.generar_certificados_id_seq OWNED BY catastro.generar_certificados.id;


--
-- Name: generar_numeracions; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.generar_numeracions (
    id bigint NOT NULL,
    id_uni_cat character varying(23) NOT NULL,
    dc character varying(1),
    area_declarada numeric(7,2),
    area_verificada numeric(7,2),
    porc_bc_terr_legal numeric(7,2),
    porc_bc_terr_fisc numeric(7,2),
    numeracion character varying(15),
    clasificacion character varying(4),
    codi_uso character varying(6) NOT NULL,
    tipo_edificacion character varying(15),
    cont_en character varying(2),
    observaciones text,
    id_ficha character varying(19) NOT NULL,
    fecha_emision date NOT NULL,
    id_usuario bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE catastro.generar_numeracions OWNER TO postgres;

--
-- Name: generar_numeracions_id_seq; Type: SEQUENCE; Schema: catastro; Owner: postgres
--

CREATE SEQUENCE catastro.generar_numeracions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catastro.generar_numeracions_id_seq OWNER TO postgres;

--
-- Name: generar_numeracions_id_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.generar_numeracions_id_seq OWNED BY catastro.generar_numeracions.id;


--
-- Name: imagenes; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.imagenes (
    id bigint NOT NULL,
    imagenfachada character varying(255),
    imagenmapa character varying(255),
    id_lote character varying(19) NOT NULL,
    id_usuario bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE catastro.imagenes OWNER TO postgres;

--
-- Name: imagenes_id_seq; Type: SEQUENCE; Schema: catastro; Owner: postgres
--

CREATE SEQUENCE catastro.imagenes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catastro.imagenes_id_seq OWNER TO postgres;

--
-- Name: imagenes_id_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.imagenes_id_seq OWNED BY catastro.imagenes.id;


--
-- Name: migrations; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE catastro.migrations OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: catastro; Owner: postgres
--

CREATE SEQUENCE catastro.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catastro.migrations_id_seq OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.migrations_id_seq OWNED BY catastro.migrations.id;


--
-- Name: model_has_permissions; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.model_has_permissions (
    permission_id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL
);


ALTER TABLE catastro.model_has_permissions OWNER TO postgres;

--
-- Name: model_has_roles; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.model_has_roles (
    role_id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL
);


ALTER TABLE catastro.model_has_roles OWNER TO postgres;

--
-- Name: password_resets; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.password_resets (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


ALTER TABLE catastro.password_resets OWNER TO postgres;

--
-- Name: permissions; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.permissions (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    guard_name character varying(255) NOT NULL,
    categoria character varying(255),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE catastro.permissions OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: catastro; Owner: postgres
--

CREATE SEQUENCE catastro.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catastro.permissions_id_seq OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.permissions_id_seq OWNED BY catastro.permissions.id;


--
-- Name: personal_access_tokens; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.personal_access_tokens (
    id bigint NOT NULL,
    tokenable_type character varying(255) NOT NULL,
    tokenable_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    token character varying(64) NOT NULL,
    abilities text,
    last_used_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE catastro.personal_access_tokens OWNER TO postgres;

--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE; Schema: catastro; Owner: postgres
--

CREATE SEQUENCE catastro.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catastro.personal_access_tokens_id_seq OWNER TO postgres;

--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.personal_access_tokens_id_seq OWNED BY catastro.personal_access_tokens.id;


--
-- Name: role_has_permissions; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.role_has_permissions (
    permission_id bigint NOT NULL,
    role_id bigint NOT NULL
);


ALTER TABLE catastro.role_has_permissions OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.roles (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    guard_name character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE catastro.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: catastro; Owner: postgres
--

CREATE SEQUENCE catastro.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catastro.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.roles_id_seq OWNED BY catastro.roles.id;


--
-- Name: tf_actividades; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_actividades (
    codi_actividad character varying(6) NOT NULL,
    desc_actividad character varying(150)
);


ALTER TABLE catastro.tf_actividades OWNER TO postgres;

--
-- Name: tf_afectacion_antropica; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_afectacion_antropica (
    id_ficha character varying(19) NOT NULL,
    codigo character varying(2),
    descripcion character varying(100)
);


ALTER TABLE catastro.tf_afectacion_antropica OWNER TO postgres;

--
-- Name: tf_afectacion_natural; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_afectacion_natural (
    id_ficha character varying(19) NOT NULL,
    codigo character varying(2),
    descripcion character varying(100)
);


ALTER TABLE catastro.tf_afectacion_natural OWNER TO postgres;

--
-- Name: tf_agricola_predio; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_agricola_predio (
    id_ficha character varying(19) NOT NULL,
    tipo_agricola character varying(2),
    area_agricola integer,
    descripcion_agricola character varying(20),
    grupo_agricola_campo character varying(1),
    clase_agricola_campo character varying(2),
    area_agricola_campo integer,
    grupo_agricola_tierras character varying(1),
    clase_agricola_tierras character varying(2),
    area_agricola_tierras integer,
    numero_plantas integer
);


ALTER TABLE catastro.tf_agricola_predio OWNER TO postgres;

--
-- Name: tf_autorizaciones_anuncios; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_autorizaciones_anuncios (
    id_anuncio character varying(25) NOT NULL,
    id_ficha character varying(19) NOT NULL,
    codi_autoriza integer,
    codi_anuncio character varying(3),
    nume_lados integer,
    area_autorizada numeric(7,2),
    area_verificada numeric(7,2),
    nume_expediente character varying(10),
    nume_licencia character varying(10),
    fecha_expedicion date,
    fecha_vencimiento date,
    descripcion character varying(250)
);


ALTER TABLE catastro.tf_autorizaciones_anuncios OWNER TO postgres;

--
-- Name: tf_autorizaciones_funcionamiento; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_autorizaciones_funcionamiento (
    codi_actividad character varying(6) NOT NULL,
    id_ficha character varying(19) NOT NULL
);


ALTER TABLE catastro.tf_autorizaciones_funcionamiento OWNER TO postgres;

--
-- Name: tf_caracteristicas_rural; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_caracteristicas_rural (
    id_ficha character varying(19) NOT NULL,
    area_terreno numeric(7,2),
    area_decl numeric(7,2),
    vivienda character varying(1),
    establo character varying(1),
    corral character varying(1),
    galpon character varying(1),
    invernadero character varying(1),
    reservorio character varying(1),
    deposito character varying(1),
    zona_arque character varying(1),
    otros character varying(1)
);


ALTER TABLE catastro.tf_caracteristicas_rural OWNER TO postgres;

--
-- Name: tf_codigos_instalaciones; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_codigos_instalaciones (
    codi_instalacion character varying(2) NOT NULL,
    desc_instalacion character varying(50),
    material character varying(50),
    unidad character varying(30)
);


ALTER TABLE catastro.tf_codigos_instalaciones OWNER TO postgres;

--
-- Name: tf_colonial; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_colonial (
    id_ficha character varying(19) NOT NULL,
    inmueble_declarado character varying(2),
    nombre_colonial character varying(150),
    tipo_arquitectura character varying(2),
    uso_actual character varying(100),
    uso_original character varying(100),
    num_pisos character varying(5),
    tipo_fecha character varying(1),
    fecha_construccion character varying(4),
    observaciones character varying(500)
);


ALTER TABLE catastro.tf_colonial OWNER TO postgres;

--
-- Name: tf_condicion_predio; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_condicion_predio (
    id_ficha character varying(19) NOT NULL,
    cond_titular character varying(2),
    fecha_ini date,
    insc_rrpp character varying(2),
    num_part integer,
    fecha_insc date,
    doc_propiedad character varying(2),
    fecha_adq date
);


ALTER TABLE catastro.tf_condicion_predio OWNER TO postgres;

--
-- Name: tf_conductores; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_conductores (
    id_ficha character varying(19) NOT NULL,
    id_persona character varying(21) NOT NULL,
    fax character varying(10),
    telefono character varying(10),
    anexo character varying(5),
    email character varying(100),
    cond_conductor character varying(18),
    nume_ruc character varying(11)
);


ALTER TABLE catastro.tf_conductores OWNER TO postgres;

--
-- Name: tf_construcciones; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_construcciones (
    id_construccion character varying(25) NOT NULL,
    id_ficha character varying(19) NOT NULL,
    codi_construccion integer,
    nume_piso character varying(2),
    fecha date,
    mep character varying(2),
    ecs character varying(2),
    ecc character varying(2),
    estr_muro_col character varying(1),
    estr_techo character varying(1),
    acab_piso character varying(1),
    acab_puerta_ven character varying(1),
    acab_revest character varying(1),
    acab_bano character varying(1),
    inst_elect_sanita character varying(1),
    area_declarada numeric(8,2),
    area_verificada numeric(8,2),
    uca character varying(2),
    bloque character varying(2)
);


ALTER TABLE catastro.tf_construcciones OWNER TO postgres;

--
-- Name: tf_documento_posesion; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_documento_posesion (
    id_ficha character varying(19) NOT NULL,
    pru_ob1 character varying(1),
    pru_ob2 character varying(1),
    pru_ob3 character varying(1),
    pru_comp1 character varying(2),
    pru_comp2 character varying(2),
    pru_comp3 character varying(2),
    pru_comp4 character varying(2),
    pru_comp5 character varying(2),
    pru_comp6 character varying(2),
    pru_comp7 character varying(2),
    pru_comp8 character varying(2),
    pru_comp9 character varying(2),
    pru_comp10 character varying(2),
    pru_comp11 character varying(2),
    pru_comp12 character varying(2),
    pru_comp13 character varying(2),
    pru_comp14 character varying(2),
    pru_comp15 character varying(2)
);


ALTER TABLE catastro.tf_documento_posesion OWNER TO postgres;

--
-- Name: tf_documentos_adjuntos; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_documentos_adjuntos (
    id_doc character varying(21) NOT NULL,
    id_ficha character varying(19) NOT NULL,
    codi_doc integer,
    tipo_doc character varying(2),
    nume_doc character varying(50),
    area_autorizada numeric(7,2),
    fecha_doc date,
    url_doc character varying(250)
);


ALTER TABLE catastro.tf_documentos_adjuntos OWNER TO postgres;

--
-- Name: tf_domicilio_titulares; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_domicilio_titulares (
    id_ficha character varying(19) NOT NULL,
    id_persona character varying(21) NOT NULL,
    codi_via character varying(6),
    tipo_via character varying(5),
    nomb_via character varying(100),
    nume_muni character varying(6),
    nomb_edificacion character varying(100),
    nume_interior character varying(20),
    codi_hab_urba character varying(4),
    nomb_hab_urba character varying(100),
    sector character varying(50),
    mzna character varying(5),
    lote character varying(5),
    sublote character varying(5),
    codi_dep character varying(2),
    codi_pro character varying(2),
    codi_dis character varying(2),
    ubicacion character varying(2)
);


ALTER TABLE catastro.tf_domicilio_titulares OWNER TO postgres;

--
-- Name: tf_edificaciones; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_edificaciones (
    id_edificacion character varying(16) NOT NULL,
    id_lote character varying(14) NOT NULL,
    codi_edificacion character varying(3) NOT NULL,
    tipo_edificacion character varying(15),
    nomb_edificacion character varying(15),
    clasificacion character varying(4)
);


ALTER TABLE catastro.tf_edificaciones OWNER TO postgres;

--
-- Name: tf_elemento_arquitectonico; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_elemento_arquitectonico (
    id_ficha character varying(19) NOT NULL,
    codigo character varying(2),
    descripcion character varying(100)
);


ALTER TABLE catastro.tf_elemento_arquitectonico OWNER TO postgres;

--
-- Name: tf_estado_elemento; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_estado_elemento (
    id_ficha character varying(19) NOT NULL,
    cimientos character varying(1),
    muros character varying(1),
    pisos character varying(1),
    techos character varying(1),
    pilastras character varying(1),
    revestimiento character varying(1),
    balcones character varying(1),
    puertas character varying(1),
    ventanas character varying(1),
    rejas character varying(1),
    otros character varying(1)
);


ALTER TABLE catastro.tf_estado_elemento OWNER TO postgres;

--
-- Name: tf_exoneraciones_predio; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_exoneraciones_predio (
    id_ficha character varying(19) NOT NULL,
    condicion character varying(2),
    nume_resolucion character varying(20),
    porcentaje numeric(7,2),
    fecha_inicio date,
    fecha_vencimiento date
);


ALTER TABLE catastro.tf_exoneraciones_predio OWNER TO postgres;

--
-- Name: tf_exoneraciones_titular; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_exoneraciones_titular (
    id_ficha character varying(19) NOT NULL,
    id_persona character varying(21) NOT NULL,
    condicion character varying(2),
    nume_resolucion character varying(20),
    nume_boleta_pension character varying(20),
    fecha_inicio date,
    fecha_vencimiento date
);


ALTER TABLE catastro.tf_exoneraciones_titular OWNER TO postgres;

--
-- Name: tf_ficha_bien_cultural; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_ficha_bien_cultural (
    id_ficha character varying(19) NOT NULL,
    area_titulo numeric(7,2),
    area_construido numeric(7,2),
    area_libre numeric(7,2),
    descripcion_fachada character varying(350),
    descripcion_interior character varying(350),
    filiacion_estilistica character varying(2),
    intervencion_inmueble character varying(2),
    resena_historica character varying(350),
    cond_declarante character varying(2),
    esta_llenado character varying(1),
    nume_habitantes integer,
    nume_familias integer,
    nume_ficha character varying(7),
    crc_rural character varying(20)
);


ALTER TABLE catastro.tf_ficha_bien_cultural OWNER TO postgres;

--
-- Name: tf_ficha_rural; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_ficha_rural (
    id_ficha character varying(19) NOT NULL,
    cuc character varying(15),
    codigo_hoja_catastral character varying(15),
    codigo_contr_rentas character varying(15),
    codigo_predial character varying(15),
    unidad_organica character varying(15),
    unidad_catastral character varying(15),
    cod_pro character varying(2),
    cod_dep character varying(2),
    cod_dis character varying(2),
    proy_cat character varying(75),
    uni_terr character varying(75),
    nomb_valle character varying(75),
    nomb_sector character varying(75),
    nomb_predio character varying(75),
    num_foto character varying(175),
    num_ortofoto character varying(175),
    img_satelital character varying(175),
    uca_ant character varying(75),
    cord_este character varying(75),
    cord_norte character varying(75),
    datum character varying(75),
    zona character varying(75),
    codi_uso character varying(2),
    clasi_uso character varying(2),
    riego character varying(2),
    derecho_agua character varying(2),
    fuente_hidrica character varying(2),
    cercania_rio character varying(2),
    cumple_explotacion character varying(2),
    llenada_intervension character varying(2),
    observaciones character varying(500),
    nume_ficha character varying(7),
    zona_geografica character varying(2)
);


ALTER TABLE catastro.tf_ficha_rural OWNER TO postgres;

--
-- Name: tf_fichas; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_fichas (
    id_ficha character varying(19) NOT NULL,
    tipo_ficha character varying(2),
    nume_ficha character varying(10),
    id_lote character varying(14),
    dc character varying(1),
    nume_ficha_lote character varying(9),
    id_declarante character varying(21),
    fecha_declarante date,
    id_supervisor character varying(21),
    fecha_supervision date,
    id_tecnico character varying(21),
    fecha_levantamiento date,
    id_verificador character varying(21),
    fecha_verificacion date,
    nume_registro character varying(10),
    id_uni_cat character varying(23) NOT NULL,
    id_usuario bigint NOT NULL,
    fecha_grabado timestamp(0) without time zone,
    activo character varying(1)
);


ALTER TABLE catastro.tf_fichas OWNER TO postgres;

--
-- Name: tf_fichas_bienes_comunes; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_fichas_bienes_comunes (
    id_ficha character varying(19) NOT NULL,
    cont_en character varying(2),
    clasificacion character varying(4),
    area_titulo numeric(7,2),
    area_declarada numeric(7,2),
    area_verificada numeric(7,2),
    en_colindante numeric(7,2),
    en_jardin_aislamiento numeric(7,2),
    en_area_publica numeric(7,2),
    en_area_intangible numeric(7,2),
    cond_declarante character varying(2),
    esta_llenado character varying(1),
    mantenimiento character varying(2),
    observaciones text,
    codi_uso character varying(6) NOT NULL,
    nume_ficha character varying(7)
);


ALTER TABLE catastro.tf_fichas_bienes_comunes OWNER TO postgres;

--
-- Name: tf_fichas_cotitularidades; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_fichas_cotitularidades (
    id_ficha character varying(19) NOT NULL,
    cond_declarante character varying(2),
    esta_llenado character varying(1),
    observaciones text,
    nume_ficha character varying(7)
);


ALTER TABLE catastro.tf_fichas_cotitularidades OWNER TO postgres;

--
-- Name: tf_fichas_economicas; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_fichas_economicas (
    id_ficha character varying(19) NOT NULL,
    nomb_comercial character varying(100),
    pred_area_autor numeric(7,2),
    viap_area_autor numeric(7,2),
    viap_area_verif numeric(7,2),
    bc_area_autor numeric(7,2),
    bc_area_verif numeric(7,2),
    nume_expediente character varying(10),
    nume_licencia character varying(10),
    fecha_expedicion date,
    fecha_vencimiento date,
    inic_actividad date,
    cond_declarante character varying(2),
    esta_llenado character varying(1),
    mantenimiento character varying(2),
    docu_presentado character varying(2),
    pred_area_verif numeric(7,2),
    observaciones text,
    nume_ficha character varying(7),
    codigo_secuencial character varying(250)
);


ALTER TABLE catastro.tf_fichas_economicas OWNER TO postgres;

--
-- Name: tf_fichas_individuales; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_fichas_individuales (
    id_ficha character varying(19) NOT NULL,
    codi_uso character varying(6) NOT NULL,
    cont_en character varying(2),
    clasificacion character varying(4),
    area_titulo numeric(15,2),
    area_declarada numeric(15,2),
    area_verificada numeric(15,2),
    porc_bc_terr_legal numeric(8,2),
    porc_bc_terr_fisc numeric(8,2),
    porc_bc_const_legal numeric(8,2),
    porc_bc_const_fisc numeric(8,2),
    evaluacion character varying(2),
    en_colindante numeric(7,2),
    en_jardin_aislamiento numeric(7,2),
    en_area_publica numeric(7,2),
    en_area_intangible numeric(7,2),
    cond_declarante character varying(2),
    esta_llenado character varying(1),
    nume_habitantes integer,
    nume_familias integer,
    mantenimiento character varying(2),
    observaciones text,
    estado_propiedad character varying(10),
    nume_ficha character varying(7),
    imagen_lote character varying(250),
    imagen_plano character varying(250)
);


ALTER TABLE catastro.tf_fichas_individuales OWNER TO postgres;

--
-- Name: tf_ganaderia_rural; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_ganaderia_rural (
    id_ficha character varying(19) NOT NULL,
    tipo_ganaderia character varying(20),
    raza_especio character varying(50),
    cantidad_ganderia integer
);


ALTER TABLE catastro.tf_ganaderia_rural OWNER TO postgres;

--
-- Name: tf_hab_urbana; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_hab_urbana (
    id_hab_urba character varying(10) NOT NULL,
    grup_urba character varying(100),
    tipo_hab_urba character varying(15),
    nomb_hab_urba character varying(100),
    codi_hab_urba character varying(4) NOT NULL,
    id_ubi_geo character varying(255) NOT NULL,
    estado character varying(1) NOT NULL
);


ALTER TABLE catastro.tf_hab_urbana OWNER TO postgres;

--
-- Name: tf_historia_via; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_historia_via (
    id_historia_via bigint NOT NULL,
    nomb_via_ant character varying(100) NOT NULL,
    fecha_his_via date,
    id_via character varying(12) NOT NULL,
    activo character varying(1) NOT NULL
);


ALTER TABLE catastro.tf_historia_via OWNER TO postgres;

--
-- Name: tf_historia_via_id_historia_via_seq; Type: SEQUENCE; Schema: catastro; Owner: postgres
--

CREATE SEQUENCE catastro.tf_historia_via_id_historia_via_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catastro.tf_historia_via_id_historia_via_seq OWNER TO postgres;

--
-- Name: tf_historia_via_id_historia_via_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.tf_historia_via_id_historia_via_seq OWNED BY catastro.tf_historia_via.id_historia_via;


--
-- Name: tf_ingresos; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_ingresos (
    id_ficha character varying(19) NOT NULL,
    id_puerta character varying(19) NOT NULL
);


ALTER TABLE catastro.tf_ingresos OWNER TO postgres;

--
-- Name: tf_instalacion_rural; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_instalacion_rural (
    id_ficha character varying(19) NOT NULL,
    tipo_ins character varying(25),
    cantidad integer,
    area_porcentaje numeric(7,2),
    area_const numeric(7,2),
    volumen numeric(7,2),
    fecha_const date,
    material_est character varying(2),
    estado_conserva character varying(2),
    estado_construc character varying(175)
);


ALTER TABLE catastro.tf_instalacion_rural OWNER TO postgres;

--
-- Name: tf_instalaciones; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_instalaciones (
    id_instalacion character varying(24) NOT NULL,
    id_ficha character varying(19) NOT NULL,
    codi_instalacion character varying(2) NOT NULL,
    codi_obra integer,
    fecha date,
    mep character varying(2),
    ecs character varying(2),
    ecc character varying(2),
    dime_largo numeric(7,2),
    dime_ancho numeric(7,2),
    dime_alto numeric(7,2),
    prod_total numeric(7,2),
    uni_med character varying(10),
    uca character varying(2)
);


ALTER TABLE catastro.tf_instalaciones OWNER TO postgres;

--
-- Name: tf_institucion; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_institucion (
    id_institucion character varying(6) NOT NULL,
    desc_institucion character varying(50),
    dire_institucion character varying(100),
    email character varying(70),
    autoridad character varying(100),
    cargo character varying(50),
    fecha_registro date,
    logo_institucion text NOT NULL,
    logo_catastro text NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE catastro.tf_institucion OWNER TO postgres;

--
-- Name: tf_intervencion; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_intervencion (
    id_ficha character varying(19) NOT NULL,
    codigo character varying(2),
    descripcion character varying(100)
);


ALTER TABLE catastro.tf_intervencion OWNER TO postgres;

--
-- Name: tf_licencias; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_licencias (
    id bigint NOT NULL,
    nroexpediente character varying(255) NOT NULL,
    fecha_emision date NOT NULL,
    fecha_vencimiento date NOT NULL,
    nrolicencia character varying(255),
    administrado1 character varying(255) NOT NULL,
    administrado2 character varying(255),
    propietario character varying(50),
    tipolicencia character varying(255) NOT NULL,
    uso character varying(255) NOT NULL,
    zonificacion character varying(255) NOT NULL,
    alturapisos character varying(255),
    alturametros character varying(6),
    departamento character varying(255) NOT NULL,
    provincia character varying(255) NOT NULL,
    distrito character varying(255) NOT NULL,
    haburbana character varying(255),
    mzna character varying(25),
    lote character varying(25),
    sublote character varying(25),
    calle character varying(25),
    nro character varying(25),
    interior character varying(25),
    areatechada numeric(7,2),
    valorobra numeric(11,2),
    pisosautorizados character varying(255),
    nrosotano integer,
    semisotano integer,
    azotea integer,
    calificacion character varying(255),
    dictamen text NOT NULL,
    licencia text NOT NULL,
    responsable text,
    codresponsable text,
    pagotramite numeric(11,2),
    recibo character varying(255),
    fecha_recibo date,
    observacion text,
    recomendaciones text,
    estado character varying(10) DEFAULT '1'::character varying NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE catastro.tf_licencias OWNER TO postgres;

--
-- Name: tf_licencias_id_seq; Type: SEQUENCE; Schema: catastro; Owner: postgres
--

CREATE SEQUENCE catastro.tf_licencias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catastro.tf_licencias_id_seq OWNER TO postgres;

--
-- Name: tf_licencias_id_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.tf_licencias_id_seq OWNED BY catastro.tf_licencias.id;


--
-- Name: tf_linderos; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_linderos (
    id_ficha character varying(19) NOT NULL,
    fren_campo character varying(200),
    fren_titulo character varying(200),
    fren_colinda_campo character varying(200),
    fren_colinda_titulo character varying(200),
    dere_campo character varying(200),
    dere_titulo character varying(200),
    dere_colinda_campo character varying(200),
    dere_colinda_titulo character varying(200),
    izqu_campo character varying(200),
    izqu_titulo character varying(200),
    izqu_colinda_campo character varying(200),
    izqu_colinda_titulo character varying(200),
    fond_titulo character varying(200),
    fond_campo character varying(200),
    fond_colinda_campo character varying(200),
    fond_colinda_titulo character varying(200)
);


ALTER TABLE catastro.tf_linderos OWNER TO postgres;

--
-- Name: tf_litigantes; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_litigantes (
    id_ficha character varying(19) NOT NULL,
    id_persona character varying(21) NOT NULL,
    codi_contribuye character varying(18)
);


ALTER TABLE catastro.tf_litigantes OWNER TO postgres;

--
-- Name: tf_lotes; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_lotes (
    id_lote character varying(14) NOT NULL,
    id_mzna character varying(11) NOT NULL,
    codi_lote character varying(3) NOT NULL,
    id_hab_urba character varying(10),
    mzna_dist character varying(15),
    lote_dist character varying(15),
    sub_lote_dist character varying(8),
    estructuracion character varying(30),
    zonificacion character varying(100),
    cuc character varying(8),
    zona_dist character varying(15)
);


ALTER TABLE catastro.tf_lotes OWNER TO postgres;

--
-- Name: tf_manzanas; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_manzanas (
    id_mzna character varying(11) NOT NULL,
    id_sector character varying(8) NOT NULL,
    codi_mzna character varying(3) NOT NULL,
    nume_mzna character varying(15),
    estado character varying(1) NOT NULL
);


ALTER TABLE catastro.tf_manzanas OWNER TO postgres;

--
-- Name: tf_monumento; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_monumento (
    id_ficha character varying(19) NOT NULL,
    cat_inmueble character varying(2),
    nomb_monumento character varying(150),
    cod_monumento character varying(15),
    presencia_arquitectura character varying(2),
    filiacion_cronologica character varying(2),
    tipo_area character varying(1),
    area_monu numeric(11,2),
    perimetro_monumento numeric(11,2),
    observaciones character varying(500)
);


ALTER TABLE catastro.tf_monumento OWNER TO postgres;

--
-- Name: tf_norma_legal; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_norma_legal (
    id_ficha character varying(19) NOT NULL,
    normatividad character varying(20),
    fecha_norma date,
    numero_plano character varying(20),
    tipo_norma character varying(1)
);


ALTER TABLE catastro.tf_norma_legal OWNER TO postgres;

--
-- Name: tf_notarias; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_notarias (
    id_notaria character varying(11) NOT NULL,
    codi_notaria integer,
    nomb_notaria character varying(50),
    id_ubi_geo character varying(6) NOT NULL
);


ALTER TABLE catastro.tf_notarias OWNER TO postgres;

--
-- Name: tf_personas; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_personas (
    id_persona character varying(21) NOT NULL,
    nume_doc character varying(17),
    tipo_doc character varying(2),
    tipo_persona character varying(1),
    nombres character varying(150),
    ape_paterno character varying(50),
    ape_materno character varying(50),
    tipo_persona_juridica character varying(2),
    tipo_funcion character varying(1),
    nregistro character varying(7),
    razon_social character varying(100)
);


ALTER TABLE catastro.tf_personas OWNER TO postgres;

--
-- Name: tf_puertas; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_puertas (
    id_puerta character varying(19) NOT NULL,
    id_lote character varying(14) NOT NULL,
    codi_puerta character varying(2),
    tipo_puerta character varying(1),
    nume_muni character varying(20),
    cond_nume character varying(2),
    id_via character varying(12) NOT NULL,
    nume_certificacion character varying(10)
);


ALTER TABLE catastro.tf_puertas OWNER TO postgres;

--
-- Name: tf_recap_bbcc; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_recap_bbcc (
    id_ficha character varying(19) NOT NULL,
    edifica character varying(2),
    entrada character varying(2),
    nume_piso character varying(2),
    unidad character varying(3),
    porcentaje numeric(7,2),
    atc numeric(7,2),
    acc numeric(7,2),
    aoic numeric(7,2),
    nume_registro integer NOT NULL
);


ALTER TABLE catastro.tf_recap_bbcc OWNER TO postgres;

--
-- Name: tf_recap_edificio; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_recap_edificio (
    id_ficha character varying(19) NOT NULL,
    edificio character varying(2),
    total_porcentaje numeric(7,2),
    total_atc numeric(7,2),
    total_acc numeric(7,2),
    total_aoic numeric(7,2),
    id_recap integer
);


ALTER TABLE catastro.tf_recap_edificio OWNER TO postgres;

--
-- Name: tf_registro_legal; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_registro_legal (
    id_ficha character varying(19) NOT NULL,
    id_notaria character varying(11) NOT NULL,
    kardex character varying(20),
    fecha_escritura date
);


ALTER TABLE catastro.tf_registro_legal OWNER TO postgres;

--
-- Name: tf_sectores; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_sectores (
    id_sector character varying(8) NOT NULL,
    id_ubi_geo character varying(6) NOT NULL,
    codi_sector character varying(2) NOT NULL,
    nomb_sector character varying(20),
    fichaindividual integer DEFAULT 0,
    fichacotitular integer DEFAULT 0,
    fichaeconomica integer DEFAULT 0,
    fichabiencomun integer DEFAULT 0,
    fichacultural integer DEFAULT 0,
    ficharural integer DEFAULT 0,
    estado character varying(1) NOT NULL
);


ALTER TABLE catastro.tf_sectores OWNER TO postgres;

--
-- Name: tf_servicios_basicos; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_servicios_basicos (
    id_ficha character varying(19) NOT NULL,
    luz integer,
    agua integer,
    telefono integer,
    desague integer,
    gas integer,
    internet integer,
    tvcable integer
);


ALTER TABLE catastro.tf_servicios_basicos OWNER TO postgres;

--
-- Name: tf_sunarp; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_sunarp (
    id_ficha character varying(19) NOT NULL,
    tipo_partida character varying(2),
    nume_partida character varying(18),
    fojas character varying(18),
    asiento character varying(18),
    fecha_inscripcion date,
    codi_decla_fabrica character varying(2),
    asie_fabrica character varying(18),
    fecha_fabrica date
);


ALTER TABLE catastro.tf_sunarp OWNER TO postgres;

--
-- Name: tf_tablas; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_tablas (
    id_tabla character varying(3) NOT NULL,
    desc_tabla character varying(50),
    ultimo_codigo integer
);


ALTER TABLE catastro.tf_tablas OWNER TO postgres;

--
-- Name: tf_tablas_codigos; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_tablas_codigos (
    codigo character varying(10) NOT NULL,
    id_tabla character varying(3) NOT NULL,
    desc_codigo character varying(80)
);


ALTER TABLE catastro.tf_tablas_codigos OWNER TO postgres;

--
-- Name: tf_titulares; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_titulares (
    id_ficha character varying(19) NOT NULL,
    id_persona character varying(21) NOT NULL,
    form_adquisicion character varying(2),
    fecha_adquisicion date,
    porc_cotitular numeric(7,4),
    esta_civil character varying(2),
    fax character varying(10),
    telf character varying(10),
    anexo character varying(5),
    email character varying(100),
    nume_titular character varying(20),
    codi_contribuyente character varying(10),
    cond_titular character varying(2)
);


ALTER TABLE catastro.tf_titulares OWNER TO postgres;

--
-- Name: tf_ubigeo; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_ubigeo (
    id_ubi_geo character varying(6) NOT NULL,
    nomb_ubigeo character varying(100) NOT NULL,
    cuc_desde character varying(8),
    cuc_hasta character varying(8),
    ultimo_cuc character varying(8),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE catastro.tf_ubigeo OWNER TO postgres;

--
-- Name: tf_uni_cat; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_uni_cat (
    id_uni_cat character varying(23) NOT NULL,
    id_lote character varying(16),
    id_edificacion character varying(255) NOT NULL,
    codi_entrada character varying(2),
    codi_piso character varying(2),
    codi_unidad character varying(3),
    tipo_interior character varying(2),
    cuc character varying(12),
    cuc_antecedente character varying(12),
    codi_hoja_catastral character varying(10),
    codi_pred_rentas character varying(15),
    nume_interior character varying(25),
    unid_acum_rentas character varying(15),
    codi_cont_rentas character varying(15)
);


ALTER TABLE catastro.tf_uni_cat OWNER TO postgres;

--
-- Name: tf_usos; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_usos (
    codi_uso character varying(6) NOT NULL,
    desc_uso character varying(250) NOT NULL
);


ALTER TABLE catastro.tf_usos OWNER TO postgres;

--
-- Name: tf_usos_bc; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_usos_bc (
    codi_uso character varying(6) NOT NULL,
    desc_uso character varying(250) NOT NULL
);


ALTER TABLE catastro.tf_usos_bc OWNER TO postgres;

--
-- Name: tf_usuarios; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_usuarios (
    id_usuario bigint NOT NULL,
    codi_usuario integer NOT NULL,
    usuario character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    nombres character varying(50) NOT NULL,
    ape_paterno character varying(50) NOT NULL,
    ape_materno character varying(50) NOT NULL,
    email character varying(50),
    fecha_creacion date,
    fecha_cese date,
    imagen character varying(200),
    estado character varying(1) NOT NULL,
    session_id character varying(255)
);


ALTER TABLE catastro.tf_usuarios OWNER TO postgres;

--
-- Name: tf_usuarios_id_usuario_seq; Type: SEQUENCE; Schema: catastro; Owner: postgres
--

CREATE SEQUENCE catastro.tf_usuarios_id_usuario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catastro.tf_usuarios_id_usuario_seq OWNER TO postgres;

--
-- Name: tf_usuarios_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.tf_usuarios_id_usuario_seq OWNED BY catastro.tf_usuarios.id_usuario;


--
-- Name: tf_vias; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_vias (
    id_via character varying(12) NOT NULL,
    nomb_via character varying(100) NOT NULL,
    tipo_via character varying(5) NOT NULL,
    codi_via character varying(6) NOT NULL,
    id_ubi_geo character varying(6) NOT NULL,
    fecha_via date,
    estado character varying(1) NOT NULL
);


ALTER TABLE catastro.tf_vias OWNER TO postgres;

--
-- Name: tf_vias_hab_urba; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tf_vias_hab_urba (
    id_via character varying(12) NOT NULL,
    id_hab_urba character varying(10) NOT NULL
);


ALTER TABLE catastro.tf_vias_hab_urba OWNER TO postgres;

--
-- Name: tg_lotes; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tg_lotes (
    gid integer NOT NULL,
    objectid integer NOT NULL,
    shape_leng numeric(20,10) NOT NULL,
    textstring character varying(254) NOT NULL,
    textsize numeric(20,10) NOT NULL,
    cod_lote character varying(3) NOT NULL,
    geom text NOT NULL,
    cod_sector character varying(2) NOT NULL,
    cod_mzna character varying(3) NOT NULL
);


ALTER TABLE catastro.tg_lotes OWNER TO postgres;

--
-- Name: tipo_arquitecturas; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tipo_arquitecturas (
    id_ficha character varying(19) NOT NULL,
    codigo character varying(2),
    descripcion character varying(100)
);


ALTER TABLE catastro.tipo_arquitecturas OWNER TO postgres;

--
-- Name: tipo_materials; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.tipo_materials (
    id_ficha character varying(19) NOT NULL,
    codigo character varying(2),
    descripcion character varying(100)
);


ALTER TABLE catastro.tipo_materials OWNER TO postgres;

--
-- Name: titular_certificado_catastrals; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.titular_certificado_catastrals (
    id bigint NOT NULL,
    nume_doc character varying(17),
    tipo_doc character varying(2),
    tipo_persona character varying(1),
    nombres character varying(150),
    ape_paterno character varying(50),
    ape_materno character varying(50),
    tipo_persona_juridica character varying(2),
    tipo_funcion character varying(1),
    nregistro character varying(7),
    razon_social character varying(100),
    certificado_id bigint
);


ALTER TABLE catastro.titular_certificado_catastrals OWNER TO postgres;

--
-- Name: titular_certificado_catastrals_id_seq; Type: SEQUENCE; Schema: catastro; Owner: postgres
--

CREATE SEQUENCE catastro.titular_certificado_catastrals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catastro.titular_certificado_catastrals_id_seq OWNER TO postgres;

--
-- Name: titular_certificado_catastrals_id_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.titular_certificado_catastrals_id_seq OWNED BY catastro.titular_certificado_catastrals.id;


--
-- Name: titular_certificados; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.titular_certificados (
    id bigint NOT NULL,
    nume_doc character varying(17),
    tipo_doc character varying(2),
    tipo_persona character varying(1),
    nombres character varying(150),
    ape_paterno character varying(50),
    ape_materno character varying(50),
    tipo_persona_juridica character varying(2),
    tipo_funcion character varying(1),
    nregistro character varying(7),
    razon_social character varying(100),
    certificado_id bigint
);


ALTER TABLE catastro.titular_certificados OWNER TO postgres;

--
-- Name: titular_certificados_id_seq; Type: SEQUENCE; Schema: catastro; Owner: postgres
--

CREATE SEQUENCE catastro.titular_certificados_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catastro.titular_certificados_id_seq OWNER TO postgres;

--
-- Name: titular_certificados_id_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.titular_certificados_id_seq OWNED BY catastro.titular_certificados.id;


--
-- Name: ubicacion_certificado_catastrals; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.ubicacion_certificado_catastrals (
    id bigint NOT NULL,
    codi_puerta character varying(2),
    tipo_puerta character varying(1),
    cuadra character varying(20),
    interior character varying(2),
    via_id character varying(255),
    certificado_id bigint
);


ALTER TABLE catastro.ubicacion_certificado_catastrals OWNER TO postgres;

--
-- Name: ubicacion_certificado_catastrals_id_seq; Type: SEQUENCE; Schema: catastro; Owner: postgres
--

CREATE SEQUENCE catastro.ubicacion_certificado_catastrals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catastro.ubicacion_certificado_catastrals_id_seq OWNER TO postgres;

--
-- Name: ubicacion_certificado_catastrals_id_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.ubicacion_certificado_catastrals_id_seq OWNED BY catastro.ubicacion_certificado_catastrals.id;


--
-- Name: ubicacion_certificados; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.ubicacion_certificados (
    id bigint NOT NULL,
    codi_puerta character varying(2),
    tipo_puerta character varying(1),
    cuadra character varying(20),
    interior character varying(2),
    via_id character varying(255),
    certificado_id bigint
);


ALTER TABLE catastro.ubicacion_certificados OWNER TO postgres;

--
-- Name: ubicacion_certificados_id_seq; Type: SEQUENCE; Schema: catastro; Owner: postgres
--

CREATE SEQUENCE catastro.ubicacion_certificados_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE catastro.ubicacion_certificados_id_seq OWNER TO postgres;

--
-- Name: ubicacion_certificados_id_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.ubicacion_certificados_id_seq OWNED BY catastro.ubicacion_certificados.id;


--
-- Name: ubiges; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.ubiges (
    cod_dep character varying(2) NOT NULL,
    cod_pro character varying(2) NOT NULL,
    codi_dis character varying(2) NOT NULL,
    descri character varying(50) NOT NULL
);


ALTER TABLE catastro.ubiges OWNER TO postgres;

--
-- Name: tg_comercio; Type: TABLE; Schema: geo; Owner: postgres
--

CREATE TABLE geo.tg_comercio (
    gid integer NOT NULL,
    id_ubigeo character varying(6),
    cod_piso character varying(2),
    cod_lote character varying(3),
    id_uni_cat character varying(23),
    area_grafi double precision,
    peri_grafi double precision,
    usuario_crea integer,
    fecha_crea timestamp without time zone,
    geom public.geometry(Polygon,32719)
);


ALTER TABLE geo.tg_comercio OWNER TO postgres;

--
-- Name: tg_comercio_gid_seq; Type: SEQUENCE; Schema: geo; Owner: postgres
--

CREATE SEQUENCE geo.tg_comercio_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tg_comercio_gid_seq OWNER TO postgres;

--
-- Name: tg_comercio_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_comercio_gid_seq OWNED BY geo.tg_comercio.gid;


--
-- Name: tg_construccion; Type: TABLE; Schema: geo; Owner: postgres
--

CREATE TABLE geo.tg_construccion (
    gid integer NOT NULL,
    id_ubigeo character varying(6),
    cod_piso character varying(2),
    id_constru character varying(20),
    id_lote character varying(14),
    area_grafi double precision,
    peri_grafi double precision,
    usuario_crea integer,
    fecha_crea timestamp without time zone,
    geom public.geometry(Polygon,32719)
);


ALTER TABLE geo.tg_construccion OWNER TO postgres;

--
-- Name: tg_construccion_gid_seq; Type: SEQUENCE; Schema: geo; Owner: postgres
--

CREATE SEQUENCE geo.tg_construccion_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tg_construccion_gid_seq OWNER TO postgres;

--
-- Name: tg_construccion_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_construccion_gid_seq OWNED BY geo.tg_construccion.gid;


--
-- Name: tg_eje_via; Type: TABLE; Schema: geo; Owner: postgres
--

CREATE TABLE geo.tg_eje_via (
    gid integer NOT NULL,
    id_ubigeo character varying(6),
    cod_sector character varying(2),
    id_sector character varying(8),
    cod_via character varying(6),
    id_via character varying(12),
    nomb_via character varying(200),
    peri_grafi double precision,
    usuario_crea integer,
    fecha_crea timestamp without time zone,
    geom public.geometry(LineString,32719)
);


ALTER TABLE geo.tg_eje_via OWNER TO postgres;

--
-- Name: tg_eje_via_gid_seq; Type: SEQUENCE; Schema: geo; Owner: postgres
--

CREATE SEQUENCE geo.tg_eje_via_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tg_eje_via_gid_seq OWNER TO postgres;

--
-- Name: tg_eje_via_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_eje_via_gid_seq OWNED BY geo.tg_eje_via.gid;


--
-- Name: tg_hab_urb; Type: TABLE; Schema: geo; Owner: postgres
--

CREATE TABLE geo.tg_hab_urb (
    gid integer NOT NULL,
    id_ubigeo character varying(6),
    cod_hab_urb character varying(4),
    id_hab_urb character varying(10),
    tipo_hab_urb character varying(10),
    nomb_hab_urb character varying(200),
    etap_hab_urb character varying(200),
    expediente character varying(500),
    area_grafi double precision,
    peri_grafi double precision,
    usuario_crea integer,
    fecha_crea timestamp without time zone,
    geom public.geometry(Polygon,32719)
);


ALTER TABLE geo.tg_hab_urb OWNER TO postgres;

--
-- Name: tg_hab_urb_gid_seq; Type: SEQUENCE; Schema: geo; Owner: postgres
--

CREATE SEQUENCE geo.tg_hab_urb_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tg_hab_urb_gid_seq OWNER TO postgres;

--
-- Name: tg_hab_urb_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_hab_urb_gid_seq OWNED BY geo.tg_hab_urb.gid;


--
-- Name: tg_lote; Type: TABLE; Schema: geo; Owner: postgres
--

CREATE TABLE geo.tg_lote (
    gid integer NOT NULL,
    id_ubigeo character varying(6),
    cod_sector character varying(2),
    id_sector character varying(8),
    cod_mzna character varying(3),
    id_mzna character varying(11),
    cod_lote character varying(3),
    id_lote character varying(14),
    area_grafi double precision,
    peri_grafi double precision,
    cuc character varying(12),
    usuario_crea integer,
    fecha_crea timestamp without time zone,
    geom public.geometry(Polygon,32719)
);


ALTER TABLE geo.tg_lote OWNER TO postgres;

--
-- Name: tg_lote_gid_seq; Type: SEQUENCE; Schema: geo; Owner: postgres
--

CREATE SEQUENCE geo.tg_lote_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tg_lote_gid_seq OWNER TO postgres;

--
-- Name: tg_lote_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_lote_gid_seq OWNED BY geo.tg_lote.gid;


--
-- Name: tg_manzana; Type: TABLE; Schema: geo; Owner: postgres
--

CREATE TABLE geo.tg_manzana (
    gid integer NOT NULL,
    id_ubigeo character varying(6),
    cod_sector character varying(2),
    id_sector character varying(8),
    cod_mzna character varying(3),
    id_mzna character varying(11),
    area_grafi double precision,
    peri_grafi double precision,
    usuario_crea integer,
    fecha_crea timestamp without time zone,
    geom public.geometry(Polygon,32719)
);


ALTER TABLE geo.tg_manzana OWNER TO postgres;

--
-- Name: tg_manzana_gid_seq; Type: SEQUENCE; Schema: geo; Owner: postgres
--

CREATE SEQUENCE geo.tg_manzana_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tg_manzana_gid_seq OWNER TO postgres;

--
-- Name: tg_manzana_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_manzana_gid_seq OWNED BY geo.tg_manzana.gid;


--
-- Name: tg_parque; Type: TABLE; Schema: geo; Owner: postgres
--

CREATE TABLE geo.tg_parque (
    gid integer NOT NULL,
    id_ubigeo character varying(6),
    cod_parque character varying(2),
    id_lote character varying(14),
    id_parque character varying(22),
    nomb_parque character varying(50),
    area_grafi double precision,
    peri_grafi double precision,
    usuario_crea integer,
    fecha_crea timestamp without time zone,
    geom public.geometry(Polygon,32719)
);


ALTER TABLE geo.tg_parque OWNER TO postgres;

--
-- Name: tg_parque_gid_seq; Type: SEQUENCE; Schema: geo; Owner: postgres
--

CREATE SEQUENCE geo.tg_parque_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tg_parque_gid_seq OWNER TO postgres;

--
-- Name: tg_parque_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_parque_gid_seq OWNED BY geo.tg_parque.gid;


--
-- Name: tg_puerta; Type: TABLE; Schema: geo; Owner: postgres
--

CREATE TABLE geo.tg_puerta (
    gid integer NOT NULL,
    id_ubigeo character varying(6),
    cod_puerta character varying(2),
    id_lote character varying(14),
    id_puerta character varying(20),
    esta_puerta character varying(1),
    usuario_crea integer,
    fecha_crea timestamp without time zone,
    geom public.geometry(Point,32719)
);


ALTER TABLE geo.tg_puerta OWNER TO postgres;

--
-- Name: tg_puerta_gid_seq; Type: SEQUENCE; Schema: geo; Owner: postgres
--

CREATE SEQUENCE geo.tg_puerta_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tg_puerta_gid_seq OWNER TO postgres;

--
-- Name: tg_puerta_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_puerta_gid_seq OWNED BY geo.tg_puerta.gid;


--
-- Name: tg_sector; Type: TABLE; Schema: geo; Owner: postgres
--

CREATE TABLE geo.tg_sector (
    gid integer NOT NULL,
    id_ubigeo character varying(6),
    cod_sector character varying(2),
    id_sector character varying(8),
    area_grafi double precision,
    peri_grafi double precision,
    usuario_crea integer,
    fecha_crea timestamp without time zone,
    geom public.geometry(Polygon,32719)
);


ALTER TABLE geo.tg_sector OWNER TO postgres;

--
-- Name: tg_sector_gid_seq; Type: SEQUENCE; Schema: geo; Owner: postgres
--

CREATE SEQUENCE geo.tg_sector_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tg_sector_gid_seq OWNER TO postgres;

--
-- Name: tg_sector_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_sector_gid_seq OWNED BY geo.tg_sector.gid;


--
-- Name: tgh_comercio; Type: TABLE; Schema: geo; Owner: postgres
--

CREATE TABLE geo.tgh_comercio (
    id integer NOT NULL,
    gid integer,
    id_ubigeo character varying(6),
    cod_piso character varying(2),
    cod_lote character varying(3),
    id_uni_cat character varying(23),
    area_grafi double precision,
    peri_grafi double precision,
    usuario_crea integer,
    fecha_crea timestamp without time zone,
    geom public.geometry(Polygon,32719),
    usuario_modifica integer NOT NULL,
    fecha_modifica timestamp without time zone NOT NULL
);


ALTER TABLE geo.tgh_comercio OWNER TO postgres;

--
-- Name: tgh_comercio_id_seq; Type: SEQUENCE; Schema: geo; Owner: postgres
--

CREATE SEQUENCE geo.tgh_comercio_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tgh_comercio_id_seq OWNER TO postgres;

--
-- Name: tgh_comercio_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_comercio_id_seq OWNED BY geo.tgh_comercio.id;


--
-- Name: tgh_construccion; Type: TABLE; Schema: geo; Owner: postgres
--

CREATE TABLE geo.tgh_construccion (
    id integer NOT NULL,
    gid integer,
    id_ubigeo character varying(6),
    cod_piso character varying(2),
    id_constru character varying(20),
    id_lote character varying(14),
    area_grafi double precision,
    peri_grafi double precision,
    usuario_crea integer,
    fecha_crea timestamp without time zone,
    geom public.geometry(Polygon,32719),
    usuario_modifica integer NOT NULL,
    fecha_modifica timestamp without time zone NOT NULL
);


ALTER TABLE geo.tgh_construccion OWNER TO postgres;

--
-- Name: tgh_construccion_id_seq; Type: SEQUENCE; Schema: geo; Owner: postgres
--

CREATE SEQUENCE geo.tgh_construccion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tgh_construccion_id_seq OWNER TO postgres;

--
-- Name: tgh_construccion_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_construccion_id_seq OWNED BY geo.tgh_construccion.id;


--
-- Name: tgh_eje_via; Type: TABLE; Schema: geo; Owner: postgres
--

CREATE TABLE geo.tgh_eje_via (
    id integer NOT NULL,
    gid integer,
    id_ubigeo character varying(6),
    cod_sector character varying(2),
    id_sector character varying(8),
    cod_via character varying(6),
    id_via character varying(12),
    nomb_via character varying(200),
    peri_grafi double precision,
    usuario_crea integer,
    fecha_crea timestamp without time zone,
    geom public.geometry(LineString,32719),
    usuario_modifica integer NOT NULL,
    fecha_modifica timestamp without time zone NOT NULL
);


ALTER TABLE geo.tgh_eje_via OWNER TO postgres;

--
-- Name: tgh_eje_via_id_seq; Type: SEQUENCE; Schema: geo; Owner: postgres
--

CREATE SEQUENCE geo.tgh_eje_via_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tgh_eje_via_id_seq OWNER TO postgres;

--
-- Name: tgh_eje_via_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_eje_via_id_seq OWNED BY geo.tgh_eje_via.id;


--
-- Name: tgh_hab_urb; Type: TABLE; Schema: geo; Owner: postgres
--

CREATE TABLE geo.tgh_hab_urb (
    id integer NOT NULL,
    gid integer,
    id_ubigeo character varying(6),
    cod_hab_urb character varying(4),
    id_hab_urb character varying(10),
    tipo_hab_urb character varying(10),
    nomb_hab_urb character varying(200),
    etap_hab_urb character varying(200),
    expediente character varying(500),
    area_grafi double precision,
    peri_grafi double precision,
    usuario_crea integer,
    fecha_crea timestamp without time zone,
    geom public.geometry(Polygon,32719),
    usuario_modifica integer NOT NULL,
    fecha_modifica timestamp without time zone NOT NULL
);


ALTER TABLE geo.tgh_hab_urb OWNER TO postgres;

--
-- Name: tgh_hab_urb_id_seq; Type: SEQUENCE; Schema: geo; Owner: postgres
--

CREATE SEQUENCE geo.tgh_hab_urb_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tgh_hab_urb_id_seq OWNER TO postgres;

--
-- Name: tgh_hab_urb_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_hab_urb_id_seq OWNED BY geo.tgh_hab_urb.id;


--
-- Name: tgh_lote; Type: TABLE; Schema: geo; Owner: postgres
--

CREATE TABLE geo.tgh_lote (
    id integer NOT NULL,
    gid integer,
    id_ubigeo character varying(6),
    cod_sector character varying(2),
    id_sector character varying(8),
    cod_mzna character varying(3),
    id_mzna character varying(11),
    cod_lote character varying(3),
    id_lote character varying(14),
    area_grafi double precision,
    peri_grafi double precision,
    cuc character varying(12),
    usuario_crea integer,
    fecha_crea timestamp without time zone,
    geom public.geometry(Polygon,32719),
    usuario_modifica integer NOT NULL,
    fecha_modifica timestamp without time zone NOT NULL
);


ALTER TABLE geo.tgh_lote OWNER TO postgres;

--
-- Name: tgh_lote_id_seq; Type: SEQUENCE; Schema: geo; Owner: postgres
--

CREATE SEQUENCE geo.tgh_lote_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tgh_lote_id_seq OWNER TO postgres;

--
-- Name: tgh_lote_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_lote_id_seq OWNED BY geo.tgh_lote.id;


--
-- Name: tgh_manzana; Type: TABLE; Schema: geo; Owner: postgres
--

CREATE TABLE geo.tgh_manzana (
    id integer NOT NULL,
    gid integer,
    id_ubigeo character varying(6),
    cod_sector character varying(2),
    id_sector character varying(8),
    cod_mzna character varying(3),
    id_mzna character varying(11),
    area_grafi double precision,
    peri_grafi double precision,
    usuario_crea integer,
    fecha_crea timestamp without time zone,
    geom public.geometry(Polygon,32719),
    usuario_modifica integer NOT NULL,
    fecha_modifica timestamp without time zone NOT NULL
);


ALTER TABLE geo.tgh_manzana OWNER TO postgres;

--
-- Name: tgh_manzana_id_seq; Type: SEQUENCE; Schema: geo; Owner: postgres
--

CREATE SEQUENCE geo.tgh_manzana_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tgh_manzana_id_seq OWNER TO postgres;

--
-- Name: tgh_manzana_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_manzana_id_seq OWNED BY geo.tgh_manzana.id;


--
-- Name: tgh_parque; Type: TABLE; Schema: geo; Owner: postgres
--

CREATE TABLE geo.tgh_parque (
    id integer NOT NULL,
    gid integer,
    id_ubigeo character varying(6),
    cod_parque character varying(2),
    id_lote character varying(14),
    id_parque character varying(22),
    nomb_parque character varying(50),
    area_grafi double precision,
    peri_grafi double precision,
    usuario_crea integer,
    fecha_crea timestamp without time zone,
    geom public.geometry(Polygon,32719),
    usuario_modifica integer NOT NULL,
    fecha_modifica timestamp without time zone NOT NULL
);


ALTER TABLE geo.tgh_parque OWNER TO postgres;

--
-- Name: tgh_parque_id_seq; Type: SEQUENCE; Schema: geo; Owner: postgres
--

CREATE SEQUENCE geo.tgh_parque_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tgh_parque_id_seq OWNER TO postgres;

--
-- Name: tgh_parque_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_parque_id_seq OWNED BY geo.tgh_parque.id;


--
-- Name: tgh_puerta; Type: TABLE; Schema: geo; Owner: postgres
--

CREATE TABLE geo.tgh_puerta (
    id integer NOT NULL,
    gid integer,
    cod_puerta character varying(2),
    id_lote character varying(14),
    id_puerta character varying(20),
    esta_puerta character varying(1),
    usuario_crea integer,
    fecha_crea timestamp without time zone,
    geom public.geometry(Point,32719),
    usuario_modifica integer NOT NULL,
    fecha_modifica timestamp without time zone NOT NULL
);


ALTER TABLE geo.tgh_puerta OWNER TO postgres;

--
-- Name: tgh_puerta_id_seq; Type: SEQUENCE; Schema: geo; Owner: postgres
--

CREATE SEQUENCE geo.tgh_puerta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tgh_puerta_id_seq OWNER TO postgres;

--
-- Name: tgh_puerta_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_puerta_id_seq OWNED BY geo.tgh_puerta.id;


--
-- Name: tgh_sector; Type: TABLE; Schema: geo; Owner: postgres
--

CREATE TABLE geo.tgh_sector (
    id integer NOT NULL,
    gid integer,
    id_ubigeo character varying(6),
    cod_sector character varying(2),
    id_sector character varying(8),
    area_grafi double precision,
    peri_grafi double precision,
    usuario_crea integer,
    fecha_crea timestamp without time zone,
    geom public.geometry(Polygon,32719),
    usuario_modifica integer NOT NULL,
    fecha_modifica timestamp without time zone NOT NULL
);


ALTER TABLE geo.tgh_sector OWNER TO postgres;

--
-- Name: tgh_sector_id_seq; Type: SEQUENCE; Schema: geo; Owner: postgres
--

CREATE SEQUENCE geo.tgh_sector_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tgh_sector_id_seq OWNER TO postgres;

--
-- Name: tgh_sector_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_sector_id_seq OWNED BY geo.tgh_sector.id;


--
-- Name: v_clasificacion_predio; Type: VIEW; Schema: geo; Owner: postgres
--

CREATE VIEW geo.v_clasificacion_predio AS
 SELECT a.gid,
    b.id_lote,
        CASE
            WHEN ((d.tipo_doc)::text = '0'::text) THEN 'RUC'::text
            WHEN ((d.tipo_doc)::text = '2'::text) THEN 'DNI'::text
            ELSE NULL::text
        END AS tipo_doc,
    d.nume_doc,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN 'PERSONA NATURAL'::text
            WHEN ((d.tipo_persona)::text = '2'::text) THEN 'PERSONA JURIDICA'::text
            ELSE NULL::text
        END AS tipo_persona,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN (((((d.ape_paterno)::text || ' '::text) || (d.ape_materno)::text) || ' '::text) || (d.nombres)::text)
            WHEN ((d.tipo_persona)::text = '2'::text) THEN (d.razon_social)::text
            ELSE NULL::text
        END AS ciudadano_razon_social,
    "substring"((e.clasificacion)::text, 1, 2) AS codi_clasi,
        CASE
            WHEN ("substring"((e.clasificacion)::text, 1, 2) = '01'::text) THEN 'CASA HABITACITACIÓN'::text
            WHEN ("substring"((e.clasificacion)::text, 1, 2) = '02'::text) THEN 'TIENDA - DEPÓSITO - ALMACEN'::text
            WHEN ("substring"((e.clasificacion)::text, 1, 2) = '03'::text) THEN 'PREDIO EN EDIFICIO'::text
            WHEN ("substring"((e.clasificacion)::text, 1, 2) = '04'::text) THEN 'OTROS'::text
            WHEN ("substring"((e.clasificacion)::text, 1, 2) = '05'::text) THEN 'TERRENO SIN CONSTRUIR'::text
            ELSE NULL::text
        END AS clasificacion,
    e.area_titulo,
    e.area_verificada,
    e.nume_habitantes,
    e.observaciones,
    a.geom
   FROM ((((geo.tg_lote a
     JOIN catastro.tf_fichas b ON (((a.id_lote)::text = (b.id_lote)::text)))
     JOIN catastro.tf_titulares c ON (((b.id_ficha)::text = (c.id_ficha)::text)))
     JOIN catastro.tf_personas d ON (((c.id_persona)::text = (d.id_persona)::text)))
     JOIN catastro.tf_fichas_individuales e ON (((b.id_ficha)::text = (e.id_ficha)::text)))
  GROUP BY a.gid, b.id_lote,
        CASE
            WHEN ((d.tipo_doc)::text = '0'::text) THEN 'RUC'::text
            WHEN ((d.tipo_doc)::text = '2'::text) THEN 'DNI'::text
            ELSE NULL::text
        END, d.nume_doc,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN 'PERSONA NATURAL'::text
            WHEN ((d.tipo_persona)::text = '2'::text) THEN 'PERSONA JURIDICA'::text
            ELSE NULL::text
        END,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN (((((d.ape_paterno)::text || ' '::text) || (d.ape_materno)::text) || ' '::text) || (d.nombres)::text)
            WHEN ((d.tipo_persona)::text = '2'::text) THEN (d.razon_social)::text
            ELSE NULL::text
        END, ("substring"((e.clasificacion)::text, 1, 2)),
        CASE
            WHEN ("substring"((e.clasificacion)::text, 1, 2) = '01'::text) THEN 'CASA HABITACITACIÓN'::text
            WHEN ("substring"((e.clasificacion)::text, 1, 2) = '02'::text) THEN 'TIENDA - DEPÓSITO - ALMACEN'::text
            WHEN ("substring"((e.clasificacion)::text, 1, 2) = '03'::text) THEN 'PREDIO EN EDIFICIO'::text
            WHEN ("substring"((e.clasificacion)::text, 1, 2) = '04'::text) THEN 'OTROS'::text
            WHEN ("substring"((e.clasificacion)::text, 1, 2) = '05'::text) THEN 'TERRENO SIN CONSTRUIR'::text
            ELSE NULL::text
        END, e.area_titulo, e.area_verificada, e.nume_habitantes, e.observaciones, a.geom
  ORDER BY a.gid;


ALTER VIEW geo.v_clasificacion_predio OWNER TO postgres;

--
-- Name: v_estado_conservacion; Type: VIEW; Schema: geo; Owner: postgres
--

CREATE VIEW geo.v_estado_conservacion AS
 SELECT a.gid,
    b.id_lote,
        CASE
            WHEN ((d.tipo_doc)::text = '0'::text) THEN 'RUC'::text
            WHEN ((d.tipo_doc)::text = '2'::text) THEN 'DNI'::text
            ELSE NULL::text
        END AS tipo_doc,
    d.nume_doc,
        CASE
            WHEN (d.tipo_persona IS NULL) THEN '0'::character varying
            ELSE d.tipo_persona
        END AS tipo_persona,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN 'PERSONA NATURAL'::text
            WHEN ((d.tipo_persona)::text = '2'::text) THEN 'PERSONA JURIDICA'::text
            ELSE NULL::text
        END AS persona,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN (((((d.ape_paterno)::text || ' '::text) || (d.ape_materno)::text) || ' '::text) || (d.nombres)::text)
            WHEN ((d.tipo_persona)::text = '2'::text) THEN (d.razon_social)::text
            ELSE NULL::text
        END AS ciudadano_razon_social,
    f.ecs,
    a.geom
   FROM (((((geo.tg_lote a
     JOIN catastro.tf_fichas b ON (((a.id_lote)::text = (b.id_lote)::text)))
     JOIN catastro.tf_titulares c ON (((b.id_ficha)::text = (c.id_ficha)::text)))
     JOIN catastro.tf_personas d ON (((c.id_persona)::text = (d.id_persona)::text)))
     JOIN catastro.tf_fichas_individuales e ON (((e.id_ficha)::text = (b.id_ficha)::text)))
     JOIN catastro.tf_construcciones f ON (((f.id_ficha)::text = (e.id_ficha)::text)))
  WHERE ((b.tipo_ficha)::text = '01'::text)
  GROUP BY a.gid, b.id_lote,
        CASE
            WHEN ((d.tipo_doc)::text = '0'::text) THEN 'RUC'::text
            WHEN ((d.tipo_doc)::text = '2'::text) THEN 'DNI'::text
            ELSE NULL::text
        END, d.nume_doc,
        CASE
            WHEN (d.tipo_persona IS NULL) THEN '0'::character varying
            ELSE d.tipo_persona
        END,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN 'PERSONA NATURAL'::text
            WHEN ((d.tipo_persona)::text = '2'::text) THEN 'PERSONA JURIDICA'::text
            ELSE NULL::text
        END,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN (((((d.ape_paterno)::text || ' '::text) || (d.ape_materno)::text) || ' '::text) || (d.nombres)::text)
            WHEN ((d.tipo_persona)::text = '2'::text) THEN (d.razon_social)::text
            ELSE NULL::text
        END, f.ecs, a.geom
  ORDER BY a.gid;


ALTER VIEW geo.v_estado_conservacion OWNER TO postgres;

--
-- Name: v_estado_construccion; Type: VIEW; Schema: geo; Owner: postgres
--

CREATE VIEW geo.v_estado_construccion AS
 SELECT a.gid,
    b.id_lote,
        CASE
            WHEN ((d.tipo_doc)::text = '0'::text) THEN 'RUC'::text
            WHEN ((d.tipo_doc)::text = '2'::text) THEN 'DNI'::text
            ELSE NULL::text
        END AS tipo_doc,
    d.nume_doc,
        CASE
            WHEN (d.tipo_persona IS NULL) THEN '0'::character varying
            ELSE d.tipo_persona
        END AS tipo_persona,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN 'PERSONA NATURAL'::text
            WHEN ((d.tipo_persona)::text = '2'::text) THEN 'PERSONA JURIDICA'::text
            ELSE NULL::text
        END AS persona,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN (((((d.ape_paterno)::text || ' '::text) || (d.ape_materno)::text) || ' '::text) || (d.nombres)::text)
            WHEN ((d.tipo_persona)::text = '2'::text) THEN (d.razon_social)::text
            ELSE NULL::text
        END AS ciudadano_razon_social,
    f.ecc,
    a.geom
   FROM (((((geo.tg_lote a
     JOIN catastro.tf_fichas b ON (((a.id_lote)::text = (b.id_lote)::text)))
     JOIN catastro.tf_titulares c ON (((b.id_ficha)::text = (c.id_ficha)::text)))
     JOIN catastro.tf_personas d ON (((c.id_persona)::text = (d.id_persona)::text)))
     JOIN catastro.tf_fichas_individuales e ON (((e.id_ficha)::text = (b.id_ficha)::text)))
     JOIN catastro.tf_construcciones f ON (((f.id_ficha)::text = (e.id_ficha)::text)))
  WHERE ((b.tipo_ficha)::text = '01'::text)
  GROUP BY a.gid, b.id_lote,
        CASE
            WHEN ((d.tipo_doc)::text = '0'::text) THEN 'RUC'::text
            WHEN ((d.tipo_doc)::text = '2'::text) THEN 'DNI'::text
            ELSE NULL::text
        END, d.nume_doc,
        CASE
            WHEN (d.tipo_persona IS NULL) THEN '0'::character varying
            ELSE d.tipo_persona
        END,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN 'PERSONA NATURAL'::text
            WHEN ((d.tipo_persona)::text = '2'::text) THEN 'PERSONA JURIDICA'::text
            ELSE NULL::text
        END,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN (((((d.ape_paterno)::text || ' '::text) || (d.ape_materno)::text) || ' '::text) || (d.nombres)::text)
            WHEN ((d.tipo_persona)::text = '2'::text) THEN (d.razon_social)::text
            ELSE NULL::text
        END, f.ecc, a.geom
  ORDER BY a.gid;


ALTER VIEW geo.v_estado_construccion OWNER TO postgres;

--
-- Name: v_lote; Type: VIEW; Schema: geo; Owner: postgres
--

CREATE VIEW geo.v_lote AS
SELECT
    NULL::integer AS gid,
    NULL::character varying(19) AS id_ficha,
    NULL::character varying(250) AS fotografia,
    NULL::character varying(14) AS id_lote,
    NULL::character varying(2) AS cod_sector,
    NULL::character varying(3) AS cod_mzna,
    NULL::text AS lote_id,
    NULL::character varying(3) AS cod_lote,
    NULL::integer AS existe,
    NULL::integer AS existe_ficha,
    NULL::text AS tipo_doc,
    NULL::character varying(17) AS nume_doc,
    NULL::text AS tipo_persona,
    NULL::text AS ciudadano_razon_social,
    NULL::numeric AS area_grafi,
    NULL::numeric AS peri_grafi,
    NULL::public.geometry(Polygon,32719) AS geom;


ALTER VIEW geo.v_lote OWNER TO postgres;

--
-- Name: v_lotes; Type: VIEW; Schema: geo; Owner: postgres
--

CREATE VIEW geo.v_lotes AS
SELECT
    NULL::integer AS gid,
    NULL::character varying(19) AS id_ficha,
    NULL::character varying(250) AS fotografia,
    NULL::character varying(14) AS id_lote,
    NULL::character varying(2) AS cod_sector,
    NULL::character varying(3) AS cod_mzna,
    NULL::text AS lotes_id,
    NULL::character varying(3) AS cod_lote,
    NULL::integer AS existe,
    NULL::integer AS existe_ficha,
    NULL::text AS tipo_doc,
    NULL::character varying(17) AS nume_doc,
    NULL::text AS tipo_persona,
    NULL::text AS ciudadano_razon_social,
    NULL::numeric AS area_grafi,
    NULL::numeric AS peri_grafi,
    NULL::public.geometry(Polygon,32719) AS geom;


ALTER VIEW geo.v_lotes OWNER TO postgres;

--
-- Name: v_material_construccion; Type: VIEW; Schema: geo; Owner: postgres
--

CREATE VIEW geo.v_material_construccion AS
 SELECT a.gid,
    b.id_lote,
        CASE
            WHEN ((d.tipo_doc)::text = '0'::text) THEN 'RUC'::text
            WHEN ((d.tipo_doc)::text = '2'::text) THEN 'DNI'::text
            ELSE NULL::text
        END AS tipo_doc,
    d.nume_doc,
        CASE
            WHEN (d.tipo_persona IS NULL) THEN '0'::character varying
            ELSE d.tipo_persona
        END AS tipo_persona,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN 'PERSONA NATURAL'::text
            WHEN ((d.tipo_persona)::text = '2'::text) THEN 'PERSONA JURIDICA'::text
            ELSE NULL::text
        END AS persona,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN (((((d.ape_paterno)::text || ' '::text) || (d.ape_materno)::text) || ' '::text) || (d.nombres)::text)
            WHEN ((d.tipo_persona)::text = '2'::text) THEN (d.razon_social)::text
            ELSE NULL::text
        END AS ciudadano_razon_social,
    f.mep,
    a.geom
   FROM (((((geo.tg_lote a
     JOIN catastro.tf_fichas b ON (((a.id_lote)::text = (b.id_lote)::text)))
     JOIN catastro.tf_titulares c ON (((b.id_ficha)::text = (c.id_ficha)::text)))
     JOIN catastro.tf_personas d ON (((c.id_persona)::text = (d.id_persona)::text)))
     JOIN catastro.tf_fichas_individuales e ON (((e.id_ficha)::text = (b.id_ficha)::text)))
     JOIN catastro.tf_construcciones f ON (((f.id_ficha)::text = (e.id_ficha)::text)))
  WHERE ((b.tipo_ficha)::text = '01'::text)
  GROUP BY a.gid, b.id_lote,
        CASE
            WHEN ((d.tipo_doc)::text = '0'::text) THEN 'RUC'::text
            WHEN ((d.tipo_doc)::text = '2'::text) THEN 'DNI'::text
            ELSE NULL::text
        END, d.nume_doc,
        CASE
            WHEN (d.tipo_persona IS NULL) THEN '0'::character varying
            ELSE d.tipo_persona
        END,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN 'PERSONA NATURAL'::text
            WHEN ((d.tipo_persona)::text = '2'::text) THEN 'PERSONA JURIDICA'::text
            ELSE NULL::text
        END,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN (((((d.ape_paterno)::text || ' '::text) || (d.ape_materno)::text) || ' '::text) || (d.nombres)::text)
            WHEN ((d.tipo_persona)::text = '2'::text) THEN (d.razon_social)::text
            ELSE NULL::text
        END, f.mep, a.geom
  ORDER BY a.gid;


ALTER VIEW geo.v_material_construccion OWNER TO postgres;

--
-- Name: v_nivel_construccion; Type: VIEW; Schema: geo; Owner: postgres
--

CREATE VIEW geo.v_nivel_construccion AS
 SELECT a.gid,
    b.id_lote,
        CASE
            WHEN ((d.tipo_doc)::text = '0'::text) THEN 'RUC'::text
            WHEN ((d.tipo_doc)::text = '2'::text) THEN 'DNI'::text
            ELSE NULL::text
        END AS tipo_doc,
    d.nume_doc,
        CASE
            WHEN (d.tipo_persona IS NULL) THEN '0'::character varying
            ELSE d.tipo_persona
        END AS tipo_persona,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN 'PERSONA NATURAL'::text
            WHEN ((d.tipo_persona)::text = '2'::text) THEN 'PERSONA JURIDICA'::text
            ELSE NULL::text
        END AS persona,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN (((((d.ape_paterno)::text || ' '::text) || (d.ape_materno)::text) || ' '::text) || (d.nombres)::text)
            WHEN ((d.tipo_persona)::text = '2'::text) THEN (d.razon_social)::text
            ELSE NULL::text
        END AS ciudadano_razon_social,
    f.nume_piso,
    a.geom
   FROM (((((geo.tg_lote a
     JOIN catastro.tf_fichas b ON (((a.id_lote)::text = (b.id_lote)::text)))
     JOIN catastro.tf_titulares c ON (((b.id_ficha)::text = (c.id_ficha)::text)))
     JOIN catastro.tf_personas d ON (((c.id_persona)::text = (d.id_persona)::text)))
     JOIN catastro.tf_fichas_individuales e ON (((b.id_ficha)::text = (e.id_ficha)::text)))
     JOIN catastro.tf_construcciones f ON (((e.id_ficha)::text = (f.id_ficha)::text)))
  WHERE ((b.tipo_ficha)::text = '01'::text)
  GROUP BY a.gid, b.id_lote,
        CASE
            WHEN ((d.tipo_doc)::text = '0'::text) THEN 'RUC'::text
            WHEN ((d.tipo_doc)::text = '2'::text) THEN 'DNI'::text
            ELSE NULL::text
        END, d.nume_doc,
        CASE
            WHEN (d.tipo_persona IS NULL) THEN '0'::character varying
            ELSE d.tipo_persona
        END,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN 'PERSONA NATURAL'::text
            WHEN ((d.tipo_persona)::text = '2'::text) THEN 'PERSONA JURIDICA'::text
            ELSE NULL::text
        END,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN (((((d.ape_paterno)::text || ' '::text) || (d.ape_materno)::text) || ' '::text) || (d.nombres)::text)
            WHEN ((d.tipo_persona)::text = '2'::text) THEN (d.razon_social)::text
            ELSE NULL::text
        END, f.nume_piso, a.geom
  ORDER BY a.gid;


ALTER VIEW geo.v_nivel_construccion OWNER TO postgres;

--
-- Name: v_servicio_basico; Type: VIEW; Schema: geo; Owner: postgres
--

CREATE VIEW geo.v_servicio_basico AS
 SELECT a.gid,
    b.id_lote,
        CASE
            WHEN ((d.tipo_doc)::text = '0'::text) THEN 'RUC'::text
            WHEN ((d.tipo_doc)::text = '2'::text) THEN 'DNI'::text
            ELSE NULL::text
        END AS tipo_doc,
    d.nume_doc,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN 'PERSONA NATURAL'::text
            WHEN ((d.tipo_persona)::text = '2'::text) THEN 'PERSONA JURIDICA'::text
            ELSE NULL::text
        END AS tipo_persona,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN (((((d.ape_paterno)::text || ' '::text) || (d.ape_materno)::text) || ' '::text) || (d.nombres)::text)
            WHEN ((d.tipo_persona)::text = '2'::text) THEN (d.razon_social)::text
            ELSE NULL::text
        END AS ciudadano_razon_social,
    e.luz AS codi_luz,
    e.agua AS codi_agua,
    e.telefono AS codi_telefono,
    e.desague AS codi_desague,
    e.gas AS codi_gas,
    e.internet AS codi_internet,
    e.tvcable AS codi_tvcable,
        CASE
            WHEN (e.luz = 1) THEN 'SI'::text
            WHEN (e.luz = 2) THEN 'NO'::text
            ELSE NULL::text
        END AS luz,
        CASE
            WHEN (e.agua = 1) THEN 'SI'::text
            WHEN (e.agua = 2) THEN 'NO'::text
            ELSE NULL::text
        END AS agua,
        CASE
            WHEN (e.telefono = 1) THEN 'SI'::text
            WHEN (e.telefono = 2) THEN 'NO'::text
            ELSE NULL::text
        END AS telefono,
        CASE
            WHEN (e.desague = 1) THEN 'SI'::text
            WHEN (e.desague = 2) THEN 'NO'::text
            ELSE NULL::text
        END AS desague,
        CASE
            WHEN (e.gas = 1) THEN 'SI'::text
            WHEN (e.gas = 2) THEN 'NO'::text
            ELSE NULL::text
        END AS gas,
        CASE
            WHEN (e.internet = 1) THEN 'SI'::text
            WHEN (e.internet = 2) THEN 'NO'::text
            ELSE NULL::text
        END AS internet,
        CASE
            WHEN (e.tvcable = 1) THEN 'SI'::text
            WHEN (e.tvcable = 2) THEN 'NO'::text
            ELSE NULL::text
        END AS tvcable,
    a.geom
   FROM ((((geo.tg_lote a
     JOIN catastro.tf_fichas b ON (((a.id_lote)::text = (b.id_lote)::text)))
     JOIN catastro.tf_titulares c ON (((b.id_ficha)::text = (c.id_ficha)::text)))
     JOIN catastro.tf_personas d ON (((c.id_persona)::text = (d.id_persona)::text)))
     JOIN catastro.tf_servicios_basicos e ON (((b.id_ficha)::text = (e.id_ficha)::text)))
  GROUP BY a.gid, b.id_lote, d.tipo_doc, d.nume_doc, d.tipo_persona, d.ape_paterno, d.ape_materno, d.nombres, d.razon_social, e.luz, e.agua, e.telefono, e.desague, e.gas, e.internet, e.tvcable, a.geom
  ORDER BY a.gid;


ALTER VIEW geo.v_servicio_basico OWNER TO postgres;

--
-- Name: v_tipo_persona; Type: VIEW; Schema: geo; Owner: postgres
--

CREATE VIEW geo.v_tipo_persona AS
 SELECT a.gid,
    b.id_lote,
        CASE
            WHEN ((d.tipo_doc)::text = '0'::text) THEN 'RUC'::text
            WHEN ((d.tipo_doc)::text = '2'::text) THEN 'DNI'::text
            ELSE NULL::text
        END AS tipo_doc,
    d.nume_doc,
        CASE
            WHEN (d.tipo_persona IS NULL) THEN '0'::character varying
            ELSE d.tipo_persona
        END AS tipo_persona,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN 'PERSONA NATURAL'::text
            WHEN ((d.tipo_persona)::text = '2'::text) THEN 'PERSONA JURIDICA'::text
            ELSE NULL::text
        END AS persona,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN (((((d.ape_paterno)::text || ' '::text) || (d.ape_materno)::text) || ' '::text) || (d.nombres)::text)
            WHEN ((d.tipo_persona)::text = '2'::text) THEN (d.razon_social)::text
            ELSE NULL::text
        END AS ciudadano_razon_social,
    a.geom
   FROM (((geo.tg_lote a
     JOIN catastro.tf_fichas b ON (((a.id_lote)::text = (b.id_lote)::text)))
     JOIN catastro.tf_titulares c ON (((b.id_ficha)::text = (c.id_ficha)::text)))
     JOIN catastro.tf_personas d ON (((c.id_persona)::text = (d.id_persona)::text)))
  GROUP BY a.gid, b.id_lote,
        CASE
            WHEN ((d.tipo_doc)::text = '0'::text) THEN 'RUC'::text
            WHEN ((d.tipo_doc)::text = '2'::text) THEN 'DNI'::text
            ELSE NULL::text
        END, d.nume_doc,
        CASE
            WHEN (d.tipo_persona IS NULL) THEN '0'::character varying
            ELSE d.tipo_persona
        END,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN 'PERSONA NATURAL'::text
            WHEN ((d.tipo_persona)::text = '2'::text) THEN 'PERSONA JURIDICA'::text
            ELSE NULL::text
        END,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN (((((d.ape_paterno)::text || ' '::text) || (d.ape_materno)::text) || ' '::text) || (d.nombres)::text)
            WHEN ((d.tipo_persona)::text = '2'::text) THEN (d.razon_social)::text
            ELSE NULL::text
        END, a.geom
  ORDER BY a.gid;


ALTER VIEW geo.v_tipo_persona OWNER TO postgres;

--
-- Name: v_tipo_uso; Type: VIEW; Schema: geo; Owner: postgres
--

CREATE VIEW geo.v_tipo_uso AS
 SELECT a.gid,
    b.id_lote,
        CASE
            WHEN ((d.tipo_doc)::text = '0'::text) THEN 'RUC'::text
            WHEN ((d.tipo_doc)::text = '2'::text) THEN 'DNI'::text
            ELSE NULL::text
        END AS tipo_doc,
    d.nume_doc,
        CASE
            WHEN (d.tipo_persona IS NULL) THEN '0'::character varying
            ELSE d.tipo_persona
        END AS tipo_persona,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN 'PERSONA NATURAL'::text
            WHEN ((d.tipo_persona)::text = '2'::text) THEN 'PERSONA JURIDICA'::text
            ELSE NULL::text
        END AS persona,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN (((((d.ape_paterno)::text || ' '::text) || (d.ape_materno)::text) || ' '::text) || (d.nombres)::text)
            WHEN ((d.tipo_persona)::text = '2'::text) THEN (d.razon_social)::text
            ELSE NULL::text
        END AS ciudadano_razon_social,
    f.codi_uso,
    a.geom
   FROM (((((geo.tg_lote a
     JOIN catastro.tf_fichas b ON (((a.id_lote)::text = (b.id_lote)::text)))
     JOIN catastro.tf_titulares c ON (((b.id_ficha)::text = (c.id_ficha)::text)))
     JOIN catastro.tf_personas d ON (((c.id_persona)::text = (d.id_persona)::text)))
     JOIN catastro.tf_fichas_individuales e ON (((e.id_ficha)::text = (b.id_ficha)::text)))
     JOIN catastro.tf_usos f ON (((f.codi_uso)::text = (e.codi_uso)::text)))
  WHERE ((b.tipo_ficha)::text = '01'::text)
  GROUP BY a.gid, b.id_lote,
        CASE
            WHEN ((d.tipo_doc)::text = '0'::text) THEN 'RUC'::text
            WHEN ((d.tipo_doc)::text = '2'::text) THEN 'DNI'::text
            ELSE NULL::text
        END, d.nume_doc,
        CASE
            WHEN (d.tipo_persona IS NULL) THEN '0'::character varying
            ELSE d.tipo_persona
        END,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN 'PERSONA NATURAL'::text
            WHEN ((d.tipo_persona)::text = '2'::text) THEN 'PERSONA JURIDICA'::text
            ELSE NULL::text
        END,
        CASE
            WHEN ((d.tipo_persona)::text = '1'::text) THEN (((((d.ape_paterno)::text || ' '::text) || (d.ape_materno)::text) || ' '::text) || (d.nombres)::text)
            WHEN ((d.tipo_persona)::text = '2'::text) THEN (d.razon_social)::text
            ELSE NULL::text
        END, f.codi_uso, a.geom
  ORDER BY a.gid;


ALTER VIEW geo.v_tipo_uso OWNER TO postgres;

--
-- Name: departamento; Type: TABLE; Schema: ign; Owner: postgres
--

CREATE TABLE ign.departamento (
    gid integer NOT NULL,
    coddep character varying(2),
    nombdep character varying(50),
    capital character varying(50),
    fuente character varying(50),
    geom public.geometry(MultiPolygon,4326)
);


ALTER TABLE ign.departamento OWNER TO postgres;

--
-- Name: departamentos_gid_seq; Type: SEQUENCE; Schema: ign; Owner: postgres
--

CREATE SEQUENCE ign.departamentos_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ign.departamentos_gid_seq OWNER TO postgres;

--
-- Name: departamentos_gid_seq; Type: SEQUENCE OWNED BY; Schema: ign; Owner: postgres
--

ALTER SEQUENCE ign.departamentos_gid_seq OWNED BY ign.departamento.gid;


--
-- Name: distrito; Type: TABLE; Schema: ign; Owner: postgres
--

CREATE TABLE ign.distrito (
    gid integer NOT NULL,
    ubigeo character varying(6),
    coddep character varying(2),
    nombdep character varying(50),
    codprov character varying(2),
    nombprov character varying(50),
    coddist character varying(2),
    nombdist character varying(50),
    capital character varying(50),
    fuente character varying(50),
    geom public.geometry(MultiPolygon,4326)
);


ALTER TABLE ign.distrito OWNER TO postgres;

--
-- Name: distritos_gid_seq; Type: SEQUENCE; Schema: ign; Owner: postgres
--

CREATE SEQUENCE ign.distritos_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ign.distritos_gid_seq OWNER TO postgres;

--
-- Name: distritos_gid_seq; Type: SEQUENCE OWNED BY; Schema: ign; Owner: postgres
--

ALTER SEQUENCE ign.distritos_gid_seq OWNED BY ign.distrito.gid;


--
-- Name: provincia; Type: TABLE; Schema: ign; Owner: postgres
--

CREATE TABLE ign.provincia (
    gid integer NOT NULL,
    coddep character varying(2),
    nombdep character varying(50),
    codprov character varying(50),
    nombprov character varying(50),
    capital character varying(50),
    fuente character varying(50),
    geom public.geometry(MultiPolygon,4326)
);


ALTER TABLE ign.provincia OWNER TO postgres;

--
-- Name: provincias_gid_seq; Type: SEQUENCE; Schema: ign; Owner: postgres
--

CREATE SEQUENCE ign.provincias_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ign.provincias_gid_seq OWNER TO postgres;

--
-- Name: provincias_gid_seq; Type: SEQUENCE OWNED BY; Schema: ign; Owner: postgres
--

ALTER SEQUENCE ign.provincias_gid_seq OWNED BY ign.provincia.gid;


--
-- Name: predio; Type: TABLE; Schema: sbn; Owner: postgres
--

CREATE TABLE sbn.predio (
    gid integer NOT NULL,
    reg numeric,
    cus_alfa numeric,
    cus_graf numeric,
    condicion character varying(100),
    tipo_regis character varying(11),
    titular character varying(200),
    inmueble_d character varying(254),
    inmueble_1 character varying(254),
    area_regis numeric,
    doc_regist character varying(23),
    dpto character varying(60),
    prov character varying(60),
    dist character varying(60),
    ruta_pe character varying(200),
    ruta_pp character varying(2),
    ruta_md character varying(2),
    ruta_ff character varying(2),
    geom public.geometry(MultiPolygon,4326)
);


ALTER TABLE sbn.predio OWNER TO postgres;

--
-- Name: predios_gid_seq; Type: SEQUENCE; Schema: sbn; Owner: postgres
--

CREATE SEQUENCE sbn.predios_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sbn.predios_gid_seq OWNER TO postgres;

--
-- Name: predios_gid_seq; Type: SEQUENCE OWNED BY; Schema: sbn; Owner: postgres
--

ALTER SEQUENCE sbn.predios_gid_seq OWNED BY sbn.predio.gid;


--
-- Name: tg_lote; Type: TABLE; Schema: vinculacion; Owner: postgres
--

CREATE TABLE vinculacion.tg_lote (
    id integer NOT NULL,
    geom public.geometry(MultiPolygon,32719),
    cod_sector character varying(2),
    id_ubigeo character varying(6),
    id_sector character varying(8),
    cod_mzna character varying(3),
    id_mzna character varying(11),
    cod_lote character varying(3),
    id_lote character varying(14),
    area_grafica numeric,
    peri_grafico numeric,
    puerta integer,
    uso character varying(6),
    cuc character varying(12),
    fech_actua date,
    hab character varying(20)
);


ALTER TABLE vinculacion.tg_lote OWNER TO postgres;

--
-- Name: archivos id; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.archivos ALTER COLUMN id SET DEFAULT nextval('catastro.archivos_id_seq'::regclass);


--
-- Name: audits id; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.audits ALTER COLUMN id SET DEFAULT nextval('catastro.audits_id_seq'::regclass);


--
-- Name: c_hoja_informativas id; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.c_hoja_informativas ALTER COLUMN id SET DEFAULT nextval('catastro.c_hoja_informativas_id_seq'::regclass);


--
-- Name: c_numeracions id; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.c_numeracions ALTER COLUMN id SET DEFAULT nextval('catastro.c_numeracions_id_seq'::regclass);


--
-- Name: construccion_certificados id; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.construccion_certificados ALTER COLUMN id SET DEFAULT nextval('catastro.construccion_certificados_id_seq'::regclass);


--
-- Name: failed_jobs id; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.failed_jobs ALTER COLUMN id SET DEFAULT nextval('catastro.failed_jobs_id_seq'::regclass);


--
-- Name: generar_certificados id; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.generar_certificados ALTER COLUMN id SET DEFAULT nextval('catastro.generar_certificados_id_seq'::regclass);


--
-- Name: generar_numeracions id; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.generar_numeracions ALTER COLUMN id SET DEFAULT nextval('catastro.generar_numeracions_id_seq'::regclass);


--
-- Name: imagenes id; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.imagenes ALTER COLUMN id SET DEFAULT nextval('catastro.imagenes_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.migrations ALTER COLUMN id SET DEFAULT nextval('catastro.migrations_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.permissions ALTER COLUMN id SET DEFAULT nextval('catastro.permissions_id_seq'::regclass);


--
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('catastro.personal_access_tokens_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.roles ALTER COLUMN id SET DEFAULT nextval('catastro.roles_id_seq'::regclass);


--
-- Name: tf_historia_via id_historia_via; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_historia_via ALTER COLUMN id_historia_via SET DEFAULT nextval('catastro.tf_historia_via_id_historia_via_seq'::regclass);


--
-- Name: tf_licencias id; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_licencias ALTER COLUMN id SET DEFAULT nextval('catastro.tf_licencias_id_seq'::regclass);


--
-- Name: tf_usuarios id_usuario; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_usuarios ALTER COLUMN id_usuario SET DEFAULT nextval('catastro.tf_usuarios_id_usuario_seq'::regclass);


--
-- Name: titular_certificado_catastrals id; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.titular_certificado_catastrals ALTER COLUMN id SET DEFAULT nextval('catastro.titular_certificado_catastrals_id_seq'::regclass);


--
-- Name: titular_certificados id; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.titular_certificados ALTER COLUMN id SET DEFAULT nextval('catastro.titular_certificados_id_seq'::regclass);


--
-- Name: ubicacion_certificado_catastrals id; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.ubicacion_certificado_catastrals ALTER COLUMN id SET DEFAULT nextval('catastro.ubicacion_certificado_catastrals_id_seq'::regclass);


--
-- Name: ubicacion_certificados id; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.ubicacion_certificados ALTER COLUMN id SET DEFAULT nextval('catastro.ubicacion_certificados_id_seq'::regclass);


--
-- Name: tg_comercio gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_comercio ALTER COLUMN gid SET DEFAULT nextval('geo.tg_comercio_gid_seq'::regclass);


--
-- Name: tg_construccion gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_construccion ALTER COLUMN gid SET DEFAULT nextval('geo.tg_construccion_gid_seq'::regclass);


--
-- Name: tg_eje_via gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_eje_via ALTER COLUMN gid SET DEFAULT nextval('geo.tg_eje_via_gid_seq'::regclass);


--
-- Name: tg_hab_urb gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_hab_urb ALTER COLUMN gid SET DEFAULT nextval('geo.tg_hab_urb_gid_seq'::regclass);


--
-- Name: tg_lote gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_lote ALTER COLUMN gid SET DEFAULT nextval('geo.tg_lote_gid_seq'::regclass);


--
-- Name: tg_manzana gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_manzana ALTER COLUMN gid SET DEFAULT nextval('geo.tg_manzana_gid_seq'::regclass);


--
-- Name: tg_parque gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_parque ALTER COLUMN gid SET DEFAULT nextval('geo.tg_parque_gid_seq'::regclass);


--
-- Name: tg_puerta gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_puerta ALTER COLUMN gid SET DEFAULT nextval('geo.tg_puerta_gid_seq'::regclass);


--
-- Name: tg_sector gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_sector ALTER COLUMN gid SET DEFAULT nextval('geo.tg_sector_gid_seq'::regclass);


--
-- Name: tgh_comercio id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_comercio ALTER COLUMN id SET DEFAULT nextval('geo.tgh_comercio_id_seq'::regclass);


--
-- Name: tgh_construccion id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_construccion ALTER COLUMN id SET DEFAULT nextval('geo.tgh_construccion_id_seq'::regclass);


--
-- Name: tgh_eje_via id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_eje_via ALTER COLUMN id SET DEFAULT nextval('geo.tgh_eje_via_id_seq'::regclass);


--
-- Name: tgh_hab_urb id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_hab_urb ALTER COLUMN id SET DEFAULT nextval('geo.tgh_hab_urb_id_seq'::regclass);


--
-- Name: tgh_lote id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_lote ALTER COLUMN id SET DEFAULT nextval('geo.tgh_lote_id_seq'::regclass);


--
-- Name: tgh_manzana id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_manzana ALTER COLUMN id SET DEFAULT nextval('geo.tgh_manzana_id_seq'::regclass);


--
-- Name: tgh_parque id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_parque ALTER COLUMN id SET DEFAULT nextval('geo.tgh_parque_id_seq'::regclass);


--
-- Name: tgh_puerta id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_puerta ALTER COLUMN id SET DEFAULT nextval('geo.tgh_puerta_id_seq'::regclass);


--
-- Name: tgh_sector id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_sector ALTER COLUMN id SET DEFAULT nextval('geo.tgh_sector_id_seq'::regclass);


--
-- Name: departamento gid; Type: DEFAULT; Schema: ign; Owner: postgres
--

ALTER TABLE ONLY ign.departamento ALTER COLUMN gid SET DEFAULT nextval('ign.departamentos_gid_seq'::regclass);


--
-- Name: distrito gid; Type: DEFAULT; Schema: ign; Owner: postgres
--

ALTER TABLE ONLY ign.distrito ALTER COLUMN gid SET DEFAULT nextval('ign.distritos_gid_seq'::regclass);


--
-- Name: provincia gid; Type: DEFAULT; Schema: ign; Owner: postgres
--

ALTER TABLE ONLY ign.provincia ALTER COLUMN gid SET DEFAULT nextval('ign.provincias_gid_seq'::regclass);


--
-- Name: predio gid; Type: DEFAULT; Schema: sbn; Owner: postgres
--

ALTER TABLE ONLY sbn.predio ALTER COLUMN gid SET DEFAULT nextval('sbn.predios_gid_seq'::regclass);


--
-- Name: archivos archivos_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.archivos
    ADD CONSTRAINT archivos_pkey PRIMARY KEY (id);


--
-- Name: audits audits_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.audits
    ADD CONSTRAINT audits_pkey PRIMARY KEY (id);


--
-- Name: c_hoja_informativas c_hoja_informativas_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.c_hoja_informativas
    ADD CONSTRAINT c_hoja_informativas_pkey PRIMARY KEY (id);


--
-- Name: c_numeracions c_numeracions_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.c_numeracions
    ADD CONSTRAINT c_numeracions_pkey PRIMARY KEY (id);


--
-- Name: construccion_certificados construccion_certificados_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.construccion_certificados
    ADD CONSTRAINT construccion_certificados_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- Name: generar_certificados generar_certificados_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.generar_certificados
    ADD CONSTRAINT generar_certificados_pkey PRIMARY KEY (id);


--
-- Name: generar_numeracions generar_numeracions_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.generar_numeracions
    ADD CONSTRAINT generar_numeracions_pkey PRIMARY KEY (id);


--
-- Name: imagenes imagenes_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.imagenes
    ADD CONSTRAINT imagenes_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: model_has_permissions model_has_permissions_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);


--
-- Name: model_has_roles model_has_roles_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);


--
-- Name: permissions permissions_name_guard_name_unique; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.permissions
    ADD CONSTRAINT permissions_name_guard_name_unique UNIQUE (name, guard_name);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


--
-- Name: role_has_permissions role_has_permissions_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.role_has_permissions
    ADD CONSTRAINT role_has_permissions_pkey PRIMARY KEY (permission_id, role_id);


--
-- Name: roles roles_name_guard_name_unique; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.roles
    ADD CONSTRAINT roles_name_guard_name_unique UNIQUE (name, guard_name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: tf_actividades tf_actividades_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_actividades
    ADD CONSTRAINT tf_actividades_pkey PRIMARY KEY (codi_actividad);


--
-- Name: tf_autorizaciones_anuncios tf_autorizaciones_anuncios_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_autorizaciones_anuncios
    ADD CONSTRAINT tf_autorizaciones_anuncios_pkey PRIMARY KEY (id_anuncio);


--
-- Name: tf_codigos_instalaciones tf_codigos_instalaciones_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_codigos_instalaciones
    ADD CONSTRAINT tf_codigos_instalaciones_pkey PRIMARY KEY (codi_instalacion);


--
-- Name: tf_construcciones tf_construcciones_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_construcciones
    ADD CONSTRAINT tf_construcciones_pkey PRIMARY KEY (id_construccion);


--
-- Name: tf_documentos_adjuntos tf_documentos_adjuntos_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_documentos_adjuntos
    ADD CONSTRAINT tf_documentos_adjuntos_pkey PRIMARY KEY (id_doc);


--
-- Name: tf_edificaciones tf_edificaciones_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_edificaciones
    ADD CONSTRAINT tf_edificaciones_pkey PRIMARY KEY (id_edificacion);


--
-- Name: tf_fichas tf_fichas_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_fichas
    ADD CONSTRAINT tf_fichas_pkey PRIMARY KEY (id_ficha);


--
-- Name: tf_hab_urbana tf_hab_urbana_codi_hab_urba_unique; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_hab_urbana
    ADD CONSTRAINT tf_hab_urbana_codi_hab_urba_unique UNIQUE (codi_hab_urba);


--
-- Name: tf_hab_urbana tf_hab_urbana_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_hab_urbana
    ADD CONSTRAINT tf_hab_urbana_pkey PRIMARY KEY (id_hab_urba);


--
-- Name: tf_historia_via tf_historia_via_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_historia_via
    ADD CONSTRAINT tf_historia_via_pkey PRIMARY KEY (id_historia_via);


--
-- Name: tf_instalaciones tf_instalaciones_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_instalaciones
    ADD CONSTRAINT tf_instalaciones_pkey PRIMARY KEY (id_instalacion);


--
-- Name: tf_institucion tf_institucion_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_institucion
    ADD CONSTRAINT tf_institucion_pkey PRIMARY KEY (id_institucion);


--
-- Name: tf_licencias tf_licencias_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_licencias
    ADD CONSTRAINT tf_licencias_pkey PRIMARY KEY (id);


--
-- Name: tf_lotes tf_lotes_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_lotes
    ADD CONSTRAINT tf_lotes_pkey PRIMARY KEY (id_lote);


--
-- Name: tf_manzanas tf_manzanas_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_manzanas
    ADD CONSTRAINT tf_manzanas_pkey PRIMARY KEY (id_mzna);


--
-- Name: tf_notarias tf_notarias_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_notarias
    ADD CONSTRAINT tf_notarias_pkey PRIMARY KEY (id_notaria);


--
-- Name: tf_personas tf_personas_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_personas
    ADD CONSTRAINT tf_personas_pkey PRIMARY KEY (id_persona);


--
-- Name: tf_puertas tf_puertas_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_puertas
    ADD CONSTRAINT tf_puertas_pkey PRIMARY KEY (id_puerta);


--
-- Name: tf_recap_bbcc tf_recap_bbcc_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_recap_bbcc
    ADD CONSTRAINT tf_recap_bbcc_pkey PRIMARY KEY (id_ficha, nume_registro);


--
-- Name: tf_sectores tf_sectores_codi_sector_unique; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_sectores
    ADD CONSTRAINT tf_sectores_codi_sector_unique UNIQUE (codi_sector);


--
-- Name: tf_sectores tf_sectores_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_sectores
    ADD CONSTRAINT tf_sectores_pkey PRIMARY KEY (id_sector);


--
-- Name: tf_tablas tf_tablas_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_tablas
    ADD CONSTRAINT tf_tablas_pkey PRIMARY KEY (id_tabla);


--
-- Name: tf_ubigeo tf_ubigeo_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_ubigeo
    ADD CONSTRAINT tf_ubigeo_pkey PRIMARY KEY (id_ubi_geo);


--
-- Name: tf_uni_cat tf_uni_cat_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_uni_cat
    ADD CONSTRAINT tf_uni_cat_pkey PRIMARY KEY (id_uni_cat);


--
-- Name: tf_usos_bc tf_usos_bc_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_usos_bc
    ADD CONSTRAINT tf_usos_bc_pkey PRIMARY KEY (codi_uso);


--
-- Name: tf_usos tf_usos_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_usos
    ADD CONSTRAINT tf_usos_pkey PRIMARY KEY (codi_uso);


--
-- Name: tf_usuarios tf_usuarios_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_usuarios
    ADD CONSTRAINT tf_usuarios_pkey PRIMARY KEY (id_usuario);


--
-- Name: tf_usuarios tf_usuarios_usuario_unique; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_usuarios
    ADD CONSTRAINT tf_usuarios_usuario_unique UNIQUE (usuario);


--
-- Name: tf_vias tf_vias_codi_via_unique; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_vias
    ADD CONSTRAINT tf_vias_codi_via_unique UNIQUE (codi_via);


--
-- Name: tf_vias tf_vias_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_vias
    ADD CONSTRAINT tf_vias_pkey PRIMARY KEY (id_via);


--
-- Name: titular_certificado_catastrals titular_certificado_catastrals_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.titular_certificado_catastrals
    ADD CONSTRAINT titular_certificado_catastrals_pkey PRIMARY KEY (id);


--
-- Name: titular_certificados titular_certificados_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.titular_certificados
    ADD CONSTRAINT titular_certificados_pkey PRIMARY KEY (id);


--
-- Name: ubicacion_certificado_catastrals ubicacion_certificado_catastrals_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.ubicacion_certificado_catastrals
    ADD CONSTRAINT ubicacion_certificado_catastrals_pkey PRIMARY KEY (id);


--
-- Name: ubicacion_certificados ubicacion_certificados_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.ubicacion_certificados
    ADD CONSTRAINT ubicacion_certificados_pkey PRIMARY KEY (id);


--
-- Name: tg_comercio tg_comercio_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_comercio
    ADD CONSTRAINT tg_comercio_pkey PRIMARY KEY (gid);


--
-- Name: tg_construccion tg_construccion_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_construccion
    ADD CONSTRAINT tg_construccion_pkey PRIMARY KEY (gid);


--
-- Name: tg_eje_via tg_eje_via_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_eje_via
    ADD CONSTRAINT tg_eje_via_pkey PRIMARY KEY (gid);


--
-- Name: tg_hab_urb tg_hab_urb_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_hab_urb
    ADD CONSTRAINT tg_hab_urb_pkey PRIMARY KEY (gid);


--
-- Name: tg_lote tg_lote_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_lote
    ADD CONSTRAINT tg_lote_pkey PRIMARY KEY (gid);


--
-- Name: tg_manzana tg_manzana_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_manzana
    ADD CONSTRAINT tg_manzana_pkey PRIMARY KEY (gid);


--
-- Name: tg_parque tg_parque_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_parque
    ADD CONSTRAINT tg_parque_pkey PRIMARY KEY (gid);


--
-- Name: tg_puerta tg_puerta_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_puerta
    ADD CONSTRAINT tg_puerta_pkey PRIMARY KEY (gid);


--
-- Name: tg_sector tg_sector_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_sector
    ADD CONSTRAINT tg_sector_pkey PRIMARY KEY (gid);


--
-- Name: tgh_comercio tgh_comercio_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_comercio
    ADD CONSTRAINT tgh_comercio_pkey PRIMARY KEY (id);


--
-- Name: tgh_construccion tgh_construccion_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_construccion
    ADD CONSTRAINT tgh_construccion_pkey PRIMARY KEY (id);


--
-- Name: tgh_eje_via tgh_eje_via_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_eje_via
    ADD CONSTRAINT tgh_eje_via_pkey PRIMARY KEY (id);


--
-- Name: tgh_hab_urb tgh_hab_urb_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_hab_urb
    ADD CONSTRAINT tgh_hab_urb_pkey PRIMARY KEY (id);


--
-- Name: tgh_lote tgh_lote_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_lote
    ADD CONSTRAINT tgh_lote_pkey PRIMARY KEY (id);


--
-- Name: tgh_manzana tgh_manzana_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_manzana
    ADD CONSTRAINT tgh_manzana_pkey PRIMARY KEY (id);


--
-- Name: tgh_parque tgh_parque_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_parque
    ADD CONSTRAINT tgh_parque_pkey PRIMARY KEY (id);


--
-- Name: tgh_puerta tgh_puerta_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_puerta
    ADD CONSTRAINT tgh_puerta_pkey PRIMARY KEY (id);


--
-- Name: tgh_sector tgh_sector_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_sector
    ADD CONSTRAINT tgh_sector_pkey PRIMARY KEY (id);


--
-- Name: departamento departamentos_pkey; Type: CONSTRAINT; Schema: ign; Owner: postgres
--

ALTER TABLE ONLY ign.departamento
    ADD CONSTRAINT departamentos_pkey PRIMARY KEY (gid);


--
-- Name: distrito distritos_pkey; Type: CONSTRAINT; Schema: ign; Owner: postgres
--

ALTER TABLE ONLY ign.distrito
    ADD CONSTRAINT distritos_pkey PRIMARY KEY (gid);


--
-- Name: provincia provincias_pkey; Type: CONSTRAINT; Schema: ign; Owner: postgres
--

ALTER TABLE ONLY ign.provincia
    ADD CONSTRAINT provincias_pkey PRIMARY KEY (gid);


--
-- Name: predio predios_pkey; Type: CONSTRAINT; Schema: sbn; Owner: postgres
--

ALTER TABLE ONLY sbn.predio
    ADD CONSTRAINT predios_pkey PRIMARY KEY (gid);


--
-- Name: tg_lote tg_lote_pkey; Type: CONSTRAINT; Schema: vinculacion; Owner: postgres
--

ALTER TABLE ONLY vinculacion.tg_lote
    ADD CONSTRAINT tg_lote_pkey PRIMARY KEY (id);


--
-- Name: audits_user_id_user_type_index; Type: INDEX; Schema: catastro; Owner: postgres
--

CREATE INDEX audits_user_id_user_type_index ON catastro.audits USING btree (user_id, user_type);


--
-- Name: model_has_permissions_model_id_model_type_index; Type: INDEX; Schema: catastro; Owner: postgres
--

CREATE INDEX model_has_permissions_model_id_model_type_index ON catastro.model_has_permissions USING btree (model_id, model_type);


--
-- Name: model_has_roles_model_id_model_type_index; Type: INDEX; Schema: catastro; Owner: postgres
--

CREATE INDEX model_has_roles_model_id_model_type_index ON catastro.model_has_roles USING btree (model_id, model_type);


--
-- Name: password_resets_email_index; Type: INDEX; Schema: catastro; Owner: postgres
--

CREATE INDEX password_resets_email_index ON catastro.password_resets USING btree (email);


--
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: catastro; Owner: postgres
--

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON catastro.personal_access_tokens USING btree (tokenable_type, tokenable_id);


--
-- Name: idx_tg_comercio_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_comercio_geom ON geo.tg_comercio USING gist (geom);


--
-- Name: idx_tg_construccion_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_construccion_geom ON geo.tg_construccion USING gist (geom);


--
-- Name: idx_tg_eje_via_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_eje_via_geom ON geo.tg_eje_via USING gist (geom);


--
-- Name: idx_tg_hab_urb_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_hab_urb_geom ON geo.tg_hab_urb USING gist (geom);


--
-- Name: idx_tg_lote_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_lote_geom ON geo.tg_lote USING gist (geom);


--
-- Name: idx_tg_manzana_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_manzana_geom ON geo.tg_manzana USING gist (geom);


--
-- Name: idx_tg_parque_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_parque_geom ON geo.tg_parque USING gist (geom);


--
-- Name: idx_tg_puerta_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_puerta_geom ON geo.tg_puerta USING gist (geom);


--
-- Name: idx_tg_sector_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_sector_geom ON geo.tg_sector USING gist (geom);


--
-- Name: idx_tgh_comercio_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_comercio_geom ON geo.tgh_comercio USING gist (geom);


--
-- Name: idx_tgh_construccion_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_construccion_geom ON geo.tgh_construccion USING gist (geom);


--
-- Name: idx_tgh_eje_via_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_eje_via_geom ON geo.tgh_eje_via USING gist (geom);


--
-- Name: idx_tgh_hab_urb_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_hab_urb_geom ON geo.tgh_hab_urb USING gist (geom);


--
-- Name: idx_tgh_lote_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_lote_geom ON geo.tgh_lote USING gist (geom);


--
-- Name: idx_tgh_manzana_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_manzana_geom ON geo.tgh_manzana USING gist (geom);


--
-- Name: idx_tgh_parque_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_parque_geom ON geo.tgh_parque USING gist (geom);


--
-- Name: idx_tgh_puerta_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_puerta_geom ON geo.tgh_puerta USING gist (geom);


--
-- Name: idx_tgh_sector_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_sector_geom ON geo.tgh_sector USING gist (geom);


--
-- Name: sidx_tg_lote_geom; Type: INDEX; Schema: vinculacion; Owner: postgres
--

CREATE INDEX sidx_tg_lote_geom ON vinculacion.tg_lote USING gist (geom);


--
-- Name: v_lote _RETURN; Type: RULE; Schema: geo; Owner: postgres
--

CREATE OR REPLACE VIEW geo.v_lote AS
 SELECT DISTINCT a.gid,
    b.id_ficha,
    c.imagen_plano AS fotografia,
    b.id_lote,
    a.cod_sector,
    a.cod_mzna,
    (((a.cod_sector)::text || (a.cod_mzna)::text) || (a.cod_lote)::text) AS lote_id,
    a.cod_lote,
        CASE
            WHEN ((b.id_lote IS NULL) AND (c.imagen_plano IS NULL)) THEN 0
            WHEN ((b.id_lote IS NULL) AND (c.imagen_plano IS NOT NULL)) THEN 1
            WHEN ((b.id_lote IS NOT NULL) AND (c.imagen_plano IS NULL)) THEN 2
            ELSE 3
        END AS existe,
        CASE
            WHEN (b.id_lote IS NULL) THEN 2
            ELSE 1
        END AS existe_ficha,
        CASE
            WHEN ((e.tipo_doc)::text = '0'::text) THEN 'RUC'::text
            WHEN ((e.tipo_doc)::text = '2'::text) THEN 'DNI'::text
            ELSE NULL::text
        END AS tipo_doc,
    e.nume_doc,
        CASE
            WHEN ((e.tipo_persona)::text = '1'::text) THEN 'PERSONA NATURAL'::text
            WHEN ((e.tipo_persona)::text = '2'::text) THEN 'PERSONA JURIDICA'::text
            ELSE NULL::text
        END AS tipo_persona,
        CASE
            WHEN ((e.tipo_persona)::text = '1'::text) THEN (((((e.ape_paterno)::text || ' '::text) || (e.ape_materno)::text) || ' '::text) || (e.nombres)::text)
            WHEN ((e.tipo_persona)::text = '2'::text) THEN (e.razon_social)::text
            ELSE NULL::text
        END AS ciudadano_razon_social,
    round((a.area_grafi)::numeric, 2) AS area_grafi,
    round((a.peri_grafi)::numeric, 2) AS peri_grafi,
    a.geom
   FROM ((((geo.tg_lote a
     LEFT JOIN catastro.tf_fichas b ON (((a.id_lote)::text = (b.id_lote)::text)))
     LEFT JOIN catastro.tf_fichas_individuales c ON (((b.id_ficha)::text = (c.id_ficha)::text)))
     LEFT JOIN catastro.tf_titulares d ON (((b.id_ficha)::text = (d.id_ficha)::text)))
     LEFT JOIN catastro.tf_personas e ON (((d.id_persona)::text = (e.id_persona)::text)))
  GROUP BY a.gid, b.id_ficha, c.imagen_plano, b.id_lote, a.cod_sector, a.cod_mzna, (((a.cod_sector)::text || (a.cod_mzna)::text) || (a.cod_lote)::text), a.cod_lote,
        CASE
            WHEN ((b.id_lote IS NULL) AND (c.imagen_plano IS NULL)) THEN 0
            WHEN ((b.id_lote IS NULL) AND (c.imagen_plano IS NOT NULL)) THEN 1
            WHEN ((b.id_lote IS NOT NULL) AND (c.imagen_plano IS NULL)) THEN 2
            ELSE 3
        END,
        CASE
            WHEN (b.id_lote IS NULL) THEN 2
            ELSE 1
        END,
        CASE
            WHEN ((e.tipo_doc)::text = '0'::text) THEN 'RUC'::text
            WHEN ((e.tipo_doc)::text = '2'::text) THEN 'DNI'::text
            ELSE NULL::text
        END, e.nume_doc,
        CASE
            WHEN ((e.tipo_persona)::text = '1'::text) THEN 'PERSONA NATURAL'::text
            WHEN ((e.tipo_persona)::text = '2'::text) THEN 'PERSONA JURIDICA'::text
            ELSE NULL::text
        END,
        CASE
            WHEN ((e.tipo_persona)::text = '1'::text) THEN (((((e.ape_paterno)::text || ' '::text) || (e.ape_materno)::text) || ' '::text) || (e.nombres)::text)
            WHEN ((e.tipo_persona)::text = '2'::text) THEN (e.razon_social)::text
            ELSE NULL::text
        END, (round((a.area_grafi)::numeric, 2))
  ORDER BY
        CASE
            WHEN (b.id_lote IS NULL) THEN 2
            ELSE 1
        END;


--
-- Name: v_lotes _RETURN; Type: RULE; Schema: geo; Owner: postgres
--

CREATE OR REPLACE VIEW geo.v_lotes AS
 SELECT DISTINCT a.gid,
    b.id_ficha,
    c.imagen_plano AS fotografia,
    b.id_lote,
    a.cod_sector,
    a.cod_mzna,
    (((a.cod_sector)::text || (a.cod_mzna)::text) || (a.cod_lote)::text) AS lotes_id,
    a.cod_lote,
        CASE
            WHEN ((b.id_lote IS NULL) AND (c.imagen_plano IS NULL)) THEN 0
            WHEN ((b.id_lote IS NULL) AND (c.imagen_plano IS NOT NULL)) THEN 1
            WHEN ((b.id_lote IS NOT NULL) AND (c.imagen_plano IS NULL)) THEN 2
            ELSE 3
        END AS existe,
        CASE
            WHEN (b.id_lote IS NULL) THEN 2
            ELSE 1
        END AS existe_ficha,
        CASE
            WHEN ((e.tipo_doc)::text = '0'::text) THEN 'RUC'::text
            WHEN ((e.tipo_doc)::text = '2'::text) THEN 'DNI'::text
            ELSE NULL::text
        END AS tipo_doc,
    e.nume_doc,
        CASE
            WHEN ((e.tipo_persona)::text = '1'::text) THEN 'PERSONA NATURAL'::text
            WHEN ((e.tipo_persona)::text = '2'::text) THEN 'PERSONA JURIDICA'::text
            ELSE NULL::text
        END AS tipo_persona,
        CASE
            WHEN ((e.tipo_persona)::text = '1'::text) THEN (((((e.ape_paterno)::text || ' '::text) || (e.ape_materno)::text) || ' '::text) || (e.nombres)::text)
            WHEN ((e.tipo_persona)::text = '2'::text) THEN (e.razon_social)::text
            ELSE NULL::text
        END AS ciudadano_razon_social,
    round((a.area_grafi)::numeric, 2) AS area_grafi,
    round((a.peri_grafi)::numeric, 2) AS peri_grafi,
    a.geom
   FROM ((((geo.tg_lote a
     LEFT JOIN catastro.tf_fichas b ON (((a.id_lote)::text = (b.id_lote)::text)))
     LEFT JOIN catastro.tf_fichas_individuales c ON (((b.id_ficha)::text = (c.id_ficha)::text)))
     LEFT JOIN catastro.tf_titulares d ON (((b.id_ficha)::text = (d.id_ficha)::text)))
     LEFT JOIN catastro.tf_personas e ON (((d.id_persona)::text = (e.id_persona)::text)))
  GROUP BY a.gid, b.id_ficha, c.imagen_plano, b.id_lote, a.cod_sector, a.cod_mzna, (((a.cod_sector)::text || (a.cod_mzna)::text) || (a.cod_lote)::text), a.cod_lote,
        CASE
            WHEN ((b.id_lote IS NULL) AND (c.imagen_plano IS NULL)) THEN 0
            WHEN ((b.id_lote IS NULL) AND (c.imagen_plano IS NOT NULL)) THEN 1
            WHEN ((b.id_lote IS NOT NULL) AND (c.imagen_plano IS NULL)) THEN 2
            ELSE 3
        END,
        CASE
            WHEN (b.id_lote IS NULL) THEN 2
            ELSE 1
        END,
        CASE
            WHEN ((e.tipo_doc)::text = '0'::text) THEN 'RUC'::text
            WHEN ((e.tipo_doc)::text = '2'::text) THEN 'DNI'::text
            ELSE NULL::text
        END, e.nume_doc,
        CASE
            WHEN ((e.tipo_persona)::text = '1'::text) THEN 'PERSONA NATURAL'::text
            WHEN ((e.tipo_persona)::text = '2'::text) THEN 'PERSONA JURIDICA'::text
            ELSE NULL::text
        END,
        CASE
            WHEN ((e.tipo_persona)::text = '1'::text) THEN (((((e.ape_paterno)::text || ' '::text) || (e.ape_materno)::text) || ' '::text) || (e.nombres)::text)
            WHEN ((e.tipo_persona)::text = '2'::text) THEN (e.razon_social)::text
            ELSE NULL::text
        END, (round((a.area_grafi)::numeric, 2))
  ORDER BY
        CASE
            WHEN (b.id_lote IS NULL) THEN 2
            ELSE 1
        END;


--
-- Name: archivos archivos_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.archivos
    ADD CONSTRAINT archivos_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha);


--
-- Name: c_hoja_informativas c_hoja_informativas_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.c_hoja_informativas
    ADD CONSTRAINT c_hoja_informativas_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: c_numeracions c_numeracions_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.c_numeracions
    ADD CONSTRAINT c_numeracions_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: construccion_certificados construccion_certificados_certificado_id_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.construccion_certificados
    ADD CONSTRAINT construccion_certificados_certificado_id_foreign FOREIGN KEY (certificado_id) REFERENCES catastro.generar_certificados(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: generar_certificados generar_certificados_id_usuario_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.generar_certificados
    ADD CONSTRAINT generar_certificados_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES catastro.tf_usuarios(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: generar_numeracions generar_numeracions_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.generar_numeracions
    ADD CONSTRAINT generar_numeracions_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: imagenes imagenes_id_lote_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.imagenes
    ADD CONSTRAINT imagenes_id_lote_foreign FOREIGN KEY (id_lote) REFERENCES catastro.tf_lotes(id_lote);


--
-- Name: imagenes imagenes_id_usuario_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.imagenes
    ADD CONSTRAINT imagenes_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES catastro.tf_usuarios(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: model_has_permissions model_has_permissions_permission_id_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES catastro.permissions(id) ON DELETE CASCADE;


--
-- Name: model_has_roles model_has_roles_role_id_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES catastro.roles(id) ON DELETE CASCADE;


--
-- Name: role_has_permissions role_has_permissions_permission_id_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES catastro.permissions(id) ON DELETE CASCADE;


--
-- Name: role_has_permissions role_has_permissions_role_id_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES catastro.roles(id) ON DELETE CASCADE;


--
-- Name: tf_afectacion_antropica tf_afectacion_antropica_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_afectacion_antropica
    ADD CONSTRAINT tf_afectacion_antropica_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_afectacion_natural tf_afectacion_natural_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_afectacion_natural
    ADD CONSTRAINT tf_afectacion_natural_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_agricola_predio tf_agricola_predio_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_agricola_predio
    ADD CONSTRAINT tf_agricola_predio_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_autorizaciones_anuncios tf_autorizaciones_anuncios_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_autorizaciones_anuncios
    ADD CONSTRAINT tf_autorizaciones_anuncios_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_autorizaciones_funcionamiento tf_autorizaciones_funcionamiento_codi_actividad_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_autorizaciones_funcionamiento
    ADD CONSTRAINT tf_autorizaciones_funcionamiento_codi_actividad_foreign FOREIGN KEY (codi_actividad) REFERENCES catastro.tf_actividades(codi_actividad) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_autorizaciones_funcionamiento tf_autorizaciones_funcionamiento_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_autorizaciones_funcionamiento
    ADD CONSTRAINT tf_autorizaciones_funcionamiento_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_caracteristicas_rural tf_caracteristicas_rural_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_caracteristicas_rural
    ADD CONSTRAINT tf_caracteristicas_rural_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_colonial tf_colonial_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_colonial
    ADD CONSTRAINT tf_colonial_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_condicion_predio tf_condicion_predio_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_condicion_predio
    ADD CONSTRAINT tf_condicion_predio_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_conductores tf_conductores_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_conductores
    ADD CONSTRAINT tf_conductores_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_conductores tf_conductores_id_persona_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_conductores
    ADD CONSTRAINT tf_conductores_id_persona_foreign FOREIGN KEY (id_persona) REFERENCES catastro.tf_personas(id_persona) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_construcciones tf_construcciones_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_construcciones
    ADD CONSTRAINT tf_construcciones_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_documento_posesion tf_documento_posesion_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_documento_posesion
    ADD CONSTRAINT tf_documento_posesion_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_documentos_adjuntos tf_documentos_adjuntos_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_documentos_adjuntos
    ADD CONSTRAINT tf_documentos_adjuntos_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_domicilio_titulares tf_domicilio_titulares_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_domicilio_titulares
    ADD CONSTRAINT tf_domicilio_titulares_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_domicilio_titulares tf_domicilio_titulares_id_persona_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_domicilio_titulares
    ADD CONSTRAINT tf_domicilio_titulares_id_persona_foreign FOREIGN KEY (id_persona) REFERENCES catastro.tf_personas(id_persona) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_edificaciones tf_edificaciones_id_lote_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_edificaciones
    ADD CONSTRAINT tf_edificaciones_id_lote_foreign FOREIGN KEY (id_lote) REFERENCES catastro.tf_lotes(id_lote) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_elemento_arquitectonico tf_elemento_arquitectonico_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_elemento_arquitectonico
    ADD CONSTRAINT tf_elemento_arquitectonico_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_estado_elemento tf_estado_elemento_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_estado_elemento
    ADD CONSTRAINT tf_estado_elemento_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_exoneraciones_predio tf_exoneraciones_predio_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_exoneraciones_predio
    ADD CONSTRAINT tf_exoneraciones_predio_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_exoneraciones_titular tf_exoneraciones_titular_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_exoneraciones_titular
    ADD CONSTRAINT tf_exoneraciones_titular_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_exoneraciones_titular tf_exoneraciones_titular_id_persona_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_exoneraciones_titular
    ADD CONSTRAINT tf_exoneraciones_titular_id_persona_foreign FOREIGN KEY (id_persona) REFERENCES catastro.tf_personas(id_persona) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_ficha_bien_cultural tf_ficha_bien_cultural_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_ficha_bien_cultural
    ADD CONSTRAINT tf_ficha_bien_cultural_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_ficha_rural tf_ficha_rural_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_ficha_rural
    ADD CONSTRAINT tf_ficha_rural_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_fichas_bienes_comunes tf_fichas_bienes_comunes_codi_uso_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_fichas_bienes_comunes
    ADD CONSTRAINT tf_fichas_bienes_comunes_codi_uso_foreign FOREIGN KEY (codi_uso) REFERENCES catastro.tf_usos_bc(codi_uso) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_fichas_bienes_comunes tf_fichas_bienes_comunes_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_fichas_bienes_comunes
    ADD CONSTRAINT tf_fichas_bienes_comunes_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_fichas_cotitularidades tf_fichas_cotitularidades_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_fichas_cotitularidades
    ADD CONSTRAINT tf_fichas_cotitularidades_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_fichas_economicas tf_fichas_economicas_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_fichas_economicas
    ADD CONSTRAINT tf_fichas_economicas_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_fichas tf_fichas_id_declarante_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_fichas
    ADD CONSTRAINT tf_fichas_id_declarante_foreign FOREIGN KEY (id_declarante) REFERENCES catastro.tf_personas(id_persona) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_fichas tf_fichas_id_supervisor_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_fichas
    ADD CONSTRAINT tf_fichas_id_supervisor_foreign FOREIGN KEY (id_supervisor) REFERENCES catastro.tf_personas(id_persona) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_fichas tf_fichas_id_tecnico_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_fichas
    ADD CONSTRAINT tf_fichas_id_tecnico_foreign FOREIGN KEY (id_tecnico) REFERENCES catastro.tf_personas(id_persona) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_fichas tf_fichas_id_uni_cat_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_fichas
    ADD CONSTRAINT tf_fichas_id_uni_cat_foreign FOREIGN KEY (id_uni_cat) REFERENCES catastro.tf_uni_cat(id_uni_cat) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_fichas tf_fichas_id_usuario_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_fichas
    ADD CONSTRAINT tf_fichas_id_usuario_foreign FOREIGN KEY (id_usuario) REFERENCES catastro.tf_usuarios(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_fichas tf_fichas_id_verificador_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_fichas
    ADD CONSTRAINT tf_fichas_id_verificador_foreign FOREIGN KEY (id_verificador) REFERENCES catastro.tf_personas(id_persona) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_fichas_individuales tf_fichas_individuales_codi_uso_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_fichas_individuales
    ADD CONSTRAINT tf_fichas_individuales_codi_uso_foreign FOREIGN KEY (codi_uso) REFERENCES catastro.tf_usos(codi_uso) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_fichas_individuales tf_fichas_individuales_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_fichas_individuales
    ADD CONSTRAINT tf_fichas_individuales_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_ganaderia_rural tf_ganaderia_rural_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_ganaderia_rural
    ADD CONSTRAINT tf_ganaderia_rural_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_hab_urbana tf_hab_urbana_id_ubi_geo_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_hab_urbana
    ADD CONSTRAINT tf_hab_urbana_id_ubi_geo_foreign FOREIGN KEY (id_ubi_geo) REFERENCES catastro.tf_ubigeo(id_ubi_geo) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_historia_via tf_historia_via_id_via_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_historia_via
    ADD CONSTRAINT tf_historia_via_id_via_foreign FOREIGN KEY (id_via) REFERENCES catastro.tf_vias(id_via) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_ingresos tf_ingresos_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_ingresos
    ADD CONSTRAINT tf_ingresos_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_ingresos tf_ingresos_id_puerta_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_ingresos
    ADD CONSTRAINT tf_ingresos_id_puerta_foreign FOREIGN KEY (id_puerta) REFERENCES catastro.tf_puertas(id_puerta) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_instalacion_rural tf_instalacion_rural_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_instalacion_rural
    ADD CONSTRAINT tf_instalacion_rural_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_instalaciones tf_instalaciones_codi_instalacion_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_instalaciones
    ADD CONSTRAINT tf_instalaciones_codi_instalacion_foreign FOREIGN KEY (codi_instalacion) REFERENCES catastro.tf_codigos_instalaciones(codi_instalacion) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_instalaciones tf_instalaciones_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_instalaciones
    ADD CONSTRAINT tf_instalaciones_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_intervencion tf_intervencion_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_intervencion
    ADD CONSTRAINT tf_intervencion_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_linderos tf_linderos_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_linderos
    ADD CONSTRAINT tf_linderos_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_litigantes tf_litigantes_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_litigantes
    ADD CONSTRAINT tf_litigantes_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_litigantes tf_litigantes_id_persona_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_litigantes
    ADD CONSTRAINT tf_litigantes_id_persona_foreign FOREIGN KEY (id_persona) REFERENCES catastro.tf_personas(id_persona) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_lotes tf_lotes_id_mzna_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_lotes
    ADD CONSTRAINT tf_lotes_id_mzna_foreign FOREIGN KEY (id_mzna) REFERENCES catastro.tf_manzanas(id_mzna) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_manzanas tf_manzanas_id_sector_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_manzanas
    ADD CONSTRAINT tf_manzanas_id_sector_foreign FOREIGN KEY (id_sector) REFERENCES catastro.tf_sectores(id_sector) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_monumento tf_monumento_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_monumento
    ADD CONSTRAINT tf_monumento_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_norma_legal tf_norma_legal_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_norma_legal
    ADD CONSTRAINT tf_norma_legal_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_notarias tf_notarias_id_ubi_geo_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_notarias
    ADD CONSTRAINT tf_notarias_id_ubi_geo_foreign FOREIGN KEY (id_ubi_geo) REFERENCES catastro.tf_ubigeo(id_ubi_geo) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_puertas tf_puertas_id_lote_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_puertas
    ADD CONSTRAINT tf_puertas_id_lote_foreign FOREIGN KEY (id_lote) REFERENCES catastro.tf_lotes(id_lote) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_puertas tf_puertas_id_via_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_puertas
    ADD CONSTRAINT tf_puertas_id_via_foreign FOREIGN KEY (id_via) REFERENCES catastro.tf_vias(id_via) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_recap_bbcc tf_recap_bbcc_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_recap_bbcc
    ADD CONSTRAINT tf_recap_bbcc_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_recap_edificio tf_recap_edificio_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_recap_edificio
    ADD CONSTRAINT tf_recap_edificio_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_registro_legal tf_registro_legal_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_registro_legal
    ADD CONSTRAINT tf_registro_legal_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_registro_legal tf_registro_legal_id_notaria_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_registro_legal
    ADD CONSTRAINT tf_registro_legal_id_notaria_foreign FOREIGN KEY (id_notaria) REFERENCES catastro.tf_notarias(id_notaria) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_sectores tf_sectores_id_ubi_geo_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_sectores
    ADD CONSTRAINT tf_sectores_id_ubi_geo_foreign FOREIGN KEY (id_ubi_geo) REFERENCES catastro.tf_ubigeo(id_ubi_geo) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_servicios_basicos tf_servicios_basicos_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_servicios_basicos
    ADD CONSTRAINT tf_servicios_basicos_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_sunarp tf_sunarp_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_sunarp
    ADD CONSTRAINT tf_sunarp_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_tablas_codigos tf_tablas_codigos_id_tabla_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_tablas_codigos
    ADD CONSTRAINT tf_tablas_codigos_id_tabla_foreign FOREIGN KEY (id_tabla) REFERENCES catastro.tf_tablas(id_tabla) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_titulares tf_titulares_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_titulares
    ADD CONSTRAINT tf_titulares_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_titulares tf_titulares_id_persona_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_titulares
    ADD CONSTRAINT tf_titulares_id_persona_foreign FOREIGN KEY (id_persona) REFERENCES catastro.tf_personas(id_persona) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_uni_cat tf_uni_cat_id_edificacion_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_uni_cat
    ADD CONSTRAINT tf_uni_cat_id_edificacion_foreign FOREIGN KEY (id_edificacion) REFERENCES catastro.tf_edificaciones(id_edificacion) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_vias_hab_urba tf_vias_hab_urba_id_hab_urba_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_vias_hab_urba
    ADD CONSTRAINT tf_vias_hab_urba_id_hab_urba_foreign FOREIGN KEY (id_hab_urba) REFERENCES catastro.tf_hab_urbana(id_hab_urba) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tf_vias_hab_urba tf_vias_hab_urba_id_via_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_vias_hab_urba
    ADD CONSTRAINT tf_vias_hab_urba_id_via_foreign FOREIGN KEY (id_via) REFERENCES catastro.tf_vias(id_via) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tipo_arquitecturas tipo_arquitecturas_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tipo_arquitecturas
    ADD CONSTRAINT tipo_arquitecturas_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tipo_materials tipo_materials_id_ficha_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tipo_materials
    ADD CONSTRAINT tipo_materials_id_ficha_foreign FOREIGN KEY (id_ficha) REFERENCES catastro.tf_fichas(id_ficha) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: titular_certificado_catastrals titular_certificado_catastrals_certificado_id_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.titular_certificado_catastrals
    ADD CONSTRAINT titular_certificado_catastrals_certificado_id_foreign FOREIGN KEY (certificado_id) REFERENCES catastro.generar_certificados(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: titular_certificados titular_certificados_certificado_id_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.titular_certificados
    ADD CONSTRAINT titular_certificados_certificado_id_foreign FOREIGN KEY (certificado_id) REFERENCES catastro.generar_numeracions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ubicacion_certificado_catastrals ubicacion_certificado_catastrals_certificado_id_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.ubicacion_certificado_catastrals
    ADD CONSTRAINT ubicacion_certificado_catastrals_certificado_id_foreign FOREIGN KEY (certificado_id) REFERENCES catastro.generar_certificados(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ubicacion_certificado_catastrals ubicacion_certificado_catastrals_via_id_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.ubicacion_certificado_catastrals
    ADD CONSTRAINT ubicacion_certificado_catastrals_via_id_foreign FOREIGN KEY (via_id) REFERENCES catastro.tf_vias(id_via) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ubicacion_certificados ubicacion_certificados_certificado_id_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.ubicacion_certificados
    ADD CONSTRAINT ubicacion_certificados_certificado_id_foreign FOREIGN KEY (certificado_id) REFERENCES catastro.generar_numeracions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ubicacion_certificados ubicacion_certificados_via_id_foreign; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.ubicacion_certificados
    ADD CONSTRAINT ubicacion_certificados_via_id_foreign FOREIGN KEY (via_id) REFERENCES catastro.tf_vias(id_via) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict ZOpf0WltR96KmvbTfJ6NWFXFkf9ahjWWMsxnUjFGPlh18SOhIhJJfmNuAnptgJS

