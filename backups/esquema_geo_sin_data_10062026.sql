--
-- PostgreSQL database dump
--

\restrict yXtdTyKYoTECVcGd5dtpxl4QXvViG7vPLxmj9yUUKSkqhwFpzlxJ8bN16Te2DXF

-- Dumped from database version 16.14
-- Dumped by pg_dump version 18.3

-- Started on 2026-06-10 11:14:40

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
-- TOC entry 7 (class 2615 OID 481234)
-- Name: geo; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA geo;


ALTER SCHEMA geo OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 223 (class 1259 OID 481236)
-- Name: alembic_version; Type: TABLE; Schema: geo; Owner: kaypacha
--

CREATE TABLE geo.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE geo.alembic_version OWNER TO kaypacha;

--
-- TOC entry 235 (class 1259 OID 481397)
-- Name: tg_comercio; Type: TABLE; Schema: geo; Owner: kaypacha
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


ALTER TABLE geo.tg_comercio OWNER TO kaypacha;

--
-- TOC entry 234 (class 1259 OID 481396)
-- Name: tg_comercio_gid_seq; Type: SEQUENCE; Schema: geo; Owner: kaypacha
--

CREATE SEQUENCE geo.tg_comercio_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tg_comercio_gid_seq OWNER TO kaypacha;

--
-- TOC entry 5985 (class 0 OID 0)
-- Dependencies: 234
-- Name: tg_comercio_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: kaypacha
--

ALTER SEQUENCE geo.tg_comercio_gid_seq OWNED BY geo.tg_comercio.gid;


--
-- TOC entry 237 (class 1259 OID 481407)
-- Name: tg_construccion; Type: TABLE; Schema: geo; Owner: kaypacha
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


ALTER TABLE geo.tg_construccion OWNER TO kaypacha;

--
-- TOC entry 236 (class 1259 OID 481406)
-- Name: tg_construccion_gid_seq; Type: SEQUENCE; Schema: geo; Owner: kaypacha
--

CREATE SEQUENCE geo.tg_construccion_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tg_construccion_gid_seq OWNER TO kaypacha;

--
-- TOC entry 5986 (class 0 OID 0)
-- Dependencies: 236
-- Name: tg_construccion_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: kaypacha
--

ALTER SEQUENCE geo.tg_construccion_gid_seq OWNED BY geo.tg_construccion.gid;


--
-- TOC entry 239 (class 1259 OID 481417)
-- Name: tg_eje_via; Type: TABLE; Schema: geo; Owner: kaypacha
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


ALTER TABLE geo.tg_eje_via OWNER TO kaypacha;

--
-- TOC entry 238 (class 1259 OID 481416)
-- Name: tg_eje_via_gid_seq; Type: SEQUENCE; Schema: geo; Owner: kaypacha
--

CREATE SEQUENCE geo.tg_eje_via_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tg_eje_via_gid_seq OWNER TO kaypacha;

--
-- TOC entry 5987 (class 0 OID 0)
-- Dependencies: 238
-- Name: tg_eje_via_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: kaypacha
--

ALTER SEQUENCE geo.tg_eje_via_gid_seq OWNED BY geo.tg_eje_via.gid;


--
-- TOC entry 241 (class 1259 OID 481427)
-- Name: tg_hab_urb; Type: TABLE; Schema: geo; Owner: kaypacha
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


ALTER TABLE geo.tg_hab_urb OWNER TO kaypacha;

--
-- TOC entry 240 (class 1259 OID 481426)
-- Name: tg_hab_urb_gid_seq; Type: SEQUENCE; Schema: geo; Owner: kaypacha
--

CREATE SEQUENCE geo.tg_hab_urb_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tg_hab_urb_gid_seq OWNER TO kaypacha;

--
-- TOC entry 5988 (class 0 OID 0)
-- Dependencies: 240
-- Name: tg_hab_urb_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: kaypacha
--

ALTER SEQUENCE geo.tg_hab_urb_gid_seq OWNED BY geo.tg_hab_urb.gid;


--
-- TOC entry 243 (class 1259 OID 481437)
-- Name: tg_lote; Type: TABLE; Schema: geo; Owner: kaypacha
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


ALTER TABLE geo.tg_lote OWNER TO kaypacha;

--
-- TOC entry 242 (class 1259 OID 481436)
-- Name: tg_lote_gid_seq; Type: SEQUENCE; Schema: geo; Owner: kaypacha
--

CREATE SEQUENCE geo.tg_lote_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tg_lote_gid_seq OWNER TO kaypacha;

--
-- TOC entry 5989 (class 0 OID 0)
-- Dependencies: 242
-- Name: tg_lote_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: kaypacha
--

ALTER SEQUENCE geo.tg_lote_gid_seq OWNED BY geo.tg_lote.gid;


--
-- TOC entry 245 (class 1259 OID 481447)
-- Name: tg_manzana; Type: TABLE; Schema: geo; Owner: kaypacha
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


ALTER TABLE geo.tg_manzana OWNER TO kaypacha;

--
-- TOC entry 244 (class 1259 OID 481446)
-- Name: tg_manzana_gid_seq; Type: SEQUENCE; Schema: geo; Owner: kaypacha
--

CREATE SEQUENCE geo.tg_manzana_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tg_manzana_gid_seq OWNER TO kaypacha;

--
-- TOC entry 5990 (class 0 OID 0)
-- Dependencies: 244
-- Name: tg_manzana_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: kaypacha
--

ALTER SEQUENCE geo.tg_manzana_gid_seq OWNED BY geo.tg_manzana.gid;


--
-- TOC entry 247 (class 1259 OID 481457)
-- Name: tg_parque; Type: TABLE; Schema: geo; Owner: kaypacha
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


ALTER TABLE geo.tg_parque OWNER TO kaypacha;

--
-- TOC entry 246 (class 1259 OID 481456)
-- Name: tg_parque_gid_seq; Type: SEQUENCE; Schema: geo; Owner: kaypacha
--

CREATE SEQUENCE geo.tg_parque_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tg_parque_gid_seq OWNER TO kaypacha;

--
-- TOC entry 5991 (class 0 OID 0)
-- Dependencies: 246
-- Name: tg_parque_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: kaypacha
--

ALTER SEQUENCE geo.tg_parque_gid_seq OWNED BY geo.tg_parque.gid;


--
-- TOC entry 249 (class 1259 OID 481467)
-- Name: tg_puerta; Type: TABLE; Schema: geo; Owner: kaypacha
--

CREATE TABLE geo.tg_puerta (
    gid integer NOT NULL,
    id_ubigeo character varying(6),
    cod_puerta character varying(2),
    id_lote character varying(14),
    id_puerta character varying(20),
    esta_puerta character varying(1),
    tipo character varying(1),
    usuario_crea integer,
    fecha_crea timestamp without time zone,
    geom public.geometry(Point,32719)
);


ALTER TABLE geo.tg_puerta OWNER TO kaypacha;

--
-- TOC entry 248 (class 1259 OID 481466)
-- Name: tg_puerta_gid_seq; Type: SEQUENCE; Schema: geo; Owner: kaypacha
--

CREATE SEQUENCE geo.tg_puerta_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tg_puerta_gid_seq OWNER TO kaypacha;

--
-- TOC entry 5992 (class 0 OID 0)
-- Dependencies: 248
-- Name: tg_puerta_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: kaypacha
--

ALTER SEQUENCE geo.tg_puerta_gid_seq OWNED BY geo.tg_puerta.gid;


--
-- TOC entry 251 (class 1259 OID 481477)
-- Name: tg_sector; Type: TABLE; Schema: geo; Owner: kaypacha
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


ALTER TABLE geo.tg_sector OWNER TO kaypacha;

--
-- TOC entry 250 (class 1259 OID 481476)
-- Name: tg_sector_gid_seq; Type: SEQUENCE; Schema: geo; Owner: kaypacha
--

CREATE SEQUENCE geo.tg_sector_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tg_sector_gid_seq OWNER TO kaypacha;

--
-- TOC entry 5993 (class 0 OID 0)
-- Dependencies: 250
-- Name: tg_sector_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: kaypacha
--

ALTER SEQUENCE geo.tg_sector_gid_seq OWNED BY geo.tg_sector.gid;


--
-- TOC entry 253 (class 1259 OID 481487)
-- Name: tgh_comercio; Type: TABLE; Schema: geo; Owner: kaypacha
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


ALTER TABLE geo.tgh_comercio OWNER TO kaypacha;

--
-- TOC entry 252 (class 1259 OID 481486)
-- Name: tgh_comercio_id_seq; Type: SEQUENCE; Schema: geo; Owner: kaypacha
--

CREATE SEQUENCE geo.tgh_comercio_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tgh_comercio_id_seq OWNER TO kaypacha;

--
-- TOC entry 5994 (class 0 OID 0)
-- Dependencies: 252
-- Name: tgh_comercio_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: kaypacha
--

ALTER SEQUENCE geo.tgh_comercio_id_seq OWNED BY geo.tgh_comercio.id;


--
-- TOC entry 255 (class 1259 OID 481497)
-- Name: tgh_construccion; Type: TABLE; Schema: geo; Owner: kaypacha
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


ALTER TABLE geo.tgh_construccion OWNER TO kaypacha;

--
-- TOC entry 254 (class 1259 OID 481496)
-- Name: tgh_construccion_id_seq; Type: SEQUENCE; Schema: geo; Owner: kaypacha
--

CREATE SEQUENCE geo.tgh_construccion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tgh_construccion_id_seq OWNER TO kaypacha;

--
-- TOC entry 5995 (class 0 OID 0)
-- Dependencies: 254
-- Name: tgh_construccion_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: kaypacha
--

ALTER SEQUENCE geo.tgh_construccion_id_seq OWNED BY geo.tgh_construccion.id;


--
-- TOC entry 257 (class 1259 OID 481507)
-- Name: tgh_eje_via; Type: TABLE; Schema: geo; Owner: kaypacha
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


ALTER TABLE geo.tgh_eje_via OWNER TO kaypacha;

--
-- TOC entry 256 (class 1259 OID 481506)
-- Name: tgh_eje_via_id_seq; Type: SEQUENCE; Schema: geo; Owner: kaypacha
--

CREATE SEQUENCE geo.tgh_eje_via_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tgh_eje_via_id_seq OWNER TO kaypacha;

--
-- TOC entry 5996 (class 0 OID 0)
-- Dependencies: 256
-- Name: tgh_eje_via_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: kaypacha
--

ALTER SEQUENCE geo.tgh_eje_via_id_seq OWNED BY geo.tgh_eje_via.id;


--
-- TOC entry 259 (class 1259 OID 481517)
-- Name: tgh_hab_urb; Type: TABLE; Schema: geo; Owner: kaypacha
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


ALTER TABLE geo.tgh_hab_urb OWNER TO kaypacha;

--
-- TOC entry 258 (class 1259 OID 481516)
-- Name: tgh_hab_urb_id_seq; Type: SEQUENCE; Schema: geo; Owner: kaypacha
--

CREATE SEQUENCE geo.tgh_hab_urb_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tgh_hab_urb_id_seq OWNER TO kaypacha;

--
-- TOC entry 5997 (class 0 OID 0)
-- Dependencies: 258
-- Name: tgh_hab_urb_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: kaypacha
--

ALTER SEQUENCE geo.tgh_hab_urb_id_seq OWNED BY geo.tgh_hab_urb.id;


--
-- TOC entry 261 (class 1259 OID 481527)
-- Name: tgh_lote; Type: TABLE; Schema: geo; Owner: kaypacha
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


ALTER TABLE geo.tgh_lote OWNER TO kaypacha;

--
-- TOC entry 260 (class 1259 OID 481526)
-- Name: tgh_lote_id_seq; Type: SEQUENCE; Schema: geo; Owner: kaypacha
--

CREATE SEQUENCE geo.tgh_lote_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tgh_lote_id_seq OWNER TO kaypacha;

--
-- TOC entry 5998 (class 0 OID 0)
-- Dependencies: 260
-- Name: tgh_lote_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: kaypacha
--

ALTER SEQUENCE geo.tgh_lote_id_seq OWNED BY geo.tgh_lote.id;


--
-- TOC entry 263 (class 1259 OID 481537)
-- Name: tgh_manzana; Type: TABLE; Schema: geo; Owner: kaypacha
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


ALTER TABLE geo.tgh_manzana OWNER TO kaypacha;

--
-- TOC entry 262 (class 1259 OID 481536)
-- Name: tgh_manzana_id_seq; Type: SEQUENCE; Schema: geo; Owner: kaypacha
--

CREATE SEQUENCE geo.tgh_manzana_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tgh_manzana_id_seq OWNER TO kaypacha;

--
-- TOC entry 5999 (class 0 OID 0)
-- Dependencies: 262
-- Name: tgh_manzana_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: kaypacha
--

ALTER SEQUENCE geo.tgh_manzana_id_seq OWNED BY geo.tgh_manzana.id;


--
-- TOC entry 265 (class 1259 OID 481547)
-- Name: tgh_parque; Type: TABLE; Schema: geo; Owner: kaypacha
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


ALTER TABLE geo.tgh_parque OWNER TO kaypacha;

--
-- TOC entry 264 (class 1259 OID 481546)
-- Name: tgh_parque_id_seq; Type: SEQUENCE; Schema: geo; Owner: kaypacha
--

CREATE SEQUENCE geo.tgh_parque_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tgh_parque_id_seq OWNER TO kaypacha;

--
-- TOC entry 6000 (class 0 OID 0)
-- Dependencies: 264
-- Name: tgh_parque_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: kaypacha
--

ALTER SEQUENCE geo.tgh_parque_id_seq OWNED BY geo.tgh_parque.id;


--
-- TOC entry 267 (class 1259 OID 481557)
-- Name: tgh_puerta; Type: TABLE; Schema: geo; Owner: kaypacha
--

CREATE TABLE geo.tgh_puerta (
    id integer NOT NULL,
    gid integer,
    cod_puerta character varying(2),
    id_lote character varying(14),
    id_puerta character varying(20),
    esta_puerta character varying(1),
    tipo character varying(1),
    usuario_crea integer,
    fecha_crea timestamp without time zone,
    geom public.geometry(Point,32719),
    usuario_modifica integer NOT NULL,
    fecha_modifica timestamp without time zone NOT NULL
);


ALTER TABLE geo.tgh_puerta OWNER TO kaypacha;

--
-- TOC entry 266 (class 1259 OID 481556)
-- Name: tgh_puerta_id_seq; Type: SEQUENCE; Schema: geo; Owner: kaypacha
--

CREATE SEQUENCE geo.tgh_puerta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tgh_puerta_id_seq OWNER TO kaypacha;

--
-- TOC entry 6001 (class 0 OID 0)
-- Dependencies: 266
-- Name: tgh_puerta_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: kaypacha
--

ALTER SEQUENCE geo.tgh_puerta_id_seq OWNED BY geo.tgh_puerta.id;


--
-- TOC entry 269 (class 1259 OID 481567)
-- Name: tgh_sector; Type: TABLE; Schema: geo; Owner: kaypacha
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


ALTER TABLE geo.tgh_sector OWNER TO kaypacha;

--
-- TOC entry 268 (class 1259 OID 481566)
-- Name: tgh_sector_id_seq; Type: SEQUENCE; Schema: geo; Owner: kaypacha
--

CREATE SEQUENCE geo.tgh_sector_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE geo.tgh_sector_id_seq OWNER TO kaypacha;

--
-- TOC entry 6002 (class 0 OID 0)
-- Dependencies: 268
-- Name: tgh_sector_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: kaypacha
--

ALTER SEQUENCE geo.tgh_sector_id_seq OWNED BY geo.tgh_sector.id;


--
-- TOC entry 5721 (class 2604 OID 481400)
-- Name: tg_comercio gid; Type: DEFAULT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tg_comercio ALTER COLUMN gid SET DEFAULT nextval('geo.tg_comercio_gid_seq'::regclass);


--
-- TOC entry 5722 (class 2604 OID 481410)
-- Name: tg_construccion gid; Type: DEFAULT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tg_construccion ALTER COLUMN gid SET DEFAULT nextval('geo.tg_construccion_gid_seq'::regclass);


--
-- TOC entry 5723 (class 2604 OID 481420)
-- Name: tg_eje_via gid; Type: DEFAULT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tg_eje_via ALTER COLUMN gid SET DEFAULT nextval('geo.tg_eje_via_gid_seq'::regclass);


--
-- TOC entry 5724 (class 2604 OID 481430)
-- Name: tg_hab_urb gid; Type: DEFAULT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tg_hab_urb ALTER COLUMN gid SET DEFAULT nextval('geo.tg_hab_urb_gid_seq'::regclass);


--
-- TOC entry 5725 (class 2604 OID 481440)
-- Name: tg_lote gid; Type: DEFAULT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tg_lote ALTER COLUMN gid SET DEFAULT nextval('geo.tg_lote_gid_seq'::regclass);


--
-- TOC entry 5726 (class 2604 OID 481450)
-- Name: tg_manzana gid; Type: DEFAULT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tg_manzana ALTER COLUMN gid SET DEFAULT nextval('geo.tg_manzana_gid_seq'::regclass);


--
-- TOC entry 5727 (class 2604 OID 481460)
-- Name: tg_parque gid; Type: DEFAULT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tg_parque ALTER COLUMN gid SET DEFAULT nextval('geo.tg_parque_gid_seq'::regclass);


--
-- TOC entry 5728 (class 2604 OID 481470)
-- Name: tg_puerta gid; Type: DEFAULT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tg_puerta ALTER COLUMN gid SET DEFAULT nextval('geo.tg_puerta_gid_seq'::regclass);


--
-- TOC entry 5729 (class 2604 OID 481480)
-- Name: tg_sector gid; Type: DEFAULT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tg_sector ALTER COLUMN gid SET DEFAULT nextval('geo.tg_sector_gid_seq'::regclass);


--
-- TOC entry 5730 (class 2604 OID 481490)
-- Name: tgh_comercio id; Type: DEFAULT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tgh_comercio ALTER COLUMN id SET DEFAULT nextval('geo.tgh_comercio_id_seq'::regclass);


--
-- TOC entry 5731 (class 2604 OID 481500)
-- Name: tgh_construccion id; Type: DEFAULT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tgh_construccion ALTER COLUMN id SET DEFAULT nextval('geo.tgh_construccion_id_seq'::regclass);


--
-- TOC entry 5732 (class 2604 OID 481510)
-- Name: tgh_eje_via id; Type: DEFAULT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tgh_eje_via ALTER COLUMN id SET DEFAULT nextval('geo.tgh_eje_via_id_seq'::regclass);


--
-- TOC entry 5733 (class 2604 OID 481520)
-- Name: tgh_hab_urb id; Type: DEFAULT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tgh_hab_urb ALTER COLUMN id SET DEFAULT nextval('geo.tgh_hab_urb_id_seq'::regclass);


--
-- TOC entry 5734 (class 2604 OID 481530)
-- Name: tgh_lote id; Type: DEFAULT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tgh_lote ALTER COLUMN id SET DEFAULT nextval('geo.tgh_lote_id_seq'::regclass);


--
-- TOC entry 5735 (class 2604 OID 481540)
-- Name: tgh_manzana id; Type: DEFAULT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tgh_manzana ALTER COLUMN id SET DEFAULT nextval('geo.tgh_manzana_id_seq'::regclass);


--
-- TOC entry 5736 (class 2604 OID 481550)
-- Name: tgh_parque id; Type: DEFAULT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tgh_parque ALTER COLUMN id SET DEFAULT nextval('geo.tgh_parque_id_seq'::regclass);


--
-- TOC entry 5737 (class 2604 OID 481560)
-- Name: tgh_puerta id; Type: DEFAULT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tgh_puerta ALTER COLUMN id SET DEFAULT nextval('geo.tgh_puerta_id_seq'::regclass);


--
-- TOC entry 5738 (class 2604 OID 481570)
-- Name: tgh_sector id; Type: DEFAULT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tgh_sector ALTER COLUMN id SET DEFAULT nextval('geo.tgh_sector_id_seq'::regclass);


--
-- TOC entry 5943 (class 0 OID 481236)
-- Dependencies: 223
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: geo; Owner: kaypacha
--

COPY geo.alembic_version (version_num) FROM stdin;
cd7aed21dd7c
\.


--
-- TOC entry 5945 (class 0 OID 481397)
-- Dependencies: 235
-- Data for Name: tg_comercio; Type: TABLE DATA; Schema: geo; Owner: kaypacha
--

COPY geo.tg_comercio (gid, id_ubigeo, cod_piso, cod_lote, id_uni_cat, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 5947 (class 0 OID 481407)
-- Dependencies: 237
-- Data for Name: tg_construccion; Type: TABLE DATA; Schema: geo; Owner: kaypacha
--

COPY geo.tg_construccion (gid, id_ubigeo, cod_piso, id_constru, id_lote, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 5949 (class 0 OID 481417)
-- Dependencies: 239
-- Data for Name: tg_eje_via; Type: TABLE DATA; Schema: geo; Owner: kaypacha
--

COPY geo.tg_eje_via (gid, id_ubigeo, cod_sector, id_sector, cod_via, id_via, nomb_via, peri_grafi, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 5951 (class 0 OID 481427)
-- Dependencies: 241
-- Data for Name: tg_hab_urb; Type: TABLE DATA; Schema: geo; Owner: kaypacha
--

COPY geo.tg_hab_urb (gid, id_ubigeo, cod_hab_urb, id_hab_urb, tipo_hab_urb, nomb_hab_urb, etap_hab_urb, expediente, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 5953 (class 0 OID 481437)
-- Dependencies: 243
-- Data for Name: tg_lote; Type: TABLE DATA; Schema: geo; Owner: kaypacha
--

COPY geo.tg_lote (gid, id_ubigeo, cod_sector, id_sector, cod_mzna, id_mzna, cod_lote, id_lote, area_grafi, peri_grafi, cuc, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 5955 (class 0 OID 481447)
-- Dependencies: 245
-- Data for Name: tg_manzana; Type: TABLE DATA; Schema: geo; Owner: kaypacha
--

COPY geo.tg_manzana (gid, id_ubigeo, cod_sector, id_sector, cod_mzna, id_mzna, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 5957 (class 0 OID 481457)
-- Dependencies: 247
-- Data for Name: tg_parque; Type: TABLE DATA; Schema: geo; Owner: kaypacha
--

COPY geo.tg_parque (gid, id_ubigeo, cod_parque, id_lote, id_parque, nomb_parque, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 5959 (class 0 OID 481467)
-- Dependencies: 249
-- Data for Name: tg_puerta; Type: TABLE DATA; Schema: geo; Owner: kaypacha
--

COPY geo.tg_puerta (gid, id_ubigeo, cod_puerta, id_lote, id_puerta, esta_puerta, tipo, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 5961 (class 0 OID 481477)
-- Dependencies: 251
-- Data for Name: tg_sector; Type: TABLE DATA; Schema: geo; Owner: kaypacha
--

COPY geo.tg_sector (gid, id_ubigeo, cod_sector, id_sector, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 5963 (class 0 OID 481487)
-- Dependencies: 253
-- Data for Name: tgh_comercio; Type: TABLE DATA; Schema: geo; Owner: kaypacha
--

COPY geo.tgh_comercio (id, gid, id_ubigeo, cod_piso, cod_lote, id_uni_cat, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 5965 (class 0 OID 481497)
-- Dependencies: 255
-- Data for Name: tgh_construccion; Type: TABLE DATA; Schema: geo; Owner: kaypacha
--

COPY geo.tgh_construccion (id, gid, id_ubigeo, cod_piso, id_constru, id_lote, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 5967 (class 0 OID 481507)
-- Dependencies: 257
-- Data for Name: tgh_eje_via; Type: TABLE DATA; Schema: geo; Owner: kaypacha
--

COPY geo.tgh_eje_via (id, gid, id_ubigeo, cod_sector, id_sector, cod_via, id_via, nomb_via, peri_grafi, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 5969 (class 0 OID 481517)
-- Dependencies: 259
-- Data for Name: tgh_hab_urb; Type: TABLE DATA; Schema: geo; Owner: kaypacha
--

COPY geo.tgh_hab_urb (id, gid, id_ubigeo, cod_hab_urb, id_hab_urb, tipo_hab_urb, nomb_hab_urb, etap_hab_urb, expediente, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 5971 (class 0 OID 481527)
-- Dependencies: 261
-- Data for Name: tgh_lote; Type: TABLE DATA; Schema: geo; Owner: kaypacha
--

COPY geo.tgh_lote (id, gid, id_ubigeo, cod_sector, id_sector, cod_mzna, id_mzna, cod_lote, id_lote, area_grafi, peri_grafi, cuc, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 5973 (class 0 OID 481537)
-- Dependencies: 263
-- Data for Name: tgh_manzana; Type: TABLE DATA; Schema: geo; Owner: kaypacha
--

COPY geo.tgh_manzana (id, gid, id_ubigeo, cod_sector, id_sector, cod_mzna, id_mzna, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 5975 (class 0 OID 481547)
-- Dependencies: 265
-- Data for Name: tgh_parque; Type: TABLE DATA; Schema: geo; Owner: kaypacha
--

COPY geo.tgh_parque (id, gid, id_ubigeo, cod_parque, id_lote, id_parque, nomb_parque, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 5977 (class 0 OID 481557)
-- Dependencies: 267
-- Data for Name: tgh_puerta; Type: TABLE DATA; Schema: geo; Owner: kaypacha
--

COPY geo.tgh_puerta (id, gid, cod_puerta, id_lote, id_puerta, esta_puerta, tipo, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 5979 (class 0 OID 481567)
-- Dependencies: 269
-- Data for Name: tgh_sector; Type: TABLE DATA; Schema: geo; Owner: kaypacha
--

COPY geo.tgh_sector (id, gid, id_ubigeo, cod_sector, id_sector, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 6003 (class 0 OID 0)
-- Dependencies: 234
-- Name: tg_comercio_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: kaypacha
--

SELECT pg_catalog.setval('geo.tg_comercio_gid_seq', 1, false);


--
-- TOC entry 6004 (class 0 OID 0)
-- Dependencies: 236
-- Name: tg_construccion_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: kaypacha
--

SELECT pg_catalog.setval('geo.tg_construccion_gid_seq', 1, false);


--
-- TOC entry 6005 (class 0 OID 0)
-- Dependencies: 238
-- Name: tg_eje_via_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: kaypacha
--

SELECT pg_catalog.setval('geo.tg_eje_via_gid_seq', 1, false);


--
-- TOC entry 6006 (class 0 OID 0)
-- Dependencies: 240
-- Name: tg_hab_urb_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: kaypacha
--

SELECT pg_catalog.setval('geo.tg_hab_urb_gid_seq', 1, false);


--
-- TOC entry 6007 (class 0 OID 0)
-- Dependencies: 242
-- Name: tg_lote_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: kaypacha
--

SELECT pg_catalog.setval('geo.tg_lote_gid_seq', 1, false);


--
-- TOC entry 6008 (class 0 OID 0)
-- Dependencies: 244
-- Name: tg_manzana_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: kaypacha
--

SELECT pg_catalog.setval('geo.tg_manzana_gid_seq', 1, false);


--
-- TOC entry 6009 (class 0 OID 0)
-- Dependencies: 246
-- Name: tg_parque_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: kaypacha
--

SELECT pg_catalog.setval('geo.tg_parque_gid_seq', 1, false);


--
-- TOC entry 6010 (class 0 OID 0)
-- Dependencies: 248
-- Name: tg_puerta_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: kaypacha
--

SELECT pg_catalog.setval('geo.tg_puerta_gid_seq', 1, false);


--
-- TOC entry 6011 (class 0 OID 0)
-- Dependencies: 250
-- Name: tg_sector_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: kaypacha
--

SELECT pg_catalog.setval('geo.tg_sector_gid_seq', 1, false);


--
-- TOC entry 6012 (class 0 OID 0)
-- Dependencies: 252
-- Name: tgh_comercio_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: kaypacha
--

SELECT pg_catalog.setval('geo.tgh_comercio_id_seq', 1, false);


--
-- TOC entry 6013 (class 0 OID 0)
-- Dependencies: 254
-- Name: tgh_construccion_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: kaypacha
--

SELECT pg_catalog.setval('geo.tgh_construccion_id_seq', 1, false);


--
-- TOC entry 6014 (class 0 OID 0)
-- Dependencies: 256
-- Name: tgh_eje_via_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: kaypacha
--

SELECT pg_catalog.setval('geo.tgh_eje_via_id_seq', 1, false);


--
-- TOC entry 6015 (class 0 OID 0)
-- Dependencies: 258
-- Name: tgh_hab_urb_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: kaypacha
--

SELECT pg_catalog.setval('geo.tgh_hab_urb_id_seq', 1, false);


--
-- TOC entry 6016 (class 0 OID 0)
-- Dependencies: 260
-- Name: tgh_lote_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: kaypacha
--

SELECT pg_catalog.setval('geo.tgh_lote_id_seq', 1, false);


--
-- TOC entry 6017 (class 0 OID 0)
-- Dependencies: 262
-- Name: tgh_manzana_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: kaypacha
--

SELECT pg_catalog.setval('geo.tgh_manzana_id_seq', 1, false);


--
-- TOC entry 6018 (class 0 OID 0)
-- Dependencies: 264
-- Name: tgh_parque_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: kaypacha
--

SELECT pg_catalog.setval('geo.tgh_parque_id_seq', 1, false);


--
-- TOC entry 6019 (class 0 OID 0)
-- Dependencies: 266
-- Name: tgh_puerta_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: kaypacha
--

SELECT pg_catalog.setval('geo.tgh_puerta_id_seq', 1, false);


--
-- TOC entry 6020 (class 0 OID 0)
-- Dependencies: 268
-- Name: tgh_sector_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: kaypacha
--

SELECT pg_catalog.setval('geo.tgh_sector_id_seq', 1, false);


--
-- TOC entry 5740 (class 2606 OID 481240)
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- TOC entry 5743 (class 2606 OID 481404)
-- Name: tg_comercio tg_comercio_pkey; Type: CONSTRAINT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tg_comercio
    ADD CONSTRAINT tg_comercio_pkey PRIMARY KEY (gid);


--
-- TOC entry 5746 (class 2606 OID 481414)
-- Name: tg_construccion tg_construccion_pkey; Type: CONSTRAINT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tg_construccion
    ADD CONSTRAINT tg_construccion_pkey PRIMARY KEY (gid);


--
-- TOC entry 5749 (class 2606 OID 481424)
-- Name: tg_eje_via tg_eje_via_pkey; Type: CONSTRAINT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tg_eje_via
    ADD CONSTRAINT tg_eje_via_pkey PRIMARY KEY (gid);


--
-- TOC entry 5752 (class 2606 OID 481434)
-- Name: tg_hab_urb tg_hab_urb_pkey; Type: CONSTRAINT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tg_hab_urb
    ADD CONSTRAINT tg_hab_urb_pkey PRIMARY KEY (gid);


--
-- TOC entry 5755 (class 2606 OID 481444)
-- Name: tg_lote tg_lote_pkey; Type: CONSTRAINT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tg_lote
    ADD CONSTRAINT tg_lote_pkey PRIMARY KEY (gid);


--
-- TOC entry 5758 (class 2606 OID 481454)
-- Name: tg_manzana tg_manzana_pkey; Type: CONSTRAINT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tg_manzana
    ADD CONSTRAINT tg_manzana_pkey PRIMARY KEY (gid);


--
-- TOC entry 5761 (class 2606 OID 481464)
-- Name: tg_parque tg_parque_pkey; Type: CONSTRAINT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tg_parque
    ADD CONSTRAINT tg_parque_pkey PRIMARY KEY (gid);


--
-- TOC entry 5764 (class 2606 OID 481474)
-- Name: tg_puerta tg_puerta_pkey; Type: CONSTRAINT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tg_puerta
    ADD CONSTRAINT tg_puerta_pkey PRIMARY KEY (gid);


--
-- TOC entry 5767 (class 2606 OID 481484)
-- Name: tg_sector tg_sector_pkey; Type: CONSTRAINT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tg_sector
    ADD CONSTRAINT tg_sector_pkey PRIMARY KEY (gid);


--
-- TOC entry 5770 (class 2606 OID 481494)
-- Name: tgh_comercio tgh_comercio_pkey; Type: CONSTRAINT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tgh_comercio
    ADD CONSTRAINT tgh_comercio_pkey PRIMARY KEY (id);


--
-- TOC entry 5773 (class 2606 OID 481504)
-- Name: tgh_construccion tgh_construccion_pkey; Type: CONSTRAINT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tgh_construccion
    ADD CONSTRAINT tgh_construccion_pkey PRIMARY KEY (id);


--
-- TOC entry 5776 (class 2606 OID 481514)
-- Name: tgh_eje_via tgh_eje_via_pkey; Type: CONSTRAINT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tgh_eje_via
    ADD CONSTRAINT tgh_eje_via_pkey PRIMARY KEY (id);


--
-- TOC entry 5779 (class 2606 OID 481524)
-- Name: tgh_hab_urb tgh_hab_urb_pkey; Type: CONSTRAINT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tgh_hab_urb
    ADD CONSTRAINT tgh_hab_urb_pkey PRIMARY KEY (id);


--
-- TOC entry 5782 (class 2606 OID 481534)
-- Name: tgh_lote tgh_lote_pkey; Type: CONSTRAINT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tgh_lote
    ADD CONSTRAINT tgh_lote_pkey PRIMARY KEY (id);


--
-- TOC entry 5785 (class 2606 OID 481544)
-- Name: tgh_manzana tgh_manzana_pkey; Type: CONSTRAINT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tgh_manzana
    ADD CONSTRAINT tgh_manzana_pkey PRIMARY KEY (id);


--
-- TOC entry 5788 (class 2606 OID 481554)
-- Name: tgh_parque tgh_parque_pkey; Type: CONSTRAINT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tgh_parque
    ADD CONSTRAINT tgh_parque_pkey PRIMARY KEY (id);


--
-- TOC entry 5791 (class 2606 OID 481564)
-- Name: tgh_puerta tgh_puerta_pkey; Type: CONSTRAINT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tgh_puerta
    ADD CONSTRAINT tgh_puerta_pkey PRIMARY KEY (id);


--
-- TOC entry 5794 (class 2606 OID 481574)
-- Name: tgh_sector tgh_sector_pkey; Type: CONSTRAINT; Schema: geo; Owner: kaypacha
--

ALTER TABLE ONLY geo.tgh_sector
    ADD CONSTRAINT tgh_sector_pkey PRIMARY KEY (id);


--
-- TOC entry 5741 (class 1259 OID 481405)
-- Name: idx_tg_comercio_geom; Type: INDEX; Schema: geo; Owner: kaypacha
--

CREATE INDEX idx_tg_comercio_geom ON geo.tg_comercio USING gist (geom);


--
-- TOC entry 5744 (class 1259 OID 481415)
-- Name: idx_tg_construccion_geom; Type: INDEX; Schema: geo; Owner: kaypacha
--

CREATE INDEX idx_tg_construccion_geom ON geo.tg_construccion USING gist (geom);


--
-- TOC entry 5747 (class 1259 OID 481425)
-- Name: idx_tg_eje_via_geom; Type: INDEX; Schema: geo; Owner: kaypacha
--

CREATE INDEX idx_tg_eje_via_geom ON geo.tg_eje_via USING gist (geom);


--
-- TOC entry 5750 (class 1259 OID 481435)
-- Name: idx_tg_hab_urb_geom; Type: INDEX; Schema: geo; Owner: kaypacha
--

CREATE INDEX idx_tg_hab_urb_geom ON geo.tg_hab_urb USING gist (geom);


--
-- TOC entry 5753 (class 1259 OID 481445)
-- Name: idx_tg_lote_geom; Type: INDEX; Schema: geo; Owner: kaypacha
--

CREATE INDEX idx_tg_lote_geom ON geo.tg_lote USING gist (geom);


--
-- TOC entry 5756 (class 1259 OID 481455)
-- Name: idx_tg_manzana_geom; Type: INDEX; Schema: geo; Owner: kaypacha
--

CREATE INDEX idx_tg_manzana_geom ON geo.tg_manzana USING gist (geom);


--
-- TOC entry 5759 (class 1259 OID 481465)
-- Name: idx_tg_parque_geom; Type: INDEX; Schema: geo; Owner: kaypacha
--

CREATE INDEX idx_tg_parque_geom ON geo.tg_parque USING gist (geom);


--
-- TOC entry 5762 (class 1259 OID 481475)
-- Name: idx_tg_puerta_geom; Type: INDEX; Schema: geo; Owner: kaypacha
--

CREATE INDEX idx_tg_puerta_geom ON geo.tg_puerta USING gist (geom);


--
-- TOC entry 5765 (class 1259 OID 481485)
-- Name: idx_tg_sector_geom; Type: INDEX; Schema: geo; Owner: kaypacha
--

CREATE INDEX idx_tg_sector_geom ON geo.tg_sector USING gist (geom);


--
-- TOC entry 5768 (class 1259 OID 481495)
-- Name: idx_tgh_comercio_geom; Type: INDEX; Schema: geo; Owner: kaypacha
--

CREATE INDEX idx_tgh_comercio_geom ON geo.tgh_comercio USING gist (geom);


--
-- TOC entry 5771 (class 1259 OID 481505)
-- Name: idx_tgh_construccion_geom; Type: INDEX; Schema: geo; Owner: kaypacha
--

CREATE INDEX idx_tgh_construccion_geom ON geo.tgh_construccion USING gist (geom);


--
-- TOC entry 5774 (class 1259 OID 481515)
-- Name: idx_tgh_eje_via_geom; Type: INDEX; Schema: geo; Owner: kaypacha
--

CREATE INDEX idx_tgh_eje_via_geom ON geo.tgh_eje_via USING gist (geom);


--
-- TOC entry 5777 (class 1259 OID 481525)
-- Name: idx_tgh_hab_urb_geom; Type: INDEX; Schema: geo; Owner: kaypacha
--

CREATE INDEX idx_tgh_hab_urb_geom ON geo.tgh_hab_urb USING gist (geom);


--
-- TOC entry 5780 (class 1259 OID 481535)
-- Name: idx_tgh_lote_geom; Type: INDEX; Schema: geo; Owner: kaypacha
--

CREATE INDEX idx_tgh_lote_geom ON geo.tgh_lote USING gist (geom);


--
-- TOC entry 5783 (class 1259 OID 481545)
-- Name: idx_tgh_manzana_geom; Type: INDEX; Schema: geo; Owner: kaypacha
--

CREATE INDEX idx_tgh_manzana_geom ON geo.tgh_manzana USING gist (geom);


--
-- TOC entry 5786 (class 1259 OID 481555)
-- Name: idx_tgh_parque_geom; Type: INDEX; Schema: geo; Owner: kaypacha
--

CREATE INDEX idx_tgh_parque_geom ON geo.tgh_parque USING gist (geom);


--
-- TOC entry 5789 (class 1259 OID 481565)
-- Name: idx_tgh_puerta_geom; Type: INDEX; Schema: geo; Owner: kaypacha
--

CREATE INDEX idx_tgh_puerta_geom ON geo.tgh_puerta USING gist (geom);


--
-- TOC entry 5792 (class 1259 OID 481575)
-- Name: idx_tgh_sector_geom; Type: INDEX; Schema: geo; Owner: kaypacha
--

CREATE INDEX idx_tgh_sector_geom ON geo.tgh_sector USING gist (geom);


-- Completed on 2026-06-10 11:14:40

--
-- PostgreSQL database dump complete
--

\unrestrict yXtdTyKYoTECVcGd5dtpxl4QXvViG7vPLxmj9yUUKSkqhwFpzlxJ8bN16Te2DXF

