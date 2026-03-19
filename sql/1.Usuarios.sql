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
	--WHERE u.id_usuario = 25;
	WHERE u.usuario ILIKE ('%DATOS%');

INSERT INTO catastro.tf_usuarios(
	codi_usuario, usuario, password, email, fecha_creacion,estado, nombres, ape_paterno, ape_materno)
	VALUES ('00000000', 'DATOS', '$2b$10$Bn9xPiBWXOb2aPV4WMVpO.J9GTUTMB5v7B.tFFG1fnvxNX2X7i10G', 'datos@notariaterrazas.com', '19-03-2026', 1, '', '', '');

INSERT INTO catastro.model_has_roles(
	role_id, model_type, model_id)
	VALUES (4, 'App\Models\User', 15);


SELECT * FROM catastro.model_has_roles;

UPDATE catastro.tf_usuarios SET password = '$2b$10$Bn9xPiBWXOb2aPV4WMVpO.J9GTUTMB5v7B.tFFG1fnvxNX2X7i10G',
estado = 1
WHERE id_usuario IN (15);

SELECT * FROM catastro.tf_usuarios WHERE id_usuario IN (25, 64);

SELECT gid, cod_sector, id_ubigeo, id_sector, area_grafi, geom FROM geo.tg_sectores;



