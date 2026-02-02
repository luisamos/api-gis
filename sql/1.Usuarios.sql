SELECT
    u.id_usuario,
    u.usuario,
	u.password,
    u.nombres,
    u.ape_paterno,
    u.ape_materno,
    r.id   AS role_id,
    r.name AS rol,
	u.estado
FROM catastro.tf_usuarios u
JOIN catastro.role_has_permissions ur
    ON ur.permission_id = u.id_usuario
JOIN catastro.roles r
    ON r.id = ur.role_id
WHERE r.id = 4
ORDER BY u.usuario, r.name;

-- Exportar
COPY catastro.permissions TO 'C:\apps\python\flask\api-gis\sql\permissions.csv' CSV HEADER;

COPY catastro.roles TO 'C:\apps\python\flask\api-gis\sql\roles.csv' CSV HEADER;

COPY catastro.role_has_permissions TO 'C:\apps\python\flask\api-gis\sql\role_has_permissions.csv' CSV HEADER;

COPY catastro.tf_usuarios TO 'C:\apps\python\flask\api-gis\sql\tf_usuarios.csv' CSV HEADER;

-- Importar
COPY catastro.permissions FROM 'C:\apps\python\flask\api-gis\sql\permissions.csv' CSV HEADER;

COPY catastro.roles FROM 'C:\apps\python\flask\api-gis\sql\roles.csv' CSV HEADER;

COPY catastro.tf_usuarios FROM 'C:\apps\python\flask\api-gis\sql\tf_usuarios.csv' CSV HEADER;

COPY catastro.role_has_permissions FROM 'C:\apps\python\flask\api-gis\sql\role_has_permissions.csv' CSV HEADER;

SELECT * FROM catastro.tf_usuarios WHERE id_usuario= 48;
UPDATE catastro.tf_usuarios SET password = '$2b$10$Bn9xPiBWXOb2aPV4WMVpO.J9GTUTMB5v7B.tFFG1fnvxNX2X7i10G'
WHERE id_usuario = 54;
