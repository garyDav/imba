-- phpMyAdmin SQL Dump
-- version 4.5.2
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 21-10-2017 a las 15:06:33
-- Versión del servidor: 10.1.13-MariaDB
-- Versión de PHP: 7.0.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `pInsertUser` (IN `v_ci` INT, IN `v_ex` VARCHAR(3), IN `v_name` VARCHAR(50), IN `v_last_name` VARCHAR(50), IN `v_email` VARCHAR(100), IN `v_pwd` VARCHAR(100), IN `v_type` VARCHAR(5))  BEGIN
IF NOT EXISTS(SELECT id FROM user WHERE email LIKE v_email) THEN
INSERT INTO user VALUES(null,v_ci,v_ex,v_name,v_last_name,v_email,v_pwd,v_type,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
SELECT @@identity AS id,v_type AS tipo, 'not' AS error, 'Registro insertado.' AS msj;
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

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `business`
--

CREATE TABLE `business` (
  `id` int(11) NOT NULL,
  `name` varchar(50) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `place` varchar(255) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `latitude` varchar(255) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `length` varchar(255) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `fec` date DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `business`
--

INSERT INTO `business` (`id`, `name`, `place`, `latitude`, `length`, `fec`, `active`) VALUES
(1, 'IMBA', 'lejos', '323323', '23323232', '2017-10-10', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contains`
--

CREATE TABLE `contains` (
  `id` int(11) NOT NULL,
  `id_order` int(11) DEFAULT NULL,
  `id_products` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `unity` int(11) DEFAULT NULL,
  `price` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `id_user` int(11) DEFAULT NULL,
  `reference` varchar(255) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `sale` float DEFAULT NULL,
  `fec` date DEFAULT NULL,
  `fec_up` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

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
  `stock` int(11) DEFAULT NULL,
  `unity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `type`
--

CREATE TABLE `type` (
  `id` int(11) NOT NULL,
  `name` varchar(10) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

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
  `email` varchar(100) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `pwd` varchar(100) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `type` varchar(5) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `fec` date DEFAULT NULL,
  `fec_up` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `user`
--

INSERT INTO `user` (`id`, `id_business`, `ci`, `ex`, `name`, `last_name`, `email`, `pwd`, `type`, `fec`, `fec_up`) VALUES
(1, 1, 4654654, 'Pt', 'Juan', 'Perez', 'juan@gmail.com', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'userc', '2017-10-20', '2017-10-20 00:00:00');

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
  ADD KEY `id_order` (`id_order`),
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT de la tabla `contains`
--
ALTER TABLE `contains`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `type`
--
ALTER TABLE `type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `contains`
--
ALTER TABLE `contains`
  ADD CONSTRAINT `contains_ibfk_1` FOREIGN KEY (`id_order`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `contains_ibfk_2` FOREIGN KEY (`id_products`) REFERENCES `products` (`id`);

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

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
