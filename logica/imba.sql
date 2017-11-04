-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 04-11-2017 a las 20:28:11
-- Versión del servidor: 10.1.26-MariaDB
-- Versión de PHP: 7.1.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `imba`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `pInsertBusiness` (IN `v_name` VARCHAR(50), IN `v_place` VARCHAR(255), IN `v_account` FLOAT, IN `v_latitude` VARCHAR(255), IN `v_length` VARCHAR(255))  BEGIN
IF NOT EXISTS(SELECT id FROM business WHERE name LIKE v_name) THEN
INSERT INTO business VALUES(null,v_name,v_place,v_account,v_latitude,v_length,CURRENT_TIMESTAMP,1);
SELECT @@identity AS id,'not' AS error, 'Empresa registrada.' AS msj;
ELSE
SELECT 'yes' error,'Error: Nombre de la empresa ya registrada.' msj;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pInsertContains` (IN `id_orders` INT, IN `id_products` INT, IN `canidad` INT, IN `unidad` INT, IN `price` FLOAT)  BEGIN
INSERT INTO contains VALUES(null,id_orders,id_products,canidad,unidad,price);
SELECT @@identity AS id,'not' AS error, 'Producto agregado a la cesta.' AS msj;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pInsertOrders` (IN `v_id_user` INT, IN `v_fec_up` DATE)  BEGIN
INSERT INTO orders VALUES(null,v_id_user,0,CURRENT_TIMESTAMP,v_fec_up);
SELECT @@identity AS id,v_id_user AS id_user,'not' AS error, 'Pedido registrado.' AS msj;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pInsertProducts` (IN `v_id_type` INT, IN `v_cod` VARCHAR(15), IN `v_name` VARCHAR(150), IN `v_description` TEXT, IN `v_price` FLOAT, IN `v_quantity` INT, IN `v_unity` INT, IN `v_expiration` DATE)  BEGIN
IF NOT EXISTS(SELECT id FROM products WHERE cod LIKE v_cod) THEN
INSERT INTO products VALUES(null,v_id_type,v_cod,v_name,v_description,v_price,v_quantity,v_unity,CURRENT_TIMESTAMP,v_expiration,1);
SELECT @@identity AS id,'not' AS error, 'Producto registrado correctamente.' AS msj;
ELSE
SELECT 'yes' error,'Error: Código del producto ya registrado.' msj;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pInsertUser` (IN `v_id_business` INT, IN `v_ci` INT, IN `v_ex` VARCHAR(3), IN `v_name` VARCHAR(50), IN `v_last_name` VARCHAR(50), IN `v_email` VARCHAR(100), IN `v_pwd` VARCHAR(100), IN `v_type` VARCHAR(5))  BEGIN
IF NOT EXISTS(SELECT id FROM user WHERE email LIKE v_email) THEN
INSERT INTO user VALUES(null,v_id_business,v_ci,v_ex,v_name,v_last_name,'avatar.png',v_email,v_pwd,v_type,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1);
SELECT @@identity AS id,v_type AS tipo, 'not' AS error, 'Usuario registrado correctamente.' AS msj;
ELSE
SELECT 'yes' error,'Error: Correo ya registrado.' msj;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pSession` (IN `v_email` VARCHAR(100), IN `v_pwd` VARCHAR(100))  BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pUpdateUser` (IN `v_id` INT, IN `v_email` VARCHAR(100), IN `v_pwdA` VARCHAR(100), IN `v_pwdN` VARCHAR(100), IN `v_pwdR` VARCHAR(100), IN `v_src` VARCHAR(255))  BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tInsertContains` (IN `v_id_user` INT, IN `v_id_orders` INT, IN `v_id_products` INT, IN `v_name` VARCHAR(150), IN `v_name_type` VARCHAR(10), IN `v_cantidad` INT, IN `v_unidad` INT, IN `v_price` FLOAT, IN `v_quantity` INT, IN `v_quantity_type` INT, IN `v_unity` INT)  BEGIN
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
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `business`
--

CREATE TABLE `business` (
  `id` int(11) NOT NULL,
  `name` varchar(50) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `place` varchar(255) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `account` float NOT NULL,
  `latitude` varchar(255) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `length` varchar(255) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `fec` date DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `business`
--

INSERT INTO `business` (`id`, `name`, `place`, `account`, `latitude`, `length`, `fec`, `active`) VALUES
(1, 'IMBA', 'lejos', 0, '323323', '23323232', '2017-10-10', 1),
(6, 'Rosita', 'por la plaza', 10000, '123123123', '123123213', '2017-11-01', 1),
(7, 'Lia', 'por la plaza', 10000, '45495892359', '90325809342', '2017-11-01', 1),
(8, 'Anghy', 'lejos', 2740, '94958345003', '43504395039', '2017-11-01', 1),
(9, 'Pollos Chino', 'por la pea', 10000, '134232399898', '923894893843', '2017-11-01', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contains`
--

CREATE TABLE `contains` (
  `id` int(11) NOT NULL,
  `id_orders` int(11) DEFAULT NULL,
  `id_products` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `unity` int(11) DEFAULT NULL,
  `price` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `contains`
--

INSERT INTO `contains` (`id`, `id_orders`, `id_products`, `quantity`, `unity`, `price`) VALUES
(24, 21, 6, 10, 0, 350),
(25, 21, 5, 12, 0, 3960),
(26, 21, 7, 5, 0, 750),
(27, 22, 5, 4, 0, 1320),
(28, 22, 7, 2, 0, 300),
(29, 22, 4, 2, 0, 580);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `img`
--

CREATE TABLE `img` (
  `id` int(11) NOT NULL,
  `id_products` int(11) DEFAULT NULL,
  `src` varchar(255) COLLATE utf8_spanish2_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `id_user` int(11) DEFAULT NULL,
  `sale` float DEFAULT NULL,
  `fec` date DEFAULT NULL,
  `fec_up` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `orders`
--

INSERT INTO `orders` (`id`, `id_user`, `sale`, `fec`, `fec_up`) VALUES
(21, 8, 5060, '2017-11-01', '2017-11-03'),
(22, 8, 2200, '2017-11-01', '2017-11-02');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `id_type` int(11) DEFAULT NULL,
  `cod` varchar(15) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `name` varchar(150) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `description` text COLLATE utf8_spanish2_ci,
  `price` float DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `unity` int(11) DEFAULT NULL,
  `fec` date NOT NULL,
  `expiration` date NOT NULL,
  `active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `products`
--

INSERT INTO `products` (`id`, `id_type`, `cod`, `name`, `description`, `price`, `quantity`, `unity`, `fec`, `expiration`, `active`) VALUES
(4, 4, 'C-001', 'Trozo de pollo Pechuga', 'Trozo de pollo Pechuga', 290, 48, 10, '2017-11-01', '2017-12-03', 1),
(5, 2, 'C-002', 'Piernas', 'Cuarto de Piernas', 330, 44, 20, '2017-11-01', '2017-12-03', 1),
(6, 1, 'C-003', 'Muslos', 'Pollo en bandeja muslos', 35, 60, 3, '2017-11-01', '2017-12-03', 1),
(7, 3, 'C-004', 'Filete de Pecho', 'Pollo deshuesado Filete de Pecho', 150, 1, 5, '2017-11-01', '2017-12-03', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `type`
--

CREATE TABLE `type` (
  `id` int(11) NOT NULL,
  `name` varchar(10) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `type`
--

INSERT INTO `type` (`id`, `name`, `quantity`) VALUES
(1, 'set', 5),
(2, 'caja', 40),
(3, 'bolsa', 10),
(4, 'fardo', 35);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `id_business` int(11) DEFAULT NULL,
  `ci` int(11) DEFAULT NULL,
  `ex` varchar(3) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `name` varchar(50) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `last_name` varchar(50) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `src` varchar(255) COLLATE utf8_spanish2_ci NOT NULL,
  `email` varchar(100) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `pwd` varchar(100) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `type` varchar(5) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `fec` date DEFAULT NULL,
  `fec_up` datetime DEFAULT NULL,
  `active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `user`
--

INSERT INTO `user` (`id`, `id_business`, `ci`, `ex`, `name`, `last_name`, `src`, `email`, `pwd`, `type`, `fec`, `fec_up`, `active`) VALUES
(1, 1, 4654654, 'Pt', 'Alvaro', 'Antezana Ortega', 'alvaro.jpg', 'alvaro@gmail.com', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'jefev', '2017-10-20', '2017-10-20 00:00:00', 1),
(8, 8, 10298398, 'Ch', 'Juan', 'Perez', 'avatar3-687.png', 'juan@gmail.com', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', '2017-11-01', '2017-11-01 21:40:59', 1),
(9, 6, 238423987, 'Or', 'Roberto Carlos', 'Mendez Contreras', 'avatar.png', 'roberto@gmail.com', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', '2017-11-01', '2017-11-01 21:42:10', 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `business`
--
ALTER TABLE `business`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `contains`
--
ALTER TABLE `contains`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_order` (`id_orders`),
  ADD KEY `id_products` (`id_products`);

--
-- Indices de la tabla `img`
--
ALTER TABLE `img`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_products` (`id_products`);

--
-- Indices de la tabla `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_user` (`id_user`);

--
-- Indices de la tabla `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_type` (`id_type`);

--
-- Indices de la tabla `type`
--
ALTER TABLE `type`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_business` (`id_business`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `business`
--
ALTER TABLE `business`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `contains`
--
ALTER TABLE `contains`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT de la tabla `img`
--
ALTER TABLE `img`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `type`
--
ALTER TABLE `type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `contains`
--
ALTER TABLE `contains`
  ADD CONSTRAINT `contains_ibfk_1` FOREIGN KEY (`id_orders`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `contains_ibfk_2` FOREIGN KEY (`id_products`) REFERENCES `products` (`id`);

--
-- Filtros para la tabla `img`
--
ALTER TABLE `img`
  ADD CONSTRAINT `img_ibfk_1` FOREIGN KEY (`id_products`) REFERENCES `products` (`id`);

--
-- Filtros para la tabla `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id`);

--
-- Filtros para la tabla `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`id_type`) REFERENCES `type` (`id`);

--
-- Filtros para la tabla `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`id_business`) REFERENCES `business` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
