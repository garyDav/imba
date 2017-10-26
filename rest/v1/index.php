<?php
//Libreria de Slim
require '../vendor/Slim/Slim.php';
//end Libreria.

\Slim\Slim::registerAutoloader();

$app = new \Slim\Slim();

session_start();
//if( isset( $_SESSION['user'] ) )
	define('SPECIALCONSTANT',true);

//EntidadesRESTFULL
require 'models/connect.php';
require 'models/general.php';

require 'models/User.php';
require 'models/Business.php';
require 'models/Products.php';
//require 'models/Reporte.php';
//end EntidadesRESTFULL

$app->run();



?>

