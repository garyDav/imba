CREATE DATABASE imba;
use imba;

CREATE TABLE business (
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	name varchar(50),
	place varchar(255),
	account float,
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
	src varchar(255),
	email varchar(100),
	pwd varchar(100),
	type varchar(5),
	fec date,
	fec_up datetime,
	active tinyint(1),

	FOREIGN KEY (id_business) REFERENCES business(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE orders (
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_user int,
	--reference varchar(255),
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
	quantity int,
	unity int,
	fec date,
	expiration date,
	active tinyint(1),

	FOREIGN KEY (id_type) REFERENCES type(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE contains (
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_orders int,
	id_products int,
	quantity int,
	unity int,
	price float,

	FOREIGN KEY (id_orders) REFERENCES orders(id),
	FOREIGN KEY (id_products) REFERENCES products(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE img (
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_products int,
	src varchar(255),

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
	IN v_id_business int,
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
		INSERT INTO user VALUES(null,v_id_business,v_ci,v_ex,v_name,v_last_name,'avatar.png',v_email,v_pwd,v_type,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1);
		SELECT @@identity AS id,v_type AS tipo, 'not' AS error, 'Usuario registrado correctamente.' AS msj;
	ELSE
		SELECT 'yes' error,'Error: Correo ya registrado.' msj;
	END IF;
END //

DROP PROCEDURE IF EXISTS pInsertBusiness;
CREATE PROCEDURE pInsertBusiness (
	IN v_name varchar(50),
	IN v_place varchar(255),
	IN v_account float,
	IN v_latitude varchar(255),
	IN v_length varchar(255)
)
BEGIN
	IF NOT EXISTS(SELECT id FROM business WHERE name LIKE v_name) THEN
		INSERT INTO business VALUES(null,v_name,v_place,v_account,v_latitude,v_length,CURRENT_TIMESTAMP,1);
		SELECT @@identity AS id,'not' AS error, 'Empresa registrada.' AS msj;
	ELSE
		SELECT 'yes' error,'Error: Nombre de la empresa ya registrada.' msj;
	END IF;
END //

DROP PROCEDURE IF EXISTS pInsertProducts;
CREATE PROCEDURE pInsertProducts (
	IN v_id_type int,
	IN v_cod varchar(15),
	IN v_name varchar(150),
	IN v_description text,
	IN v_price float,
	IN v_quantity int,
	IN v_unity int,
	IN v_expiration date
)
BEGIN
	IF NOT EXISTS(SELECT id FROM products WHERE cod LIKE v_cod) THEN
		INSERT INTO products VALUES(null,v_id_type,v_cod,v_name,v_description,v_price,v_quantity,v_unity,CURRENT_TIMESTAMP,v_expiration,1);
		SELECT @@identity AS id,'not' AS error, 'Producto registrado correctamente.' AS msj;
	ELSE
		SELECT 'yes' error,'Error: Código del producto ya registrado.' msj;
	END IF;
END //

DROP PROCEDURE IF EXISTS pInsertOrders;
CREATE PROCEDURE pInsertOrders (
	IN v_id_user int,
	IN v_fec_up date
)
BEGIN
	INSERT INTO orders VALUES(null,v_id_user,0,CURRENT_TIMESTAMP,v_fec_up);
	SELECT @@identity AS id,v_id_user AS id_user,'not' AS error, 'Pedido registrado.' AS msj;
END //

DROP PROCEDURE IF EXISTS pInsertContains;
CREATE PROCEDURE pInsertContains (
	IN id_orders int,
	IN id_products int,
	IN canidad int,
	IN unidad int,
	IN price float
)
BEGIN
	INSERT INTO contains VALUES(null,id_orders,id_products,canidad,unidad,price);
	SELECT @@identity AS id,'not' AS error, 'Producto agregado a la cesta.' AS msj;
END //

DROP PROCEDURE IF EXISTS pUpdateUser;
CREATE PROCEDURE pUpdateUser (
	IN v_id int,
	IN v_email varchar(100),
	IN v_pwdA varchar(100),
	IN v_pwdN varchar(100),
	IN v_pwdR varchar(100),
	IN v_src varchar(255)
)
BEGIN
	DECLARE us int(11);
	SET us = (SELECT id FROM user WHERE id=v_id AND pwd LIKE v_pwdA);

	IF ( (v_pwdA NOT LIKE '') AND (v_src NOT LIKE '') ) THEN
		
		IF (us) THEN
			IF (v_pwdN LIKE v_pwdR) THEN
				UPDATE user SET email=v_email,pwd=v_pwdN,src=v_src WHERE id=v_id;
				SELECT v_id AS id, 'not' AS error,'Perfil actualizado.' AS msj;
			ELSE
				SELECT v_id AS id, 'yes' AS error,'Las contraseñas no coinciden, repita bien la nueva contraseña.' AS msj;
			END IF;
		ELSE
			SELECT v_id AS id, 'yes' AS error,'La contraseña antigua no es correcta.' AS msj, (v_pwdA NOT LIKE '') AS res;
		END IF;

	END IF;

	IF ( (v_pwdA LIKE '') AND (v_src LIKE '') ) THEN
		UPDATE user SET email=v_email WHERE id=v_id;
		SELECT v_id AS id, 'not' AS error,'Perfil actualizado.' AS msj;
	ELSE

		IF ( (v_pwdA LIKE '') AND (v_src NOT LIKE '') ) THEN
			UPDATE user SET email=v_email,src=v_src WHERE id=v_id;
			SELECT v_id AS id, 'not' AS error,'Perfil actualizado.' AS msj;
		ELSE
			IF ( (v_src LIKE '') AND (v_pwdA NOT LIKE '') ) THEN
				IF (us) THEN
					IF (v_pwdN LIKE v_pwdR) THEN
						UPDATE user SET email=v_email,pwd=v_pwdN WHERE id=v_id;
						SELECT v_id AS id, 'not' AS error,'Perfil actualizado.' AS msj;
					ELSE
						SELECT v_id AS id, 'yes' AS error,'Las contraseñas no coinciden, repita bien la nueva contraseña.' AS msj;
					END IF;
				ELSE
					SELECT v_id AS id, 'yes' AS error,'La contraseña antigua no es correcta.' AS msj;
				END IF;
			END IF;
		END IF;

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








--Transacciones
DROP PROCEDURE IF EXISTS tInsertContains;
CREATE PROCEDURE tInsertContains (
	IN v_id_user int,
	IN v_id_orders int,
	IN v_id_products int,
	IN v_name varchar(150),
	IN v_name_type varchar(10),
	IN v_cantidad int,
	IN v_unidad int,
	IN v_price float,
	IN v_quantity int,
	IN v_quantity_type int,
	IN v_unity int
)
BEGIN
	DECLARE price_contains float;
	DECLARE sale_tot float;
	DECLARE cant int DEFAULT 0;
	DECLARE unit int DEFAULT 0;
	DECLARE v_account float;

	DECLARE error int DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
		SET error=1;
		SELECT "yes" error,"Transaccion no completada: tInsertPayment" msj;
	END;

	START TRANSACTION;
	SET v_account = (SELECT account FROM business WHERE id=(SELECT id_business FROM user WHERE id=v_id_user));

	SET price_contains = (v_cantidad*v_price)+(v_unidad*v_price)/v_quantity_type;
	SET sale_tot = (SELECT sale FROM orders WHERE id=v_id_orders);

	IF (v_account < price_contains) THEN
		SET error=1;
		SELECT "yes" error,"Saldo insuficiente en su cuenta." msj;
	END IF;

	IF (v_cantidad < v_quantity) THEN
		INSERT INTO contains VALUES(null,v_id_orders,v_id_products,v_cantidad,v_unidad,price_contains);
		UPDATE orders SET sale=(sale_tot+price_contains) WHERE id=v_id_orders;
		UPDATE business SET account=(v_account-price_contains) WHERE id=(SELECT id_business FROM user WHERE id=v_id_user);

		SET cant = v_quantity-v_cantidad;
		IF (v_unidad < v_unity) THEN
			SET unit = v_unity-v_unidad;
		ELSE
			IF (v_unidad > v_unity) THEN
				SET cant = cant-1;
				SET unit = v_unidad-v_unity;
				SET unit = v_quantity_type-unit;
			END IF;
		END IF;

		UPDATE products SET quantity=cant,unity=unit WHERE id=v_id_products;
		SELECT "not" error,"Producto añadido a la cesta." msj;
	ELSE
		SELECT "yes" error,CONCAT('Error: Solo nos queda ',v_quantity,' ',v_name_type,'s del producto ',v_name,'.') msj;
	END IF;

	IF (error = 1) THEN
		ROLLBACK;
	ELSE
		COMMIT;
	END IF;
END //
