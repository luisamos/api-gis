--
-- PostgreSQL database dump
--

\restrict WxtIJeFQY1jXP33obbnWjLvUPFAcwtdBRgrlYYrSSpPxpP81Jm08GSRvW7iAC0X

-- Dumped from database version 16.11
-- Dumped by pg_dump version 18.1

-- Started on 2026-02-05 11:14:44

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
-- TOC entry 7 (class 2615 OID 399224)
-- Name: geo; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA geo;


ALTER SCHEMA geo OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 231 (class 1259 OID 400377)
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
-- TOC entry 230 (class 1259 OID 400376)
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
-- TOC entry 5965 (class 0 OID 0)
-- Dependencies: 230
-- Name: tg_comercio_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_comercio_gid_seq OWNED BY geo.tg_comercio.gid;


--
-- TOC entry 233 (class 1259 OID 400387)
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
-- TOC entry 232 (class 1259 OID 400386)
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
-- TOC entry 5966 (class 0 OID 0)
-- Dependencies: 232
-- Name: tg_construccion_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_construccion_gid_seq OWNED BY geo.tg_construccion.gid;


--
-- TOC entry 235 (class 1259 OID 400397)
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
-- TOC entry 234 (class 1259 OID 400396)
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
-- TOC entry 5967 (class 0 OID 0)
-- Dependencies: 234
-- Name: tg_eje_via_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_eje_via_gid_seq OWNED BY geo.tg_eje_via.gid;


--
-- TOC entry 237 (class 1259 OID 400407)
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
-- TOC entry 236 (class 1259 OID 400406)
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
-- TOC entry 5968 (class 0 OID 0)
-- Dependencies: 236
-- Name: tg_hab_urb_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_hab_urb_gid_seq OWNED BY geo.tg_hab_urb.gid;


--
-- TOC entry 239 (class 1259 OID 400417)
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
-- TOC entry 238 (class 1259 OID 400416)
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
-- TOC entry 5969 (class 0 OID 0)
-- Dependencies: 238
-- Name: tg_lote_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_lote_gid_seq OWNED BY geo.tg_lote.gid;


--
-- TOC entry 241 (class 1259 OID 400427)
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
-- TOC entry 240 (class 1259 OID 400426)
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
-- TOC entry 5970 (class 0 OID 0)
-- Dependencies: 240
-- Name: tg_manzana_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_manzana_gid_seq OWNED BY geo.tg_manzana.gid;


--
-- TOC entry 243 (class 1259 OID 400437)
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
-- TOC entry 242 (class 1259 OID 400436)
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
-- TOC entry 5971 (class 0 OID 0)
-- Dependencies: 242
-- Name: tg_parque_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_parque_gid_seq OWNED BY geo.tg_parque.gid;


--
-- TOC entry 245 (class 1259 OID 400447)
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
-- TOC entry 244 (class 1259 OID 400446)
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
-- TOC entry 5972 (class 0 OID 0)
-- Dependencies: 244
-- Name: tg_puerta_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_puerta_gid_seq OWNED BY geo.tg_puerta.gid;


--
-- TOC entry 247 (class 1259 OID 400457)
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
-- TOC entry 246 (class 1259 OID 400456)
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
-- TOC entry 5973 (class 0 OID 0)
-- Dependencies: 246
-- Name: tg_sector_gid_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tg_sector_gid_seq OWNED BY geo.tg_sector.gid;


--
-- TOC entry 249 (class 1259 OID 400467)
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
-- TOC entry 248 (class 1259 OID 400466)
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
-- TOC entry 5974 (class 0 OID 0)
-- Dependencies: 248
-- Name: tgh_comercio_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_comercio_id_seq OWNED BY geo.tgh_comercio.id;


--
-- TOC entry 251 (class 1259 OID 400477)
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
-- TOC entry 250 (class 1259 OID 400476)
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
-- TOC entry 5975 (class 0 OID 0)
-- Dependencies: 250
-- Name: tgh_construccion_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_construccion_id_seq OWNED BY geo.tgh_construccion.id;


--
-- TOC entry 253 (class 1259 OID 400487)
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
-- TOC entry 252 (class 1259 OID 400486)
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
-- TOC entry 5976 (class 0 OID 0)
-- Dependencies: 252
-- Name: tgh_eje_via_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_eje_via_id_seq OWNED BY geo.tgh_eje_via.id;


--
-- TOC entry 255 (class 1259 OID 400497)
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
-- TOC entry 254 (class 1259 OID 400496)
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
-- TOC entry 5977 (class 0 OID 0)
-- Dependencies: 254
-- Name: tgh_hab_urb_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_hab_urb_id_seq OWNED BY geo.tgh_hab_urb.id;


--
-- TOC entry 257 (class 1259 OID 400507)
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
-- TOC entry 256 (class 1259 OID 400506)
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
-- TOC entry 5978 (class 0 OID 0)
-- Dependencies: 256
-- Name: tgh_lote_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_lote_id_seq OWNED BY geo.tgh_lote.id;


--
-- TOC entry 259 (class 1259 OID 400517)
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
-- TOC entry 258 (class 1259 OID 400516)
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
-- TOC entry 5979 (class 0 OID 0)
-- Dependencies: 258
-- Name: tgh_manzana_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_manzana_id_seq OWNED BY geo.tgh_manzana.id;


--
-- TOC entry 261 (class 1259 OID 400527)
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
-- TOC entry 260 (class 1259 OID 400526)
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
-- TOC entry 5980 (class 0 OID 0)
-- Dependencies: 260
-- Name: tgh_parque_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_parque_id_seq OWNED BY geo.tgh_parque.id;


--
-- TOC entry 263 (class 1259 OID 400537)
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
-- TOC entry 262 (class 1259 OID 400536)
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
-- TOC entry 5981 (class 0 OID 0)
-- Dependencies: 262
-- Name: tgh_puerta_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_puerta_id_seq OWNED BY geo.tgh_puerta.id;


--
-- TOC entry 265 (class 1259 OID 400547)
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
-- TOC entry 264 (class 1259 OID 400546)
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
-- TOC entry 5982 (class 0 OID 0)
-- Dependencies: 264
-- Name: tgh_sector_id_seq; Type: SEQUENCE OWNED BY; Schema: geo; Owner: postgres
--

ALTER SEQUENCE geo.tgh_sector_id_seq OWNED BY geo.tgh_sector.id;


--
-- TOC entry 5704 (class 2604 OID 400380)
-- Name: tg_comercio gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_comercio ALTER COLUMN gid SET DEFAULT nextval('geo.tg_comercio_gid_seq'::regclass);


--
-- TOC entry 5705 (class 2604 OID 400390)
-- Name: tg_construccion gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_construccion ALTER COLUMN gid SET DEFAULT nextval('geo.tg_construccion_gid_seq'::regclass);


--
-- TOC entry 5706 (class 2604 OID 400400)
-- Name: tg_eje_via gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_eje_via ALTER COLUMN gid SET DEFAULT nextval('geo.tg_eje_via_gid_seq'::regclass);


--
-- TOC entry 5707 (class 2604 OID 400410)
-- Name: tg_hab_urb gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_hab_urb ALTER COLUMN gid SET DEFAULT nextval('geo.tg_hab_urb_gid_seq'::regclass);


--
-- TOC entry 5708 (class 2604 OID 400420)
-- Name: tg_lote gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_lote ALTER COLUMN gid SET DEFAULT nextval('geo.tg_lote_gid_seq'::regclass);


--
-- TOC entry 5709 (class 2604 OID 400430)
-- Name: tg_manzana gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_manzana ALTER COLUMN gid SET DEFAULT nextval('geo.tg_manzana_gid_seq'::regclass);


--
-- TOC entry 5710 (class 2604 OID 400440)
-- Name: tg_parque gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_parque ALTER COLUMN gid SET DEFAULT nextval('geo.tg_parque_gid_seq'::regclass);


--
-- TOC entry 5711 (class 2604 OID 400450)
-- Name: tg_puerta gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_puerta ALTER COLUMN gid SET DEFAULT nextval('geo.tg_puerta_gid_seq'::regclass);


--
-- TOC entry 5712 (class 2604 OID 400460)
-- Name: tg_sector gid; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_sector ALTER COLUMN gid SET DEFAULT nextval('geo.tg_sector_gid_seq'::regclass);


--
-- TOC entry 5713 (class 2604 OID 400470)
-- Name: tgh_comercio id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_comercio ALTER COLUMN id SET DEFAULT nextval('geo.tgh_comercio_id_seq'::regclass);


--
-- TOC entry 5714 (class 2604 OID 400480)
-- Name: tgh_construccion id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_construccion ALTER COLUMN id SET DEFAULT nextval('geo.tgh_construccion_id_seq'::regclass);


--
-- TOC entry 5715 (class 2604 OID 400490)
-- Name: tgh_eje_via id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_eje_via ALTER COLUMN id SET DEFAULT nextval('geo.tgh_eje_via_id_seq'::regclass);


--
-- TOC entry 5716 (class 2604 OID 400500)
-- Name: tgh_hab_urb id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_hab_urb ALTER COLUMN id SET DEFAULT nextval('geo.tgh_hab_urb_id_seq'::regclass);


--
-- TOC entry 5717 (class 2604 OID 400510)
-- Name: tgh_lote id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_lote ALTER COLUMN id SET DEFAULT nextval('geo.tgh_lote_id_seq'::regclass);


--
-- TOC entry 5718 (class 2604 OID 400520)
-- Name: tgh_manzana id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_manzana ALTER COLUMN id SET DEFAULT nextval('geo.tgh_manzana_id_seq'::regclass);


--
-- TOC entry 5719 (class 2604 OID 400530)
-- Name: tgh_parque id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_parque ALTER COLUMN id SET DEFAULT nextval('geo.tgh_parque_id_seq'::regclass);


--
-- TOC entry 5720 (class 2604 OID 400540)
-- Name: tgh_puerta id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_puerta ALTER COLUMN id SET DEFAULT nextval('geo.tgh_puerta_id_seq'::regclass);


--
-- TOC entry 5721 (class 2604 OID 400550)
-- Name: tgh_sector id; Type: DEFAULT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_sector ALTER COLUMN id SET DEFAULT nextval('geo.tgh_sector_id_seq'::regclass);


--
-- TOC entry 5925 (class 0 OID 400377)
-- Dependencies: 231
-- Data for Name: tg_comercio; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tg_comercio (gid, id_ubigeo, cod_piso, cod_lote, id_uni_cat, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 5927 (class 0 OID 400387)
-- Dependencies: 233
-- Data for Name: tg_construccion; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tg_construccion (gid, id_ubigeo, cod_piso, id_constru, id_lote, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 5929 (class 0 OID 400397)
-- Dependencies: 235
-- Data for Name: tg_eje_via; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tg_eje_via (gid, id_ubigeo, cod_sector, id_sector, cod_via, id_via, nomb_via, peri_grafi, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 5931 (class 0 OID 400407)
-- Dependencies: 237
-- Data for Name: tg_hab_urb; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tg_hab_urb (gid, id_ubigeo, cod_hab_urb, id_hab_urb, tipo_hab_urb, nomb_hab_urb, etap_hab_urb, expediente, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 5933 (class 0 OID 400417)
-- Dependencies: 239
-- Data for Name: tg_lote; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tg_lote (gid, id_ubigeo, cod_sector, id_sector, cod_mzna, id_mzna, cod_lote, id_lote, area_grafi, peri_grafi, cuc, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 5935 (class 0 OID 400427)
-- Dependencies: 241
-- Data for Name: tg_manzana; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tg_manzana (gid, id_ubigeo, cod_sector, id_sector, cod_mzna, id_mzna, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 5937 (class 0 OID 400437)
-- Dependencies: 243
-- Data for Name: tg_parque; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tg_parque (gid, id_ubigeo, cod_parque, id_lote, id_parque, nomb_parque, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 5939 (class 0 OID 400447)
-- Dependencies: 245
-- Data for Name: tg_puerta; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tg_puerta (gid, id_ubigeo, cod_puerta, id_lote, id_puerta, esta_puerta, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 5941 (class 0 OID 400457)
-- Dependencies: 247
-- Data for Name: tg_sector; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tg_sector (gid, id_ubigeo, cod_sector, id_sector, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom) FROM stdin;
\.


--
-- TOC entry 5943 (class 0 OID 400467)
-- Dependencies: 249
-- Data for Name: tgh_comercio; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tgh_comercio (id, gid, id_ubigeo, cod_piso, cod_lote, id_uni_cat, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 5945 (class 0 OID 400477)
-- Dependencies: 251
-- Data for Name: tgh_construccion; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tgh_construccion (id, gid, id_ubigeo, cod_piso, id_constru, id_lote, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 5947 (class 0 OID 400487)
-- Dependencies: 253
-- Data for Name: tgh_eje_via; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tgh_eje_via (id, gid, id_ubigeo, cod_sector, id_sector, cod_via, id_via, nomb_via, peri_grafi, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 5949 (class 0 OID 400497)
-- Dependencies: 255
-- Data for Name: tgh_hab_urb; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tgh_hab_urb (id, gid, id_ubigeo, cod_hab_urb, id_hab_urb, tipo_hab_urb, nomb_hab_urb, etap_hab_urb, expediente, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 5951 (class 0 OID 400507)
-- Dependencies: 257
-- Data for Name: tgh_lote; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tgh_lote (id, gid, id_ubigeo, cod_sector, id_sector, cod_mzna, id_mzna, cod_lote, id_lote, area_grafi, peri_grafi, cuc, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 5953 (class 0 OID 400517)
-- Dependencies: 259
-- Data for Name: tgh_manzana; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tgh_manzana (id, gid, id_ubigeo, cod_sector, id_sector, cod_mzna, id_mzna, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 5955 (class 0 OID 400527)
-- Dependencies: 261
-- Data for Name: tgh_parque; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tgh_parque (id, gid, id_ubigeo, cod_parque, id_lote, id_parque, nomb_parque, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 5957 (class 0 OID 400537)
-- Dependencies: 263
-- Data for Name: tgh_puerta; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tgh_puerta (id, gid, cod_puerta, id_lote, id_puerta, esta_puerta, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 5959 (class 0 OID 400547)
-- Dependencies: 265
-- Data for Name: tgh_sector; Type: TABLE DATA; Schema: geo; Owner: postgres
--

COPY geo.tgh_sector (id, gid, id_ubigeo, cod_sector, id_sector, area_grafi, peri_grafi, usuario_crea, fecha_crea, geom, usuario_modifica, fecha_modifica) FROM stdin;
\.


--
-- TOC entry 5983 (class 0 OID 0)
-- Dependencies: 230
-- Name: tg_comercio_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tg_comercio_gid_seq', 1, false);


--
-- TOC entry 5984 (class 0 OID 0)
-- Dependencies: 232
-- Name: tg_construccion_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tg_construccion_gid_seq', 1, false);


--
-- TOC entry 5985 (class 0 OID 0)
-- Dependencies: 234
-- Name: tg_eje_via_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tg_eje_via_gid_seq', 1, false);


--
-- TOC entry 5986 (class 0 OID 0)
-- Dependencies: 236
-- Name: tg_hab_urb_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tg_hab_urb_gid_seq', 1, false);


--
-- TOC entry 5987 (class 0 OID 0)
-- Dependencies: 238
-- Name: tg_lote_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tg_lote_gid_seq', 1, false);


--
-- TOC entry 5988 (class 0 OID 0)
-- Dependencies: 240
-- Name: tg_manzana_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tg_manzana_gid_seq', 1, false);


--
-- TOC entry 5989 (class 0 OID 0)
-- Dependencies: 242
-- Name: tg_parque_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tg_parque_gid_seq', 1, false);


--
-- TOC entry 5990 (class 0 OID 0)
-- Dependencies: 244
-- Name: tg_puerta_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tg_puerta_gid_seq', 1, false);


--
-- TOC entry 5991 (class 0 OID 0)
-- Dependencies: 246
-- Name: tg_sector_gid_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tg_sector_gid_seq', 1, false);


--
-- TOC entry 5992 (class 0 OID 0)
-- Dependencies: 248
-- Name: tgh_comercio_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tgh_comercio_id_seq', 1, false);


--
-- TOC entry 5993 (class 0 OID 0)
-- Dependencies: 250
-- Name: tgh_construccion_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tgh_construccion_id_seq', 1, false);


--
-- TOC entry 5994 (class 0 OID 0)
-- Dependencies: 252
-- Name: tgh_eje_via_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tgh_eje_via_id_seq', 1, false);


--
-- TOC entry 5995 (class 0 OID 0)
-- Dependencies: 254
-- Name: tgh_hab_urb_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tgh_hab_urb_id_seq', 1, false);


--
-- TOC entry 5996 (class 0 OID 0)
-- Dependencies: 256
-- Name: tgh_lote_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tgh_lote_id_seq', 1, false);


--
-- TOC entry 5997 (class 0 OID 0)
-- Dependencies: 258
-- Name: tgh_manzana_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tgh_manzana_id_seq', 1, false);


--
-- TOC entry 5998 (class 0 OID 0)
-- Dependencies: 260
-- Name: tgh_parque_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tgh_parque_id_seq', 1, false);


--
-- TOC entry 5999 (class 0 OID 0)
-- Dependencies: 262
-- Name: tgh_puerta_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tgh_puerta_id_seq', 1, false);


--
-- TOC entry 6000 (class 0 OID 0)
-- Dependencies: 264
-- Name: tgh_sector_id_seq; Type: SEQUENCE SET; Schema: geo; Owner: postgres
--

SELECT pg_catalog.setval('geo.tgh_sector_id_seq', 1, false);


--
-- TOC entry 5724 (class 2606 OID 400384)
-- Name: tg_comercio tg_comercio_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_comercio
    ADD CONSTRAINT tg_comercio_pkey PRIMARY KEY (gid);


--
-- TOC entry 5727 (class 2606 OID 400394)
-- Name: tg_construccion tg_construccion_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_construccion
    ADD CONSTRAINT tg_construccion_pkey PRIMARY KEY (gid);


--
-- TOC entry 5730 (class 2606 OID 400404)
-- Name: tg_eje_via tg_eje_via_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_eje_via
    ADD CONSTRAINT tg_eje_via_pkey PRIMARY KEY (gid);


--
-- TOC entry 5733 (class 2606 OID 400414)
-- Name: tg_hab_urb tg_hab_urb_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_hab_urb
    ADD CONSTRAINT tg_hab_urb_pkey PRIMARY KEY (gid);


--
-- TOC entry 5736 (class 2606 OID 400424)
-- Name: tg_lote tg_lote_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_lote
    ADD CONSTRAINT tg_lote_pkey PRIMARY KEY (gid);


--
-- TOC entry 5739 (class 2606 OID 400434)
-- Name: tg_manzana tg_manzana_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_manzana
    ADD CONSTRAINT tg_manzana_pkey PRIMARY KEY (gid);


--
-- TOC entry 5742 (class 2606 OID 400444)
-- Name: tg_parque tg_parque_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_parque
    ADD CONSTRAINT tg_parque_pkey PRIMARY KEY (gid);


--
-- TOC entry 5745 (class 2606 OID 400454)
-- Name: tg_puerta tg_puerta_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_puerta
    ADD CONSTRAINT tg_puerta_pkey PRIMARY KEY (gid);


--
-- TOC entry 5748 (class 2606 OID 400464)
-- Name: tg_sector tg_sector_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tg_sector
    ADD CONSTRAINT tg_sector_pkey PRIMARY KEY (gid);


--
-- TOC entry 5751 (class 2606 OID 400474)
-- Name: tgh_comercio tgh_comercio_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_comercio
    ADD CONSTRAINT tgh_comercio_pkey PRIMARY KEY (id);


--
-- TOC entry 5754 (class 2606 OID 400484)
-- Name: tgh_construccion tgh_construccion_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_construccion
    ADD CONSTRAINT tgh_construccion_pkey PRIMARY KEY (id);


--
-- TOC entry 5757 (class 2606 OID 400494)
-- Name: tgh_eje_via tgh_eje_via_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_eje_via
    ADD CONSTRAINT tgh_eje_via_pkey PRIMARY KEY (id);


--
-- TOC entry 5760 (class 2606 OID 400504)
-- Name: tgh_hab_urb tgh_hab_urb_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_hab_urb
    ADD CONSTRAINT tgh_hab_urb_pkey PRIMARY KEY (id);


--
-- TOC entry 5763 (class 2606 OID 400514)
-- Name: tgh_lote tgh_lote_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_lote
    ADD CONSTRAINT tgh_lote_pkey PRIMARY KEY (id);


--
-- TOC entry 5766 (class 2606 OID 400524)
-- Name: tgh_manzana tgh_manzana_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_manzana
    ADD CONSTRAINT tgh_manzana_pkey PRIMARY KEY (id);


--
-- TOC entry 5769 (class 2606 OID 400534)
-- Name: tgh_parque tgh_parque_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_parque
    ADD CONSTRAINT tgh_parque_pkey PRIMARY KEY (id);


--
-- TOC entry 5772 (class 2606 OID 400544)
-- Name: tgh_puerta tgh_puerta_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_puerta
    ADD CONSTRAINT tgh_puerta_pkey PRIMARY KEY (id);


--
-- TOC entry 5775 (class 2606 OID 400554)
-- Name: tgh_sector tgh_sector_pkey; Type: CONSTRAINT; Schema: geo; Owner: postgres
--

ALTER TABLE ONLY geo.tgh_sector
    ADD CONSTRAINT tgh_sector_pkey PRIMARY KEY (id);


--
-- TOC entry 5722 (class 1259 OID 400385)
-- Name: idx_tg_comercio_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_comercio_geom ON geo.tg_comercio USING gist (geom);


--
-- TOC entry 5725 (class 1259 OID 400395)
-- Name: idx_tg_construccion_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_construccion_geom ON geo.tg_construccion USING gist (geom);


--
-- TOC entry 5728 (class 1259 OID 400405)
-- Name: idx_tg_eje_via_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_eje_via_geom ON geo.tg_eje_via USING gist (geom);


--
-- TOC entry 5731 (class 1259 OID 400415)
-- Name: idx_tg_hab_urb_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_hab_urb_geom ON geo.tg_hab_urb USING gist (geom);


--
-- TOC entry 5734 (class 1259 OID 400425)
-- Name: idx_tg_lote_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_lote_geom ON geo.tg_lote USING gist (geom);


--
-- TOC entry 5737 (class 1259 OID 400435)
-- Name: idx_tg_manzana_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_manzana_geom ON geo.tg_manzana USING gist (geom);


--
-- TOC entry 5740 (class 1259 OID 400445)
-- Name: idx_tg_parque_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_parque_geom ON geo.tg_parque USING gist (geom);


--
-- TOC entry 5743 (class 1259 OID 400455)
-- Name: idx_tg_puerta_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_puerta_geom ON geo.tg_puerta USING gist (geom);


--
-- TOC entry 5746 (class 1259 OID 400465)
-- Name: idx_tg_sector_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tg_sector_geom ON geo.tg_sector USING gist (geom);


--
-- TOC entry 5749 (class 1259 OID 400475)
-- Name: idx_tgh_comercio_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_comercio_geom ON geo.tgh_comercio USING gist (geom);


--
-- TOC entry 5752 (class 1259 OID 400485)
-- Name: idx_tgh_construccion_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_construccion_geom ON geo.tgh_construccion USING gist (geom);


--
-- TOC entry 5755 (class 1259 OID 400495)
-- Name: idx_tgh_eje_via_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_eje_via_geom ON geo.tgh_eje_via USING gist (geom);


--
-- TOC entry 5758 (class 1259 OID 400505)
-- Name: idx_tgh_hab_urb_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_hab_urb_geom ON geo.tgh_hab_urb USING gist (geom);


--
-- TOC entry 5761 (class 1259 OID 400515)
-- Name: idx_tgh_lote_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_lote_geom ON geo.tgh_lote USING gist (geom);


--
-- TOC entry 5764 (class 1259 OID 400525)
-- Name: idx_tgh_manzana_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_manzana_geom ON geo.tgh_manzana USING gist (geom);


--
-- TOC entry 5767 (class 1259 OID 400535)
-- Name: idx_tgh_parque_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_parque_geom ON geo.tgh_parque USING gist (geom);


--
-- TOC entry 5770 (class 1259 OID 400545)
-- Name: idx_tgh_puerta_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_puerta_geom ON geo.tgh_puerta USING gist (geom);


--
-- TOC entry 5773 (class 1259 OID 400555)
-- Name: idx_tgh_sector_geom; Type: INDEX; Schema: geo; Owner: postgres
--

CREATE INDEX idx_tgh_sector_geom ON geo.tgh_sector USING gist (geom);


-- Completed on 2026-02-05 11:14:44

--
-- PostgreSQL database dump complete
--

\unrestrict WxtIJeFQY1jXP33obbnWjLvUPFAcwtdBRgrlYYrSSpPxpP81Jm08GSRvW7iAC0X

