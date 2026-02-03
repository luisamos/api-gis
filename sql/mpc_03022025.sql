--
-- PostgreSQL database dump
--

\restrict u9yNazjFbxkZJRe4wqlK3D74xDen3A2uMk14iC9ijYeJuZBvQpDGcyLaMPfekxN

-- Dumped from database version 17.7
-- Dumped by pg_dump version 18.0

-- Started on 2026-02-03 06:45:41

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 8 (class 2615 OID 74420)
-- Name: catastro; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA catastro;


ALTER SCHEMA catastro OWNER TO postgres;

--
-- TOC entry 7 (class 2615 OID 74419)
-- Name: geo; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA geo;


ALTER SCHEMA geo OWNER TO postgres;

--
-- TOC entry 2 (class 3079 OID 73333)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- TOC entry 6057 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 227 (class 1259 OID 74427)
-- Name: permissions; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.permissions (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    guard_name character varying(255) NOT NULL,
    categoria character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE catastro.permissions OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 74426)
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
-- TOC entry 6058 (class 0 OID 0)
-- Dependencies: 226
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.permissions_id_seq OWNED BY catastro.permissions.id;


--
-- TOC entry 268 (class 1259 OID 74637)
-- Name: role_has_permissions; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.role_has_permissions (
    permission_id bigint NOT NULL,
    role_id bigint NOT NULL
);


ALTER TABLE catastro.role_has_permissions OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 74438)
-- Name: roles; Type: TABLE; Schema: catastro; Owner: postgres
--

CREATE TABLE catastro.roles (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    guard_name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE catastro.roles OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 74437)
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
-- TOC entry 6059 (class 0 OID 0)
-- Dependencies: 228
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.roles_id_seq OWNED BY catastro.roles.id;


--
-- TOC entry 231 (class 1259 OID 74447)
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
-- TOC entry 230 (class 1259 OID 74446)
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
-- TOC entry 6060 (class 0 OID 0)
-- Dependencies: 230
-- Name: tf_usuarios_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: catastro; Owner: postgres
--

ALTER SEQUENCE catastro.tf_usuarios_id_usuario_seq OWNED BY catastro.tf_usuarios.id_usuario;


--
-- TOC entry 233 (class 1259 OID 74458)
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
-- TOC entry 232 (class 1259 OID 74457)
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
-- TOC entry 6061 (class 0 OID 0)
-- Dependencies: 232
-- Name: tg_comercio_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_comercio_gid_seq OWNED BY geo.tg_comercio.gid;


--
-- TOC entry 235 (class 1259 OID 74468)
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
-- TOC entry 234 (class 1259 OID 74467)
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
-- TOC entry 6062 (class 0 OID 0)
-- Dependencies: 234
-- Name: tg_construccion_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_construccion_gid_seq OWNED BY geo.tg_construccion.gid;


--
-- TOC entry 237 (class 1259 OID 74478)
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
-- TOC entry 236 (class 1259 OID 74477)
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
-- TOC entry 6063 (class 0 OID 0)
-- Dependencies: 236
-- Name: tg_eje_via_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_eje_via_gid_seq OWNED BY geo.tg_eje_via.gid;


--
-- TOC entry 239 (class 1259 OID 74488)
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
-- TOC entry 238 (class 1259 OID 74487)
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
-- TOC entry 6064 (class 0 OID 0)
-- Dependencies: 238
-- Name: tg_hab_urb_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_hab_urb_gid_seq OWNED BY geo.tg_hab_urb.gid;


--
-- TOC entry 241 (class 1259 OID 74498)
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
-- TOC entry 240 (class 1259 OID 74497)
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
-- TOC entry 6065 (class 0 OID 0)
-- Dependencies: 240
-- Name: tg_lote_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_lote_gid_seq OWNED BY geo.tg_lote.gid;


--
-- TOC entry 243 (class 1259 OID 74508)
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
-- TOC entry 242 (class 1259 OID 74507)
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
-- TOC entry 6066 (class 0 OID 0)
-- Dependencies: 242
-- Name: tg_manzana_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_manzana_gid_seq OWNED BY geo.tg_manzana.gid;


--
-- TOC entry 245 (class 1259 OID 74518)
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
-- TOC entry 244 (class 1259 OID 74517)
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
-- TOC entry 6067 (class 0 OID 0)
-- Dependencies: 244
-- Name: tg_parque_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_parque_gid_seq OWNED BY geo.tg_parque.gid;


--
-- TOC entry 247 (class 1259 OID 74528)
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
-- TOC entry 246 (class 1259 OID 74527)
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
-- TOC entry 6068 (class 0 OID 0)
-- Dependencies: 246
-- Name: tg_puerta_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_puerta_gid_seq OWNED BY geo.tg_puerta.gid;


--
-- TOC entry 249 (class 1259 OID 74538)
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
-- TOC entry 248 (class 1259 OID 74537)
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
-- TOC entry 6069 (class 0 OID 0)
-- Dependencies: 248
-- Name: tg_sector_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_sector_gid_seq OWNED BY geo.tg_sector.gid;


--
-- TOC entry 251 (class 1259 OID 74548)
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
-- TOC entry 250 (class 1259 OID 74547)
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
-- TOC entry 6070 (class 0 OID 0)
-- Dependencies: 250
-- Name: tgh_comercio_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_comercio_id_seq OWNED BY geo.tgh_comercio.id;


--
-- TOC entry 253 (class 1259 OID 74558)
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
-- TOC entry 252 (class 1259 OID 74557)
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
-- TOC entry 6071 (class 0 OID 0)
-- Dependencies: 252
-- Name: tgh_construccion_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_construccion_id_seq OWNED BY geo.tgh_construccion.id;


--
-- TOC entry 255 (class 1259 OID 74568)
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
-- TOC entry 254 (class 1259 OID 74567)
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
-- TOC entry 6072 (class 0 OID 0)
-- Dependencies: 254
-- Name: tgh_eje_via_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_eje_via_id_seq OWNED BY geo.tgh_eje_via.id;


--
-- TOC entry 257 (class 1259 OID 74578)
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
-- TOC entry 256 (class 1259 OID 74577)
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
-- TOC entry 6073 (class 0 OID 0)
-- Dependencies: 256
-- Name: tgh_hab_urb_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_hab_urb_id_seq OWNED BY geo.tgh_hab_urb.id;


--
-- TOC entry 259 (class 1259 OID 74588)
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
-- TOC entry 258 (class 1259 OID 74587)
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
-- TOC entry 6074 (class 0 OID 0)
-- Dependencies: 258
-- Name: tgh_lote_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_lote_id_seq OWNED BY geo.tgh_lote.id;


--
-- TOC entry 261 (class 1259 OID 74598)
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
-- TOC entry 260 (class 1259 OID 74597)
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
-- TOC entry 6075 (class 0 OID 0)
-- Dependencies: 260
-- Name: tgh_manzana_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_manzana_id_seq OWNED BY geo.tgh_manzana.id;


--
-- TOC entry 263 (class 1259 OID 74608)
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
-- TOC entry 262 (class 1259 OID 74607)
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
-- TOC entry 6076 (class 0 OID 0)
-- Dependencies: 262
-- Name: tgh_parque_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_parque_id_seq OWNED BY geo.tgh_parque.id;


--
-- TOC entry 265 (class 1259 OID 74618)
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
-- TOC entry 264 (class 1259 OID 74617)
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
-- TOC entry 6077 (class 0 OID 0)
-- Dependencies: 264
-- Name: tgh_puerta_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_puerta_id_seq OWNED BY geo.tgh_puerta.id;


--
-- TOC entry 267 (class 1259 OID 74628)
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
-- TOC entry 266 (class 1259 OID 74627)
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
-- TOC entry 6078 (class 0 OID 0)
-- Dependencies: 266
-- Name: tgh_sector_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_sector_id_seq OWNED BY geo.tgh_sector.id;


--
-- TOC entry 225 (class 1259 OID 74421)
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- TOC entry 5764 (class 2604 OID 74430)
-- Name: permissions id; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.permissions ALTER COLUMN id SET DEFAULT nextval('catastro.permissions_id_seq'::regclass);


--
-- TOC entry 5765 (class 2604 OID 74441)
-- Name: roles id; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.roles ALTER COLUMN id SET DEFAULT nextval('catastro.roles_id_seq'::regclass);


--
-- TOC entry 5766 (class 2604 OID 74450)
-- Name: tf_usuarios id_usuario; Type: DEFAULT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_usuarios ALTER COLUMN id_usuario SET DEFAULT nextval('catastro.tf_usuarios_id_usuario_seq'::regclass);


--
-- TOC entry 5767 (class 2604 OID 74461)
-- Name: tg_comercio gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_comercio ALTER COLUMN gid SET DEFAULT nextval('geo.tg_comercio_gid_seq'::regclass);


--
-- TOC entry 5768 (class 2604 OID 74471)
-- Name: tg_construccion gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_construccion ALTER COLUMN gid SET DEFAULT nextval('geo.tg_construccion_gid_seq'::regclass);


--
-- TOC entry 5769 (class 2604 OID 74481)
-- Name: tg_eje_via gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_eje_via ALTER COLUMN gid SET DEFAULT nextval('geo.tg_eje_via_gid_seq'::regclass);


--
-- TOC entry 5770 (class 2604 OID 74491)
-- Name: tg_hab_urb gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_hab_urb ALTER COLUMN gid SET DEFAULT nextval('geo.tg_hab_urb_gid_seq'::regclass);


--
-- TOC entry 5771 (class 2604 OID 74501)
-- Name: tg_lote gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_lote ALTER COLUMN gid SET DEFAULT nextval('geo.tg_lote_gid_seq'::regclass);


--
-- TOC entry 5772 (class 2604 OID 74511)
-- Name: tg_manzana gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_manzana ALTER COLUMN gid SET DEFAULT nextval('geo.tg_manzana_gid_seq'::regclass);


--
-- TOC entry 5773 (class 2604 OID 74521)
-- Name: tg_parque gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_parque ALTER COLUMN gid SET DEFAULT nextval('geo.tg_parque_gid_seq'::regclass);


--
-- TOC entry 5774 (class 2604 OID 74531)
-- Name: tg_puerta gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_puerta ALTER COLUMN gid SET DEFAULT nextval('geo.tg_puerta_gid_seq'::regclass);


--
-- TOC entry 5775 (class 2604 OID 74541)
-- Name: tg_sector gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_sector ALTER COLUMN gid SET DEFAULT nextval('geo.tg_sector_gid_seq'::regclass);


--
-- TOC entry 5776 (class 2604 OID 74551)
-- Name: tgh_comercio id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_comercio ALTER COLUMN id SET DEFAULT nextval('geo.tgh_comercio_id_seq'::regclass);


--
-- TOC entry 5777 (class 2604 OID 74561)
-- Name: tgh_construccion id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_construccion ALTER COLUMN id SET DEFAULT nextval('geo.tgh_construccion_id_seq'::regclass);


--
-- TOC entry 5778 (class 2604 OID 74571)
-- Name: tgh_eje_via id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_eje_via ALTER COLUMN id SET DEFAULT nextval('geo.tgh_eje_via_id_seq'::regclass);


--
-- TOC entry 5779 (class 2604 OID 74581)
-- Name: tgh_hab_urb id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_hab_urb ALTER COLUMN id SET DEFAULT nextval('geo.tgh_hab_urb_id_seq'::regclass);


--
-- TOC entry 5780 (class 2604 OID 74591)
-- Name: tgh_lote id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_lote ALTER COLUMN id SET DEFAULT nextval('geo.tgh_lote_id_seq'::regclass);


--
-- TOC entry 5781 (class 2604 OID 74601)
-- Name: tgh_manzana id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_manzana ALTER COLUMN id SET DEFAULT nextval('geo.tgh_manzana_id_seq'::regclass);


--
-- TOC entry 5782 (class 2604 OID 74611)
-- Name: tgh_parque id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_parque ALTER COLUMN id SET DEFAULT nextval('geo.tgh_parque_id_seq'::regclass);


--
-- TOC entry 5783 (class 2604 OID 74621)
-- Name: tgh_puerta id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_puerta ALTER COLUMN id SET DEFAULT nextval('geo.tgh_puerta_id_seq'::regclass);


--
-- TOC entry 5784 (class 2604 OID 74631)
-- Name: tgh_sector id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_sector ALTER COLUMN id SET DEFAULT nextval('geo.tgh_sector_id_seq'::regclass);


--
-- TOC entry 6010 (class 0 OID 74427)
-- Dependencies: 227
-- Data for Name: permissions; Type: TABLE DATA; Schema: catastro; Owner: postgres
--

COPY catastro.permissions (id, name, description, guard_name, categoria, created_at, updated_at) FROM stdin;
1	ficha.editrentasindividual	Editar Codigo de Contribuyente	web	Editar	2024-11-13 07:39:30	2024-11-13 07:39:30
2	dashboard	Ver Estadisticas	web	Ver	2024-11-13 07:39:30	2024-11-13 07:39:30
3	user.index	Ver la lista de Usuarios	web	Ver	2024-11-13 07:39:30	2024-11-13 07:39:30
4	user.create	Crear Usuarios	web	Crear	2024-11-13 07:39:30	2024-11-13 07:39:30
5	user.destroy	Cambiar estado de Usuarios	web	Eliminar	2024-11-13 07:39:30	2024-11-13 07:39:30
6	user.show	Mostrar Usuarios	web	Ver	2024-11-13 07:39:30	2024-11-13 07:39:30
7	user.edit	Editar Usuarios	web	Editar	2024-11-13 07:39:30	2024-11-13 07:39:30
8	roles.index	Ver la lista de Roles	web	Ver	2024-11-13 07:39:30	2024-11-13 07:39:30
9	roles.edit	Editar Roles	web	Editar	2024-11-13 07:39:30	2024-11-13 07:39:30
10	roles.destroy	Eliminar Roles	web	Eliminar	2024-11-13 07:39:30	2024-11-13 07:39:30
11	roles.create	Crear Roles	web	Crear	2024-11-13 07:39:30	2024-11-13 07:39:30
12	manzana.index	Ver la lista de Manzanas	web	Ver	2024-11-13 07:39:30	2024-11-13 07:39:30
13	manzana.edit	Editar datos de Manzanas	web	Editar	2024-11-13 07:39:30	2024-11-13 07:39:30
14	manzana.destroy	Cambiar estado de Usuarios	web	Eliminar	2024-11-13 07:39:30	2024-11-13 07:39:30
15	manzana.create	Crear Manzanas	web	Crear	2024-11-13 07:39:30	2024-11-13 07:39:30
16	sectore.index	Ver la lista de Sectores	web	Ver	2024-11-13 07:39:30	2024-11-13 07:39:30
17	sectore.edit	Editar la lista de Sectores	web	Editar	2024-11-13 07:39:30	2024-11-13 07:39:30
18	sectore.destroy	Cambiar estado de Sectores	web	Eliminar	2024-11-13 07:39:30	2024-11-13 07:39:30
19	sectore.create	Crear Sectores	web	Crear	2024-11-13 07:39:30	2024-11-13 07:39:30
20	haburbana.index	Ver la lista de Habilitaciones Urbanas	web	Ver	2024-11-13 07:39:30	2024-11-13 07:39:30
21	haburbana.edit	Editar datos de Habilitaciones Urbanas	web	Editar	2024-11-13 07:39:30	2024-11-13 07:39:30
22	haburbana.destroy	Cambiar estado de Habilitaciones Urbanas	web	Eliminar	2024-11-13 07:39:30	2024-11-13 07:39:30
23	haburbana.create	Crear Habilitaciones Urbanas	web	Crear	2024-11-13 07:39:30	2024-11-13 07:39:30
24	vias.index	Ver la lista de Vias	web	Ver	2024-11-13 07:39:30	2024-11-13 07:39:30
25	vias.edit	Editar datos de Vias	web	Editar	2024-11-13 07:39:30	2024-11-13 07:39:30
26	vias.destroy	Cambiar estado de Vias	web	Eliminar	2024-11-13 07:39:30	2024-11-13 07:39:30
27	vias.create	Crear Vias	web	Crear	2024-11-13 07:39:30	2024-11-13 07:39:30
28	notaria.index	Ver Notaria	web	Ver	2024-11-13 07:39:30	2024-11-13 07:39:30
29	notaria.edit	Editar datos de Notaria	web	Editar	2024-11-13 07:39:30	2024-11-13 07:39:30
30	notaria.destroy	Cambiar estado de Notaria	web	Eliminar	2024-11-13 07:39:30	2024-11-13 07:39:30
31	notaria.create	Crear Notaria	web	Crear	2024-11-13 07:39:30	2024-11-13 07:39:30
32	reporte.index	Vista de Reportes	web	Reportes	2024-11-13 07:39:30	2024-11-13 07:39:30
33	lineatiempo	Ver Linea Tiempo Fichas	web	Ver	2024-11-13 07:39:30	2024-11-13 07:39:30
34	progresofichas	Ver Progreso de Fichas	web	Ver	2024-11-13 07:39:30	2024-11-13 07:39:30
35	persona.edit	Editar datos de Persona	web	Editar	2024-11-13 07:39:30	2024-11-13 07:39:30
36	supervisor.edit	Editar datos de Supervisor	web	Editar	2024-11-13 07:39:30	2024-11-13 07:39:30
37	tecnicos.edit	Editar datos de Tecnicos	web	Editar	2024-11-13 07:39:30	2024-11-13 07:39:30
38	verificadores.edit	Editar datos de Verificadores	web	Editar	2024-11-13 07:39:30	2024-11-13 07:39:30
39	persona.create	Crear Persona	web	Crear	2024-11-13 07:39:30	2024-11-13 07:39:30
40	supervisor.create	Crear Supervisor	web	Crear	2024-11-13 07:39:30	2024-11-13 07:39:30
41	tecnicos.create	Crear Tecnicos	web	Crear	2024-11-13 07:39:30	2024-11-13 07:39:30
42	verificadores.create	Crear Verificadores	web	Crear	2024-11-13 07:39:30	2024-11-13 07:39:30
43	mantenimiento.supervisores	Ver lista de Supervisores	web	Ver	2024-11-13 07:39:30	2024-11-13 07:39:30
44	mantenimiento.tecnicos	Ver lista de Tecnicos	web	Ver	2024-11-13 07:39:30	2024-11-13 07:39:30
45	mantenimiento.verificadores	Ver lista de Verificadores	web	Ver	2024-11-13 07:39:30	2024-11-13 07:39:30
46	pdf.individual	Ver Pdf de Ficha Individual	web	Ver	2024-11-13 07:39:30	2024-11-13 07:39:30
47	pdf.cotitularidad	Ver Pdf de Ficha Cotitularidad	web	Ver	2024-11-13 07:39:30	2024-11-13 07:39:30
48	pdf.economica	Ver Pdf de Ficha Economica	web	Ver	2024-11-13 07:39:30	2024-11-13 07:39:30
49	pdf.bienescomunes	Ver Pdf de Ficha Bienes Comunes	web	Ver	2024-11-13 07:39:30	2024-11-13 07:39:30
50	pdf.informativa	Ver Pdf de Ficha Informativa	web	Ver	2024-11-13 07:39:30	2024-11-13 07:39:30
51	pdf.bienesculturales	Ver Pdf de Ficha Bienes Culturales	web	Ver	2024-11-13 07:39:30	2024-11-13 07:39:30
52	pdf.rural	Ver Pdf de Ficha Rural	web	Ver	2024-11-13 07:39:31	2024-11-13 07:39:31
53	ficha.createcotitularidad	Crear Ficha Cotitularidad	web	Crear	2024-11-13 07:39:31	2024-11-13 07:39:31
54	ficha.editcotitularidad	Editar Ficha Cotitularidad	web	Editar	2024-11-13 07:39:31	2024-11-13 07:39:31
55	ficha.editcultural	Editar Ficha Bien Cultural	web	Editar	2024-11-13 07:39:31	2024-11-13 07:39:31
56	ficha.destroycotitularidad	Eliminar Ficha Cotitularidad	web	Eliminar	2024-11-13 07:39:31	2024-11-13 07:39:31
57	ficha.editeconomica	Editar Ficha Economica	web	Editar	2024-11-13 07:39:31	2024-11-13 07:39:31
58	ficha.destroyeconomica	Eliminar Ficha Economica	web	Eliminar	2024-11-13 07:39:31	2024-11-13 07:39:31
59	ficha.editindividual	Editar Ficha Individual	web	Editar	2024-11-13 07:39:31	2024-11-13 07:39:31
60	ficha.destroyindividual	Eliminar Ficha Individual	web	Eliminar	2024-11-13 07:39:31	2024-11-13 07:39:31
61	ficha.indexeconomica	Ver Lista de Ficha Economica	web	Ver	2024-11-13 07:39:31	2024-11-13 07:39:31
62	ficha.indexcotitular	Ver Lista de Ficha Cotitularidad	web	Ver	2024-11-13 07:39:31	2024-11-13 07:39:31
63	ficha.indexbiencultural	Ver Lista de Ficha Bienes Culturales	web	Ver	2024-11-13 07:39:31	2024-11-13 07:39:31
64	ficha.createeconomica	Crear Ficha Economica	web	Crear	2024-11-13 07:39:31	2024-11-13 07:39:31
65	ficha.createbiencomun	Crear Ficha de Bienes Comunes	web	Crear	2024-11-13 07:39:31	2024-11-13 07:39:31
66	ficha.createbiencultural	Crear Ficha Bien Cultural	web	Crear	2024-11-13 07:39:31	2024-11-13 07:39:31
67	ficha.createrural	Crear Ficha Rural	web	Crear	2024-11-13 07:39:31	2024-11-13 07:39:31
68	ficha.createindividual	Crear Ficha Individual	web	Crear	2024-11-13 07:39:31	2024-11-13 07:39:31
69	impresiones	Ver impresiones	web	Ver	2024-11-13 07:39:31	2024-11-13 07:39:31
70	impresion.verficha	Ver Impresion de Ficha	web	Ver	2024-11-13 07:39:31	2024-11-13 07:39:31
71	impresion.verfichainformativa	Ver Impresion de Ficha Informativa	web	Ver	2024-11-13 07:39:31	2024-11-13 07:39:31
72	impresion.vercertificado	Ver Impresion de Certificado	web	Ver	2024-11-13 07:39:31	2024-11-13 07:39:31
73	impresion.veradministracion	Ver Impresion de Administracion	web	Ver	2024-11-13 07:39:31	2024-11-13 07:39:31
74	impresion.verinformativaeconomica	Ver Impresion de Informe Economico	web	Ver	2024-11-13 07:39:31	2024-11-13 07:39:31
75	impresion.vercnumeracion	Ver Impresion de Certificado de Numeracion	web	Ver	2024-11-13 07:39:31	2024-11-13 07:39:31
76	impresion.verccatastral	Ver Impresion de Certificado Catastral	web	Ver	2024-11-13 07:39:31	2024-11-13 07:39:31
77	ficha.editbiencomun	Editar Ficha Bien Comun	web	Editar	2024-11-13 07:39:31	2024-11-13 07:39:31
78	ficha.destroybiencomun	Eliminar Ficha Bien Comun	web	Eliminar	2024-11-13 07:39:31	2024-11-13 07:39:31
79	reporte.reportepersona	Reporte por Persona	web	Reportes	2024-11-13 07:39:31	2024-11-13 07:39:31
80	reporte.reporteusuario	Reporte por Usuario	web	Reportes	2024-11-13 07:39:31	2024-11-13 07:39:31
81	reporte.reportefechas	Reporte por Fechas	web	Reportes	2024-11-13 07:39:31	2024-11-13 07:39:31
82	reporte.fichapuerta	Reporte por Puerta	web	Reportes	2024-11-13 07:39:31	2024-11-13 07:39:31
83	reporte.fichapredio	Reporte por Predio	web	Reportes	2024-11-13 07:39:31	2024-11-13 07:39:31
84	reporte.fichaconstrucciones	Reporte por Construcciones	web	Reportes	2024-11-13 07:39:31	2024-11-13 07:39:31
85	reporte.fichaantiguedad	Reporte por Antiguedad	web	Reportes	2024-11-13 07:39:31	2024-11-13 07:39:31
86	imagenes	Subir Imagenes	web	Reportes	2024-11-13 07:39:31	2024-11-13 07:39:31
87	reporte.llenadoficha	Reporte Llenado de fichas	web	Reportes	2024-11-13 07:39:31	2024-11-13 07:39:31
88	reporte.porlote	Reporte por Lote	web	Reportes	2024-11-13 07:39:31	2024-11-13 07:39:31
89	reporte.actividadeconomica	Reporte por Actividad Economica	web	Reportes	2024-11-13 07:39:31	2024-11-13 07:39:31
90	reporte.fichasmasivas	Reporte de Fichas Masivas	web	Reportes	2024-11-13 07:39:31	2024-11-13 07:39:31
91	reporte.reportefirmas	Reporte por Firmas	web	Reportes	2024-11-13 07:39:31	2024-11-13 07:39:31
92	visormapas	Visor de Mapas	web	Ver	2024-11-13 07:39:31	2024-11-13 07:39:31
\.


--
-- TOC entry 6051 (class 0 OID 74637)
-- Dependencies: 268
-- Data for Name: role_has_permissions; Type: TABLE DATA; Schema: catastro; Owner: postgres
--

COPY catastro.role_has_permissions (permission_id, role_id) FROM stdin;
1	1
2	1
3	1
4	1
5	1
6	1
7	1
8	1
9	1
10	1
11	1
12	1
13	1
14	1
15	1
16	1
17	1
18	1
19	1
20	1
21	1
22	1
23	1
24	1
25	1
26	1
27	1
28	1
29	1
30	1
31	1
32	1
33	1
34	1
35	1
36	1
37	1
38	1
39	1
40	1
41	1
42	1
43	1
44	1
45	1
46	1
47	1
48	1
49	1
50	1
51	1
52	1
53	1
54	1
55	1
56	1
57	1
58	1
59	1
60	1
61	1
62	1
63	1
64	1
65	1
66	1
67	1
68	1
69	1
70	1
71	1
72	1
73	1
74	1
75	1
76	1
77	1
78	1
79	1
80	1
81	1
82	1
83	1
84	1
85	1
86	1
87	1
88	1
89	1
90	1
91	1
92	1
66	2
53	2
65	2
64	2
68	2
67	2
77	2
55	2
54	2
57	2
59	2
90	2
87	2
89	2
85	2
84	2
81	2
91	2
88	2
79	2
83	2
82	2
80	2
86	2
32	2
62	2
48	2
50	2
69	2
61	2
63	2
49	2
47	2
70	2
51	2
46	2
2	4
73	4
72	4
76	4
75	4
70	4
71	4
74	4
69	4
33	4
63	4
62	4
61	4
28	4
49	4
51	4
47	4
48	4
46	4
50	4
52	4
34	4
92	4
90	4
87	4
89	4
85	4
84	4
81	4
91	4
88	4
79	4
83	4
82	4
80	4
32	4
92	2
54	4
77	4
57	4
59	4
35	5
77	5
54	5
57	5
59	5
90	5
87	5
89	5
85	5
84	5
81	5
91	5
88	5
79	5
83	5
82	5
80	5
86	5
32	5
53	5
68	5
64	5
62	5
48	5
50	5
69	5
61	5
92	5
63	5
49	5
47	5
51	5
46	5
65	5
2	6
72	6
76	6
75	6
70	6
71	6
74	6
69	6
20	6
12	6
8	6
16	6
3	6
24	6
33	6
63	6
62	6
61	6
43	6
44	6
45	6
28	6
49	6
51	6
47	6
48	6
46	6
50	6
52	6
34	6
92	6
90	6
87	6
89	6
85	6
84	6
81	6
91	6
88	6
79	6
83	6
82	6
80	6
86	6
32	6
\.


--
-- TOC entry 6012 (class 0 OID 74438)
-- Dependencies: 229
-- Data for Name: roles; Type: TABLE DATA; Schema: catastro; Owner: postgres
--

COPY catastro.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
1	ADMINISTRADOR	web	2024-11-13 07:39:30	2024-11-13 07:39:30
2	REGISTRADOR	web	2024-11-18 15:30:26	2024-11-18 15:30:26
4	VISOR	web	2024-12-02 15:59:19	2024-12-02 15:59:19
5	VALIDADOR	web	2025-04-16 10:07:19	2025-04-16 10:07:19
6	VERIFICADOR	web	2025-06-11 11:26:10	2025-06-11 11:26:10
\.


--
-- TOC entry 6014 (class 0 OID 74447)
-- Dependencies: 231
-- Data for Name: tf_usuarios; Type: TABLE DATA; Schema: catastro; Owner: postgres
--

COPY catastro.tf_usuarios (id_usuario, codi_usuario, usuario, password, nombres, ape_paterno, ape_materno, email, fecha_creacion, fecha_cese, imagen, estado, session_id) FROM stdin;
8	9	info	$2y$10$HFJ1HFVTR9zpDtq35uyca.cPBWwL3T3cJ9ywLtDHYGpYWZzkSHgB6	INFORMATICA	MDW	CENTRAL	DFG@GMAIL.COM	2024-11-26	\N	default.png	1	\N
21	22	KMOZO	$2y$10$qElcA4IbiCcVPNObEMLUhezNREP7Ag6zuJmoySX9bFkvvxIJpOqUK	KERLY VALERIA	MOZO	MERMA	merma.vale.123@gmail.com	2024-12-02	2025-01-01	default.png	0	UFsL13shi0aLMo2L4JqRnmN7sNR0GySWSiKqZdB8
35	36	WSANCHEZ	$2y$10$.XDQbPSyfiWgT7VPtMrXR.DC5ysygL3balZiRkMGJTnTOLGft3HJq	WILDER	SANCHEZ	FORTON	arq.wildersanchez@gmail.com	2024-12-02	2025-03-07	default.png	0	rE6dakkaeZ6vxumJcjQQ0ypDQAtrXcfqtKeTRM3U
9	10	AAIQUIPA	$2y$10$kCVzz81G4r658fZ8Mbepm.sEEmoodL75nw4./v1Oe3qVZgrNy9YHS	ADRIANA	AIQUIPA	ALOSILLA	adriana1603a@gmail.com	2024-12-02	2025-01-01	default.png	0	\N
16	17	DLOPEZ	$2y$10$gXhqic0.kTlMByhhoqiU..jUw89ueBF.eaQVQbZFSvKK9/xpLkCva	DAICY	LOPEZ	HUAMANRAYME	deicylopezh@gmail.com	2024-12-02	2025-01-01	default.png	0	cDy4BGw8Dt3eW9eKR7yH9AtCNmZZcrqiMZICN5EF
15	16	DCHACON	$2y$10$CZ.Vnu.ImGzIdCX.c6HfP.eH52.7dLxZ2b/fxkM5BfWmSitOBlMEy	DANIEL ALFREDO	CHACON	FLOREZ	dani7.14@hotmail.com	2024-12-02	2025-01-01	default.png	0	4ow5GNDu1Lp4z5eMYgQMCmTlvyoKhAf0lDxen3DH
7	8	MASLLA	$2y$10$cXKUitIDXDNpWTScWshlWu0QzWoU0zTlj8G3Hok7ZWXDJPd5wD8Gq	MARISOL	ASLLA	SULLCA	mey.sol.1000@gmail.com	2024-11-26	2025-01-01	default.png	0	aceVakLHbGAmrpA5UoGXhheuXoWElsYwtBfNYbuv
5	6	JCONDORI	$2y$10$rWzdsqxRV/G9JdhHcwzOFeCquTxNz3qwDgRMnODshfFbgfeceuZlq	JORDY	CONDORI	QUILLAHUAMAN	jordyakiles456@gmail.com	2024-11-18	2025-01-01	default.png	0	\N
24	25	MARAMBURU	$2y$10$ahlO16NVZbS9DQdhRoZJ.uywa2m9NF9YgTsE0WOSmO1.sH6GBuIeG	MARIBEL	ARAMBURU	ARAUJO	mariaramburua@gmail.com	2024-12-02	\N	default.png	1	rKkSlWOKn3dU3dbzQ7EfVcrLarBT4x60yHaTetU3
19	20	GQUINONEZ	$2y$10$8J1Eoe7qmCQ.pGGMw54MhOW9l.7.wnKqkXrrPun3cXOLo7FHI8uza	GABRIELA NHIA	QUINONEZ	CHUQUITAPA	gnhia141198@gmail.com	2024-12-02	2025-01-01	default.png	0	jHdMoGg17WBMFBKJDgIEzREYDMUk94vCbfDMGz1T
18	19	FFARFAN	$2y$10$JGInOyrHSOsl2aVmyodf4Ot7Fhgw.lFS19CDANKz7NROf6FxMkvKi	FAVIOLA	FARFAN	VELASQUEZ	faviolafar@gmail.com	2024-12-02	2025-01-01	default.png	0	\N
27	28	PPAREDES	$2y$10$Edm1CWKcGeEcV6aB6yfU3uCtrMG6.eZ8P9rbaCl/RKzAbCfbz.Rgy	PATRICIA	PAREDES	CHAVEZ	patyparedesch@hotmail.com	2024-12-02	2025-01-01	default.png	0	\N
11	12	AOLAZABAL	$2y$10$V3LNYyH57Tn9zBbxA.wi4uj7orBauTOoQlX6KhtFOQ.17aXzBl2ou	ANA PATRICIA	OLAZABAL	CASTILLO	anapaolazabal01@gmail.com	2024-12-02	2025-01-01	default.png	0	\N
13	14	CCHURATA	$2y$10$dhMiPHWnDWxygI1ydhCDleR8bDZsxQigBwPGqB1EAkPulEETHeFpe	CRISTIAN JHOEL	CHURATA	CHINCHERCOMA	cristianpzpz@gmail.com	2024-12-02	2024-12-23	default.png	0	\N
29	30	WAQUIRRE	$2y$10$8jj8sTjpiLQQHNBPTSPDoOeEugNXTqHrgbpetGlKaXKHH8u9e5COa	WASHINGTON	AGUIRRE	CABRERA	washicvac@gmail.com	2024-12-02	2024-12-23	default.png	0	\N
12	13	BRIVAS	$2y$10$fznoWS3K7mdNhukIjTd7y.YE5zbT8kZWGNd8cl0KlZ92fJfLYzB0.	BRUNO	RIVAS	RAMOS	brivas260698@gmail.com	2024-12-02	2025-01-01	default.png	0	JqMjeGmyYmLYqdvFj4GrcUgXVdA2zOhJC38jhdj4
32	33	YCCAHUA	$2y$10$9yaRwucBjVP5Ja.5Fuatluso4m93EeSHcT17LYp3HVKbMI6Hpt8Xa	YUDITH MARILIA	CCAHUA	CUSIHUAMAN	ymarilia0330@gmail.com	2024-12-02	2025-01-01	default.png	0	eg0659NgNn7egVZVrn67ToVhGwLXIElrmFez4vnH
14	15	DACURIO	$2y$10$TtpGi7G0PMvYVvKN0V4xr.vKUPF3lT1.IsgYE0nilvfDkBwRA6fJW	DYANA URPI	ACURIO	LINES	urpiacurio@gmail.com	2024-12-02	2025-01-01	default.png	0	ROhMK0TRpptEpXnrG4BJLRC5Q26USOFeFdI34AAa
4	5	ECUMPA	$2y$10$FrQGI0dAIrV2Wn4Ki8BKau4HhJk2tKYdY9VDvsiVUwzb3m67Bs0lS	EVELIN KATIA	CUMPA	QUISPE	kathia.ecq@gmail.com	2024-11-18	2025-01-01	default.png	0	NmOyFMtyVOnIsJfqsH1g2nOnwdyYFoJVYBlpMT87
25	26	MMORALES	$2y$10$3b3He3rIIga.bfqZA0i0uOzoLK7vCQpZqZDx6AnUbaof6n5Pv9v56	MIGUEL ANGEL	MORALES	QUINONES	arq.angelmigueldd@gmail.com	2024-12-02	\N	default.png	1	72jNHYxjvnwlfRZU7IlLUiF1Zq2t2EZMRBe73iGA
22	23	LVITERY	$2y$10$7ZUyyY5VULtGLX7ciFfQ1O5FCgtQe9uQK2dYx6g0JKTyW/5PGZgwa	LUIS BENJAMIN	VITERY	CORDERO	benjavitery.lbvc@gmail.com	2024-12-02	2025-01-01	default.png	0	pFPwwyq95ZJ6oUml4zE3X9MXOjTGwHAF3buWn5p3
10	11	AARAUJO	$2y$10$K29uao5uuzeUCWAsYGznKOamaGSNAukAF6lpwaKehBX4A6PAB0tOe	ADRIANA	ARAUJO	HUAMAN	aaraujoh11@gmail.com	2024-12-02	2025-01-01	default.png	0	M2Z5ObQc8eVmleuRdJcOCYjJNZwU89OeKKmPlUUL
30	31	WCALLAPINA	$2y$10$Ip7V2rmLhLAd3kUNsxHYz.mSzySEeoFyz8RaxyitO2vL7VFdItBIO	WENDY SHARMELY	CALLAPINA	ORTEGA	wehn_15@hotmail.com	2024-12-02	2024-12-23	default.png	0	\N
2	3	AFARFAN	$2y$10$UgXoZj6s76NfWIudEPaabOhgBIXrGv8TkwRwVQQqRqoAHsrcUuP5S	ANAI	FARFAN	VARGAS	anaifarfanvargas@gmail.com	2024-11-18	2025-01-01	default.png	0	TJqAtYSnydvoa3xiJJa9degdlcj8AiFPMG233gEn
17	18	EBARRETO	$2y$10$ZGnWva5U/aFAL6ljX7uA1OcMxxJLiIofnU//LOPQtgCkEN85r5iA2	EMANUEL	BARRETO	SALAVALDEZ	emanuelbasa07@gmail.com	2024-12-02	2025-01-01	default.png	0	QJTsDP46utifhuB97ng7xsQyI1vujCdJ7QB3yXpP
6	7	DZAVALETA	$2y$10$vKN49txPhUKgDmaFJG0/ruXk0lT1zLCiF88d1YP5blRrsi8Fv4IBW	DEISY MARY	ZAVALETA	HUÑURUCO	barbaramary_z_h@hotmail.com	2024-11-18	2025-01-01	default.png	0	\N
28	29	RVELIZ	$2y$10$9vME2XPQNHTv6RXDBGGwAORgNwTTJi0Lc99R6/eSh4Uu822pAZOgi	RUBEN JESUS	VELIZ	SOTA	rubenvelizsota@gmail.com	2024-12-02	2025-01-01	default.png	0	4BTmtfuoGuciKFeOTXQmmFdJPZsHnhvMkMJLVbrq
31	32	WPEREZ	$2y$10$cc5FfodXks3sM4THHjsSmuUWPiafMGRIcSJRQsNQfk6bYgH9OGELO	WALTER YUNIOR	PEREZ	LA TORRE	pw05394@gmail.com	2024-12-02	2025-01-01	default.png	0	18ZBdyKJ6RqtCqDuY7oq4VCZAaKvrfHaj174cqFY
3	4	MSAAVEDRA	$2y$10$54wLqxVjA55bHTNehEbW2eRccomM5BrsHm4JpwYekjpHPka1J619m	MARI LUZ	SAAVEDRA	CONTRERAS	mary.saavedra759@gmail.com	2024-11-18	2025-01-01	default.png	0	Yi2nXepjHuCediA6Tkqmw2zfBjS5HfZnCMpfLXCt
36	37	MAPARICIOG	$2y$10$qGXkAuDrrhXqMM.QtS7mrOKOe4JP1wzDz4GUJV9Zw9hmVvifz4SNS	MANUEL	APARICIO	GONZALES	manu.apgo@gmail.com	2024-12-29	2025-01-01	default.png	0	\N
26	27	MNAVIA	$2y$10$i6WjrOnJGhryAbyUNy3nXO22THMBXc.wVxxKixbfOWqZvgKzqqvmO	MAYDA ANGELA NATHY	NAVIA	CANAL	maydaangela@gmail.com	2024-12-02	2025-01-01	default.png	0	hlYtIGUqmA23uJxN5ehvCjAiIVIEI3txXCmppIrf
1	2	admina	$2y$10$GmJqoHSQWWZcrOSUf4iNAecCJVbP8c4dQ0Cuxeia/cZIOXpVnnp6q	ADMINA	ADMIN	A	admin@test.com	2024-11-15	\N	default.png	0	ldpxmBxSyrUxL7M4QGUv6WYi1wSffJ5lnLSsE238
20	21	KENRIQUEZ	$2y$10$vn.Mk7MzHw5KG4hitv5aOutApq2Bt4tJAYWfhfxI9rhJ5pXLEarBG	KATHERINE	ENRIQUEZ	RAMIREZ	kathyenriquez3@gmail.com	2024-12-02	2025-01-01	default.png	1	\N
801081	1	admin	$2y$10$6N0GzdMKZnwY8cYJCxTVVeIxT.xj9pPuA1lACHXPKAKm.9ADfDLla	ADMINISTRADOR	GENERAL	DEL SISTEMA	\N	2022-07-01	\N	default.png	1	HdhKeiPFprIXkMegBxIvqiAQ2zlERjS63XMFNKfn
33	34	YNISHIYAMA	$2y$10$sLS/5UqwYd7fuhtw68XwremotXqB04A1Ui3ZwOmOTCI4gAjPJHjNG	YUKIKO	NISHIYAMA	GONGORA	yuakimas7@gmail.com	2024-12-02	2025-01-01	default.png	1	Eyj3jF9v3KOALSuiZIaTcCYBwynnxznzSrYZC1eB
23	24	MAPARICIO	$2y$10$0SYj587.0x6C2o4M5lsfpu2Gi07I0SHTZH0.VcUFWoD61Gba69LGW	MANUEL	APARICIO	GONZALEZ	manu.apgo@gmail.com	2024-12-02	2025-01-01	default.png	1	OVd85Fao3fbsgVOKJ5OLdOCRUc8S7rUGUVDWadMz
42	43	ZINUNEZ	$2y$10$wHph.VXrJOK5Qp4DkQrLP.Fk71n/ZhjUzFonZeboldLs0lcj2tzuG	ZOILA ISELA	NUNEZ	MONTERROSO	zoila.isela.10@gmail.com	2025-04-08	2025-04-10	default.png	0	\N
37	38	RENTAS	$2y$10$Sb67T0cjr6mAgqF9haFfaedQASKsf.w6Mn1S1d3SkNDSsPkfhAt8i	RENTAS	MUNICIPALIDAD	WANCHAQ	RENTAS@GMAIL.COM	2025-02-25	\N	default.png	1	\N
38	39	AAGUIRRE	$2y$10$0O/PfnMjoOg6a/WBJgH.EOMeosx2K83FfLV010M9lDaQOwyS8ttTm	ANA LUCIA	AGUIRRE	CHEVARRIA	ana@gmail.com	2025-03-07	2025-04-10	default.png	0	s4L2jXoLfnUafWWet9Ii3xxmZvr7KEizv6rz2imt
40	41	MHLUZA	$2y$10$qyB0kncdRxfywr03I/34mO.9iHuaffFLZXRhE3XCIHsS5VvfLnDRm	MERY HANAE	LUZA	TORRES	\N	2025-04-07	\N	default.png	0	4KgNE6YuNah8gWlysw3E0jL2eIcPF5i1j4wQo7Q1
49	50	42219558	$2y$10$DOl6jZlb5YNdhvDOz7/KL.bC.bGMi7pC/PSXdgvuNateq4jnCBmHe	YUKIKO	NISHIYAMA	GONGORA	yuakimas7@gmail.com	2025-07-16	\N	default.png	1	3kzKUpAtItbYGd46Dx5O5bHb6W2Wn1XprUQEaX99
34	35	ZNUNEZ	$2y$10$VdCzpWBHDFQ8J9WyOxKxoekGfuH76IcrEiUWKSMXe1/nwMJqmJbdK	ZOILA ISELA	NUNEZ	MONTERROSO	zoila.isela.10@gmail.com	2024-12-02	\N	default.png	1	ouqZHmwsox0N4LTH2zsi2DKzJ223gjlPwu2YFz4f
46	47	PLICONA	$2y$10$/a2Fk3MQrCBo649bFn71nOU4mcs9yJDREFGGpsw2suteobe4HyRNi	PAOLA DEL MILAGRO	LICONA	CORDOVA	liconacordovap@gmail.com	2025-06-03	\N	default.png	0	xoI3qexL7URPVp9JeTvg5HfVqUgDniEfSX5Llx0m
45	46	jcardenas	$2y$10$ciCvUZTVyjEgc/DVHpT00ek6wYHiMX/1Ziqt6wb2RO8hKcpFc4tJW	JESSENIA	CARDENAS	CAMPANA	jessyjean@gmail.com	2025-05-06	\N	default.png	0	\N
43	44	YVVASQUEZ	$2y$10$MMq4jQV1DNdy0yb6SIHlbO/7wgi3VKLLU88QtKsuYscbksYyD/VC.	YENIFFER VALERIA	VASQUEZ	QUISPE	\N	2025-04-08	\N	default.png	0	XK7wqTuX6vGlRoTDTZ7FLPTHlEkddGGUwQzEu58L
55	56	70416995	$2y$10$VdCzpWBHDFQ8J9WyOxKxoekGfuH76IcrEiUWKSMXe1/nwMJqmJbdK	ROXANA	CUSI	CCASANI	minhyun501@gmail.com	2025-09-10	\N	default.png	1	AGYV691XoYs8D9fVi7sA0ECj5LqjA4Qh9wcJmdr2
51	52	70684516	$2y$10$S2RHCqjGCt2U1Dqo594JFO8Hf2lIjDc8zxTIEfRj3g8LrZo2M5axq	RODRIGO ANTONIO	CAMARGO	INQUITUPA	rodrigocamargoinq@gmail.com	2025-07-16	\N	default.png	1	S9aveOVqzTG715N9kKRFCytq6Cm0jETMu0uM4YTb
44	45	CFLUNA	$2y$10$QJn0I78QhvsJPsvpkRebD.E0IOHWLY7k506lPtLsa43KRkOuP1PVy	CONY FERNANDA	LUNA	HUMPIRE	conyfernanda35@gmail.com	2025-04-21	\N	default.png	0	\N
56	57	70281678	$2y$10$d5J5C7ZT78g8RdHnq7qmueqzbJkt4LT2bhzBdb8pmj3mrkcHGfSwG	ANA LUCIA	AGUIRRE	CHEVARRIA	luciaguirre.waranway@gmail.com	2025-10-01	\N	default.png	1	cnnhoqrxWHwTXX5RYVrHtiwObs1anncX23fPniy9
53	54	40936707	$2y$10$qx3vzfMN/azSQzZe4PAUaer3UOERoYhE0pMuVPMtAdocncs6.5Y6G	PATRICIA SOLEDAD	FIGUEROA	ESQUIVEL	patrycia.sol@gmail.com	2025-08-26	\N	default.png	1	OzGvDn3fRuSbTG3PQL0WOzbmI83AZwrwIoKHP8LI
47	48	PFIGUEROA	$2y$10$CMJr4roOtw0rg0o3gdSXIOlie8NuST/ctkIK9/2UKLrE3Jnr451za	PATRICIA SOLEDAD	FIGUEROA	ESQUIVEL	\N	2025-06-11	\N	default.png	0	\N
39	40	DJROMERO	$2y$10$aSZIg6c6Kdq2CMq384DrpOY3wD69ytjgnlCzcZ2nTYccdEXxFprF.	DAVID JHONATAN	ROMERO	THERAN	\N	2025-04-07	\N	default.png	0	\N
52	53	47660583	$2y$10$QYhl4YcB4qB19T62j7tnpeYpCnYpnZ0gzad.RW/bKWObhVJnYM4bq	INGRID YAZMIN	FLORES	CAMPANA	florescampana@GMAIL.COM	2025-08-11	\N	default.png	1	gSzp1XIWUpASXc76DyxUhMgv0LHUSuIsgFUcrQpJ
50	51	42403829	$2y$10$mNZuj.4HUKdc.nwhhibXjOAaR7HI8VFJhvGCn7hyQSXbjBeUS20au	KATHERINE	ENRIQUEZ	RAMIREZ	kathyenriquez3@gmail.com	2025-07-16	\N	default.png	1	\N
41	42	AHURTADO	$2y$10$SCLgMpb8N83KeHV3g.6g4Ott8fgxCGZZOI38RPXkCcRDF2hDA525K	ANALI	HURTADO	APARICIO	\N	2025-04-07	\N	default.png	1	Ok3UhSNvFH7mQc4qfx1X3XYdVJB04etfqJZ6BEIk
54	55	72281683	$2b$10$Bn9xPiBWXOb2aPV4WMVpO.J9GTUTMB5v7B.tFFG1fnvxNX2X7i10G	YORKA KAROL	SUAREZ	ROZAS	yorkasuarezrozas@gmail.com	2025-09-03	\N	default.png	1	Ix8z550ogPNrFtmVWg52NiQR6MTQe5f1wrn6M4hO
48	49	AYUPANQUI	$2b$10$Bn9xPiBWXOb2aPV4WMVpO.J9GTUTMB5v7B.tFFG1fnvxNX2X7i10G	ANAHI INGRID	YUPANQUI	QUISPE	Ana20ingrid@gmail.com	2025-07-04	\N	default.png	0	\N
\.


--
-- TOC entry 6016 (class 0 OID 74458)
-- Dependencies: 233
-- Data for Name: tg_comercio; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tg_comercio (gid, id_ubigeo, cod_piso, cod_lote, id_uni_cat, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 6018 (class 0 OID 74468)
-- Dependencies: 235
-- Data for Name: tg_construccion; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tg_construccion (gid, id_ubigeo, cod_piso, id_constru, id_lote, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 6020 (class 0 OID 74478)
-- Dependencies: 237
-- Data for Name: tg_eje_via; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tg_eje_via (gid, id_ubigeo, cod_sector, id_sector, cod_via, id_via, nomb_via, peri_grafi, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 6022 (class 0 OID 74488)
-- Dependencies: 239
-- Data for Name: tg_hab_urb; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tg_hab_urb (gid, id_ubigeo, cod_hab_urb, id_hab_urb, tipo_hab_urb, nomb_hab_urb, etap_hab_urb, expediente, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 6024 (class 0 OID 74498)
-- Dependencies: 241
-- Data for Name: tg_lote; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tg_lote (gid, id_ubigeo, cod_sector, id_sector, cod_mzna, id_mzna, cod_lote, id_lote, area_grafi, peri_grafi, cuc, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 6026 (class 0 OID 74508)
-- Dependencies: 243
-- Data for Name: tg_manzana; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tg_manzana (gid, id_ubigeo, cod_sector, id_sector, cod_mzna, id_mzna, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 6028 (class 0 OID 74518)
-- Dependencies: 245
-- Data for Name: tg_parque; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tg_parque (gid, id_ubigeo, cod_parque, id_lote, id_parque, nomb_parque, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 6030 (class 0 OID 74528)
-- Dependencies: 247
-- Data for Name: tg_puerta; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tg_puerta (gid, id_ubigeo, cod_puerta, id_lote, id_puerta, esta_puerta, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 6032 (class 0 OID 74538)
-- Dependencies: 249
-- Data for Name: tg_sector; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tg_sector (gid, id_ubigeo, cod_sector, id_sector, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 6034 (class 0 OID 74548)
-- Dependencies: 251
-- Data for Name: tgh_comercio; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tgh_comercio (id, gid, id_ubigeo, cod_piso, cod_lote, id_uni_cat, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 6036 (class 0 OID 74558)
-- Dependencies: 253
-- Data for Name: tgh_construccion; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tgh_construccion (id, gid, id_ubigeo, cod_piso, id_constru, id_lote, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 6038 (class 0 OID 74568)
-- Dependencies: 255
-- Data for Name: tgh_eje_via; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tgh_eje_via (id, gid, id_ubigeo, cod_sector, id_sector, cod_via, id_via, nomb_via, peri_grafi, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 6040 (class 0 OID 74578)
-- Dependencies: 257
-- Data for Name: tgh_hab_urb; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tgh_hab_urb (id, gid, id_ubigeo, cod_hab_urb, id_hab_urb, tipo_hab_urb, nomb_hab_urb, etap_hab_urb, expediente, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 6042 (class 0 OID 74588)
-- Dependencies: 259
-- Data for Name: tgh_lote; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tgh_lote (id, gid, id_ubigeo, cod_sector, id_sector, cod_mzna, id_mzna, cod_lote, id_lote, area_grafi, peri_grafi, cuc, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 6044 (class 0 OID 74598)
-- Dependencies: 261
-- Data for Name: tgh_manzana; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tgh_manzana (id, gid, id_ubigeo, cod_sector, id_sector, cod_mzna, id_mzna, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 6046 (class 0 OID 74608)
-- Dependencies: 263
-- Data for Name: tgh_parque; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tgh_parque (id, gid, id_ubigeo, cod_parque, id_lote, id_parque, nomb_parque, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 6048 (class 0 OID 74618)
-- Dependencies: 265
-- Data for Name: tgh_puerta; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tgh_puerta (id, gid, cod_puerta, id_lote, id_puerta, esta_puerta, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 6050 (class 0 OID 74628)
-- Dependencies: 267
-- Data for Name: tgh_sector; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tgh_sector (id, gid, id_ubigeo, cod_sector, id_sector, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 6008 (class 0 OID 74421)
-- Dependencies: 225
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
8b42fd6b5543
\.


--
-- TOC entry 5763 (class 0 OID 73655)
-- Dependencies: 221
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- TOC entry 6079 (class 0 OID 0)
-- Dependencies: 226
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: catastro; Owner: postgres
--

SELECT pg_catalog.setval('catastro.permissions_id_seq', 1, false);


--
-- TOC entry 6080 (class 0 OID 0)
-- Dependencies: 228
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: catastro; Owner: postgres
--

SELECT pg_catalog.setval('catastro.roles_id_seq', 1, false);


--
-- TOC entry 6081 (class 0 OID 0)
-- Dependencies: 230
-- Name: tf_usuarios_id_usuario_seq; Type: SEQUENCE SET; Schema: catastro; Owner: postgres
--

SELECT pg_catalog.setval('catastro.tf_usuarios_id_usuario_seq', 1, false);


--
-- TOC entry 6082 (class 0 OID 0)
-- Dependencies: 232
-- Name: tg_comercio_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tg_comercio_gid_seq', 1, false);


--
-- TOC entry 6083 (class 0 OID 0)
-- Dependencies: 234
-- Name: tg_construccion_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tg_construccion_gid_seq', 1, false);


--
-- TOC entry 6084 (class 0 OID 0)
-- Dependencies: 236
-- Name: tg_eje_via_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tg_eje_via_gid_seq', 1, false);


--
-- TOC entry 6085 (class 0 OID 0)
-- Dependencies: 238
-- Name: tg_hab_urb_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tg_hab_urb_gid_seq', 1, false);


--
-- TOC entry 6086 (class 0 OID 0)
-- Dependencies: 240
-- Name: tg_lote_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tg_lote_gid_seq', 1, false);


--
-- TOC entry 6087 (class 0 OID 0)
-- Dependencies: 242
-- Name: tg_manzana_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tg_manzana_gid_seq', 1, false);


--
-- TOC entry 6088 (class 0 OID 0)
-- Dependencies: 244
-- Name: tg_parque_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tg_parque_gid_seq', 1, false);


--
-- TOC entry 6089 (class 0 OID 0)
-- Dependencies: 246
-- Name: tg_puerta_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tg_puerta_gid_seq', 1, false);


--
-- TOC entry 6090 (class 0 OID 0)
-- Dependencies: 248
-- Name: tg_sector_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tg_sector_gid_seq', 1, false);


--
-- TOC entry 6091 (class 0 OID 0)
-- Dependencies: 250
-- Name: tgh_comercio_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tgh_comercio_id_seq', 1, false);


--
-- TOC entry 6092 (class 0 OID 0)
-- Dependencies: 252
-- Name: tgh_construccion_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tgh_construccion_id_seq', 1, false);


--
-- TOC entry 6093 (class 0 OID 0)
-- Dependencies: 254
-- Name: tgh_eje_via_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tgh_eje_via_id_seq', 1, false);


--
-- TOC entry 6094 (class 0 OID 0)
-- Dependencies: 256
-- Name: tgh_hab_urb_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tgh_hab_urb_id_seq', 1, false);


--
-- TOC entry 6095 (class 0 OID 0)
-- Dependencies: 258
-- Name: tgh_lote_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tgh_lote_id_seq', 1, false);


--
-- TOC entry 6096 (class 0 OID 0)
-- Dependencies: 260
-- Name: tgh_manzana_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tgh_manzana_id_seq', 1, false);


--
-- TOC entry 6097 (class 0 OID 0)
-- Dependencies: 262
-- Name: tgh_parque_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tgh_parque_id_seq', 1, false);


--
-- TOC entry 6098 (class 0 OID 0)
-- Dependencies: 264
-- Name: tgh_puerta_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tgh_puerta_id_seq', 1, false);


--
-- TOC entry 6099 (class 0 OID 0)
-- Dependencies: 266
-- Name: tgh_sector_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tgh_sector_id_seq', 1, false);


--
-- TOC entry 5791 (class 2606 OID 74436)
-- Name: permissions permissions_name_guard_name_unique; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.permissions
    ADD CONSTRAINT permissions_name_guard_name_unique UNIQUE (name, guard_name);


--
-- TOC entry 5793 (class 2606 OID 74434)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 5855 (class 2606 OID 74641)
-- Name: role_has_permissions role_has_permissions_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.role_has_permissions
    ADD CONSTRAINT role_has_permissions_pkey PRIMARY KEY (permission_id, role_id);


--
-- TOC entry 5795 (class 2606 OID 74445)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 5797 (class 2606 OID 74454)
-- Name: tf_usuarios tf_usuarios_pkey; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_usuarios
    ADD CONSTRAINT tf_usuarios_pkey PRIMARY KEY (id_usuario);


--
-- TOC entry 5799 (class 2606 OID 74456)
-- Name: tf_usuarios tf_usuarios_usuario_key; Type: CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.tf_usuarios
    ADD CONSTRAINT tf_usuarios_usuario_key UNIQUE (usuario);


--
-- TOC entry 5802 (class 2606 OID 74465)
-- Name: tg_comercio tg_comercio_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_comercio
    ADD CONSTRAINT tg_comercio_pkey PRIMARY KEY (gid);


--
-- TOC entry 5805 (class 2606 OID 74475)
-- Name: tg_construccion tg_construccion_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_construccion
    ADD CONSTRAINT tg_construccion_pkey PRIMARY KEY (gid);


--
-- TOC entry 5808 (class 2606 OID 74485)
-- Name: tg_eje_via tg_eje_via_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_eje_via
    ADD CONSTRAINT tg_eje_via_pkey PRIMARY KEY (gid);


--
-- TOC entry 5811 (class 2606 OID 74495)
-- Name: tg_hab_urb tg_hab_urb_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_hab_urb
    ADD CONSTRAINT tg_hab_urb_pkey PRIMARY KEY (gid);


--
-- TOC entry 5814 (class 2606 OID 74505)
-- Name: tg_lote tg_lote_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_lote
    ADD CONSTRAINT tg_lote_pkey PRIMARY KEY (gid);


--
-- TOC entry 5817 (class 2606 OID 74515)
-- Name: tg_manzana tg_manzana_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_manzana
    ADD CONSTRAINT tg_manzana_pkey PRIMARY KEY (gid);


--
-- TOC entry 5820 (class 2606 OID 74525)
-- Name: tg_parque tg_parque_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_parque
    ADD CONSTRAINT tg_parque_pkey PRIMARY KEY (gid);


--
-- TOC entry 5823 (class 2606 OID 74535)
-- Name: tg_puerta tg_puerta_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_puerta
    ADD CONSTRAINT tg_puerta_pkey PRIMARY KEY (gid);


--
-- TOC entry 5826 (class 2606 OID 74545)
-- Name: tg_sector tg_sector_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_sector
    ADD CONSTRAINT tg_sector_pkey PRIMARY KEY (gid);


--
-- TOC entry 5829 (class 2606 OID 74555)
-- Name: tgh_comercio tgh_comercio_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_comercio
    ADD CONSTRAINT tgh_comercio_pkey PRIMARY KEY (id);


--
-- TOC entry 5832 (class 2606 OID 74565)
-- Name: tgh_construccion tgh_construccion_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_construccion
    ADD CONSTRAINT tgh_construccion_pkey PRIMARY KEY (id);


--
-- TOC entry 5835 (class 2606 OID 74575)
-- Name: tgh_eje_via tgh_eje_via_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_eje_via
    ADD CONSTRAINT tgh_eje_via_pkey PRIMARY KEY (id);


--
-- TOC entry 5838 (class 2606 OID 74585)
-- Name: tgh_hab_urb tgh_hab_urb_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_hab_urb
    ADD CONSTRAINT tgh_hab_urb_pkey PRIMARY KEY (id);


--
-- TOC entry 5841 (class 2606 OID 74595)
-- Name: tgh_lote tgh_lote_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_lote
    ADD CONSTRAINT tgh_lote_pkey PRIMARY KEY (id);


--
-- TOC entry 5844 (class 2606 OID 74605)
-- Name: tgh_manzana tgh_manzana_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_manzana
    ADD CONSTRAINT tgh_manzana_pkey PRIMARY KEY (id);


--
-- TOC entry 5847 (class 2606 OID 74615)
-- Name: tgh_parque tgh_parque_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_parque
    ADD CONSTRAINT tgh_parque_pkey PRIMARY KEY (id);


--
-- TOC entry 5850 (class 2606 OID 74625)
-- Name: tgh_puerta tgh_puerta_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_puerta
    ADD CONSTRAINT tgh_puerta_pkey PRIMARY KEY (id);


--
-- TOC entry 5853 (class 2606 OID 74635)
-- Name: tgh_sector tgh_sector_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_sector
    ADD CONSTRAINT tgh_sector_pkey PRIMARY KEY (id);


--
-- TOC entry 5789 (class 2606 OID 74425)
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- TOC entry 5800 (class 1259 OID 74466)
-- Name: idx_tg_comercio_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_comercio_geom ON geo.tg_comercio USING gist (geom);


--
-- TOC entry 5803 (class 1259 OID 74476)
-- Name: idx_tg_construccion_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_construccion_geom ON geo.tg_construccion USING gist (geom);


--
-- TOC entry 5806 (class 1259 OID 74486)
-- Name: idx_tg_eje_via_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_eje_via_geom ON geo.tg_eje_via USING gist (geom);


--
-- TOC entry 5809 (class 1259 OID 74496)
-- Name: idx_tg_hab_urb_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_hab_urb_geom ON geo.tg_hab_urb USING gist (geom);


--
-- TOC entry 5812 (class 1259 OID 74506)
-- Name: idx_tg_lote_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_lote_geom ON geo.tg_lote USING gist (geom);


--
-- TOC entry 5815 (class 1259 OID 74516)
-- Name: idx_tg_manzana_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_manzana_geom ON geo.tg_manzana USING gist (geom);


--
-- TOC entry 5818 (class 1259 OID 74526)
-- Name: idx_tg_parque_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_parque_geom ON geo.tg_parque USING gist (geom);


--
-- TOC entry 5821 (class 1259 OID 74536)
-- Name: idx_tg_puerta_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_puerta_geom ON geo.tg_puerta USING gist (geom);


--
-- TOC entry 5824 (class 1259 OID 74546)
-- Name: idx_tg_sector_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_sector_geom ON geo.tg_sector USING gist (geom);


--
-- TOC entry 5827 (class 1259 OID 74556)
-- Name: idx_tgh_comercio_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_comercio_geom ON geo.tgh_comercio USING gist (geom);


--
-- TOC entry 5830 (class 1259 OID 74566)
-- Name: idx_tgh_construccion_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_construccion_geom ON geo.tgh_construccion USING gist (geom);


--
-- TOC entry 5833 (class 1259 OID 74576)
-- Name: idx_tgh_eje_via_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_eje_via_geom ON geo.tgh_eje_via USING gist (geom);


--
-- TOC entry 5836 (class 1259 OID 74586)
-- Name: idx_tgh_hab_urb_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_hab_urb_geom ON geo.tgh_hab_urb USING gist (geom);


--
-- TOC entry 5839 (class 1259 OID 74596)
-- Name: idx_tgh_lote_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_lote_geom ON geo.tgh_lote USING gist (geom);


--
-- TOC entry 5842 (class 1259 OID 74606)
-- Name: idx_tgh_manzana_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_manzana_geom ON geo.tgh_manzana USING gist (geom);


--
-- TOC entry 5845 (class 1259 OID 74616)
-- Name: idx_tgh_parque_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_parque_geom ON geo.tgh_parque USING gist (geom);


--
-- TOC entry 5848 (class 1259 OID 74626)
-- Name: idx_tgh_puerta_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_puerta_geom ON geo.tgh_puerta USING gist (geom);


--
-- TOC entry 5851 (class 1259 OID 74636)
-- Name: idx_tgh_sector_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_sector_geom ON geo.tgh_sector USING gist (geom);


--
-- TOC entry 5856 (class 2606 OID 74642)
-- Name: role_has_permissions role_has_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES catastro.permissions(id) ON DELETE CASCADE;


--
-- TOC entry 5857 (class 2606 OID 74647)
-- Name: role_has_permissions role_has_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: catastro; Owner: postgres
--

ALTER TABLE ONLY catastro.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES catastro.roles(id) ON DELETE CASCADE;


-- Completed on 2026-02-03 06:45:42

--
-- PostgreSQL database dump complete
--

\unrestrict u9yNazjFbxkZJRe4wqlK3D74xDen3A2uMk14iC9ijYeJuZBvQpDGcyLaMPfekxN

