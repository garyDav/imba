<?php if(!defined('SPECIALCONSTANT')) die(json_encode([array('id'=>'0','error'=>'Acceso Denegado')]));

$app->post("/report/",function() use($app) {
	$objDatos = json_decode(file_get_contents("php://input"));

	$startDate = $objDatos->startDate;
	$endDate = $objDatos->endDate;

	try {
		$conex = getConex();



		$sql = "SELECT id,sale,fec,fec_up,'' AS products FROM orders WHERE fec_up >= '$startDate' AND fec_up <= '$endDate';";
		$result = $conex->prepare($sql);
		$result->execute();
		$datos = $result->fetchAll(PDO::FETCH_OBJ);

		$resultado = [];

		foreach ($datos as $valor) {
			$id = $valor->id;
			$sql = "SELECT c.quantity,c.unity,c.price AS price_contains,p.cod,p.name,p.price AS price_product FROM contains c,products p WHERE c.id_orders='$id' AND c.id_products=p.id;";
			$result = $conex->prepare($sql);
			$result->execute();
			//$valor->products = (object) $result->fetchAll(PDO::FETCH_OBJ);
			$valor->products = $result->fetchAll(PDO::FETCH_OBJ);
		}

		$conex = null;

		$app->response->headers->set("Content-type","application/json");
		$app->response->headers->set('Access-Control-Allow-Origin','*');
		$app->response->status(200);
		$app->response->body(json_encode($datos));
	}catch(PDOException $e) {
		echo "Error: ".$e->getMessage();
	}
});