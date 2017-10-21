CREATE DATABASE imba;
use imba;

CREATE TABLE business (
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	name varchar(50),
	place varchar(255),
	latitude varchar(255),
	length varchar(255),
	fec date,
	active tinyint(1)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE user (
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_business int,
	ci int,
	ex varchar(3),
	name varchar(50),
	last_name varchar(50),
	email varchar(100),
	pwd varchar(100),
	type varchar(5),
	fec date,
	fec_up datetime,

	FOREIGN KEY (id_business) REFERENCES business(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE orders (
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_user int,
	reference varchar(255),
	sale float,
	fec date,
	fec_up date,

	FOREIGN KEY (id_user) REFERENCES user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE type (
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	name varchar(10),
	quantity int
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE products (
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_type int,
	cod varchar(15),
	name varchar(150),
	description text,
	price float,
	stock int,
	unity int,

	FOREIGN KEY (id_type) REFERENCES type(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE contains (
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_order int,
	id_products int,
	quantity int,
	unity int,
	price float,

	FOREIGN KEY (id_order) REFERENCES orders(id),
	FOREIGN KEY (id_products) REFERENCES products(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;











/*Procediminetos Almacenados*/
delimiter //
DROP PROCEDURE IF EXISTS pSession;
CREATE PROCEDURE pSession(
	IN v_email varchar(100),
	IN v_pwd varchar(100)
)
BEGIN
	DECLARE us int(11);
	SET us = (SELECT id FROM user WHERE email LIKE v_email);
	IF(us) THEN
		IF EXISTS(SELECT id FROM user WHERE id = us AND pwd LIKE v_pwd) THEN
			SELECT id,type,'not' AS error,'Espere por favor...' AS msj FROM user WHERE id = us;
		ELSE
			SELECT 'yes' error,'Error: Contraseña incorrecta.' msj;
		END IF;
	ELSE
		SELECT 'yes' error,'Error: Correo no registrado.' msj;
	END IF;
END //


DROP PROCEDURE IF EXISTS pInsertUser;
CREATE PROCEDURE pInsertUser (
	IN v_ci int,
	IN v_ex varchar(3),
	IN v_name varchar(50),
	IN v_last_name varchar(50),
	IN v_email varchar(100),
	IN v_pwd varchar(100),
	IN v_type varchar(5)
)
BEGIN
	IF NOT EXISTS(SELECT id FROM user WHERE email LIKE v_email) THEN
		INSERT INTO user VALUES(null,v_ci,v_ex,v_name,v_last_name,v_email,v_pwd,v_type,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
		SELECT @@identity AS id,v_type AS tipo, 'not' AS error, 'Registro insertado.' AS msj;
	ELSE
		SELECT 'yes' error,'Error: Correo ya registrado.' msj;
	END IF;
END //

DROP PROCEDURE IF EXISTS pInsertBusiness;
CREATE PROCEDURE pInsertBusiness (
	IN v_name varchar(50),
	IN v_place varchar(255),
	IN v_latitude varchar(255),
	IN v_length varchar(255)
)
BEGIN
	IF NOT EXISTS(SELECT id FROM business WHERE name LIKE v_name) THEN
		INSERT INTO business VALUES(null,v_name,v_place,v_latitude,v_length,CURRENT_TIMESTAMP);
		SELECT @@identity AS id,'not' AS error, 'Empresa registrada.' AS msj;
	ELSE
		SELECT 'yes' error,'Error: Nombre de la empresa ya registrada.' msj;
	END IF;
END //




DROP PROCEDURE IF EXISTS pReporte;
CREATE PROCEDURE pReporte (
    IN v_fecha date
)
BEGIN
	IF EXISTS(SELECT id FROM pasaje WHERE SUBSTRING(fecha,1,10) LIKE v_fecha) THEN
		SELECT p.id,p.num_asiento,p.ubicacion,p.precio,p.fecha,v.horario,
			v.origen,v.destino,ch.ci AS ci_chofer,ch.nombre AS nombre_chofer,ch.img AS img_chofer,b.num AS num_bus,
			cli.ci AS ci_cliente,cli.nombre AS nombre_cliente,cli.apellido AS apellido_cliente 
		FROM bus as b,chofer as ch,viaje as v,cliente as cli,pasaje as p 
		WHERE v.id_chofer=ch.id AND v.id_bus=b.id AND p.id_viaje=v.id AND p.id_cliente=cli.id AND 
			p.fecha > CONCAT(v_fecha,' ','00:00:01') AND p.fecha < CONCAT(v_fecha,' ','23:59:59');
	ELSE
		SELECT 'No se encontraron ventas en esa fecha' error;
	END IF;
END //
