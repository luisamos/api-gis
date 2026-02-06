SELECT 
    u.id_usuario,
    u.usuario,
	u.password,
    u.nombres,
    u.ape_paterno,
    u.ape_materno,
    r.id   AS rol_id,
    r.name AS rol_nombre,
	u.estado    
FROM catastro.tf_usuarios u
JOIN catastro.model_has_roles mhr 
    ON mhr.model_id = u.id_usuario
   AND mhr.model_type = 'App\Models\User'
JOIN catastro.roles r 
    ON r.id = mhr.role_id
	WHERE u.id_usuario = 25;

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

UPDATE catastro.tf_usuarios SET password = '$2b$10$Bn9xPiBWXOb2aPV4WMVpO.J9GTUTMB5v7B.tFFG1fnvxNX2X7i10G',
estado = 1
WHERE id_usuario IN (25);

SELECT * FROM catastro.tf_usuarios WHERE id_usuario IN (25, 49, 50);



