-- Eliminar rol usr_carga_geo sin error de dependencias de privilegios.
-- Ejecutar conectado a la BD donde existe el rol (ej. mdw).

BEGIN;

-- 0) (Opcional) cerrar sesiones activas del usuario para evitar bloqueos.
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE usename = 'usr_carga_geo'
  AND pid <> pg_backend_pid();

-- 1) Si el rol posee objetos, reasignarlos al propietario administrador.
--    Cambiar "postgres" por el rol administrador correcto si aplica.
REASSIGN OWNED BY usr_carga_geo TO postgres;

-- 2) Eliminar privilegios otorgados al rol dentro de esta BD.
DROP OWNED BY usr_carga_geo;

-- 3) Limpiar privilegios a nivel base de datos y esquemas (refuerzo explícito).
REVOKE ALL PRIVILEGES ON DATABASE mdw FROM usr_carga_geo;
REVOKE ALL PRIVILEGES ON SCHEMA catastro FROM usr_carga_geo;
REVOKE ALL PRIVILEGES ON SCHEMA geo FROM usr_carga_geo;

COMMIT;

-- 4) Finalmente eliminar el rol.
DROP ROLE IF EXISTS usr_carga_geo;

-- ------------------------------------------------------------
-- IMPORTANTE:
-- Si el rol tiene privilegios en OTRAS bases del clúster, repetir:
--   REASSIGN OWNED BY usr_carga_geo TO postgres;
--   DROP OWNED BY usr_carga_geo;
-- en cada BD, y recién después ejecutar DROP ROLE.
-- ------------------------------------------------------------