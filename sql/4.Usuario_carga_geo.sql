-- Usuario técnico para carga de datos en esquema geo
-- y solo lectura en esquema catastro (PostgreSQL/PostGIS).
DROP ROLE usr_carga_geo;
BEGIN;

-- 1) Crear rol/login con contraseña segura (reemplazar por una propia).
--    Recomendación: mínimo 20 caracteres, mayúsculas, minúsculas, números y símbolos.
CREATE ROLE usrgeokaypacha
    WITH LOGIN
    PASSWORD '6jDpkEJKKR#y4Vcsf&C27t'
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    NOREPLICATION;

-- 2) Asegurar que no tenga permisos heredados de PUBLIC.
REVOKE ALL ON SCHEMA geo FROM usrgeokaypacha;
REVOKE ALL ON SCHEMA catastro FROM usrgeokaypacha;

-- 3) Permisos de conexión y uso de esquemas.
-- Reemplazar mdw por el nombre real de la base de datos.
GRANT CONNECT ON DATABASE mdw TO usrgeokaypacha;
GRANT USAGE ON SCHEMA geo TO usrgeokaypacha;
GRANT USAGE ON SCHEMA catastro TO usrgeokaypacha;

-- 4) Permisos de lectura/escritura en geo.
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA geo TO usrgeokaypacha;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA geo TO usrgeokaypacha;

-- 5) Solo lectura en catastro.
REVOKE INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER
    ON ALL TABLES IN SCHEMA catastro FROM usrgeokaypacha;

GRANT SELECT ON ALL TABLES IN SCHEMA catastro TO usrgeokaypacha;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA catastro TO usrgeokaypacha;

-- 6) Permisos por defecto para objetos futuros.
--    Ajustar "postgres" por el propietario real de tablas/secuencias.
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA geo
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO usrgeokaypacha;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA geo
    GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO usrgeokaypacha;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA catastro
    GRANT SELECT ON TABLES TO usrgeokaypacha;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA catastro
    GRANT USAGE, SELECT ON SEQUENCES TO usrgeokaypacha;

COMMIT;