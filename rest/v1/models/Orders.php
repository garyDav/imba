<?php if(!defined('SPECIALCONSTANT')) die(json_encode([array('id'=>'0','error'=>'Acceso Denegado')]));

$app->get('/products',function() use($app) {
	try {
		$conex = getConex();
		$sql = "SELECT p.id id_products,p.cod,p.name,p.price,p.quantity,p.unity,p.unity,p.expiration,p.active,t.id id_type,t.name name_type,t.quantity quantity_type,'0' cantidad,'0' unidad FROM products p,type t WHERE p.id_type=t.id AND active='1';";
		$result = $conex->prepare( $sql );
		$result->execute();
		$conex = null;
		$res = $result->fetchAll(PDO::FETCH_OBJ);

		$app->response->headers->set('Content-type','application/json');
		$app->response->headers->set('Access-Control-Allow-Origin','*');
		$app->response->status(200);
		$app->response->body(json_encode($res));

	}catch(PDOException $e) {
		echo 'Error: '.$e->getMessage();
	}
})->conditions(array('id'=>'[0-9]{1,11}'));

$app->get('/orders/products/:id',function($id) use($app) {
	try {
		$conex = getConex();
		$sql = "SELECT c.id,c.quantity,c.unity,c.price,p.cod,p.name FROM contains c,products p,orders o WHERE c.id_orders=o.id AND c.id_products=p.id ORDER BY c.id;";
		$result = $conex->prepare( $sql );
		$result->execute();
		$conex = null;
		$res = $result->fetchAll(PDO::FETCH_OBJ);

		$app->response->headers->set('Content-type','application/json');
		$app->response->headers->set('Access-Control-Allow-Origin','*');
		$app->response->status(200);
		$app->response->body(json_encode($res));

	}catch(PDOException $e) {
		echo 'Error: '.$e->getMessage();
	}
})->conditions(array('id'=>'[0-9]{1,11}'));


$app->get('/orders/account/:id',function($id) use($app) {
	try {
		$conex = getConex();
		$sql = "SELECT account FROM business WHERE id=(SELECT id_business FROM user WHERE id=".$id.");";
		$result = $conex->prepare( $sql );
		$result->execute();
		$conex = null;
		$res = $result->fetchObject();

		$app->response->headers->set('Content-type','application/json');
		$app->response->headers->set('Access-Control-Allow-Origin','*');
		$app->response->status(200);
		$app->response->body(json_encode($res));

	}catch(PDOException $e) {
		echo 'Error: '.$e->getMessage();
	}
})->conditions(array('id'=>'[0-9]{1,11}'));



$app->get('/orders/:id',function($id) use($app) {
	try {
		//sleep(1);
		if( isset( $id ) ){
			$pag = $id;
		}else{
			$pag = 1;
		}
		$res = get_paginado_orders( $pag );

		$app->response->headers->set('Content-type','application/json');
		$app->response->headers->set('Access-Control-Allow-Origin','*');
		$app->response->status(200);
		$app->response->body(json_encode($res));
	}catch(PDOException $e) {
		echo 'Error: '.$e->getMessage();
	}
});

$app->post("/orders/",function() use($app) {
	try {
		$postdata = file_get_contents("php://input");

		$request = json_decode($postdata);
		$request = (array) $request;
		$conex = getConex();

		$sql = "CALL pInsertOrders(
					'". $request['id_user'] . "',
					'". $request['fec_up'] . "');";

		$hecho = $conex->prepare( $sql );
		$hecho->execute();
		$conex = null;

		$res = $hecho->fetchObject();

		$app->response->headers->set('Content-type','application/json');
		$app->response->status(200);
		$app->response->body(json_encode($res));

	}catch(PDOException $e) {
		echo "Error: ".$e->getMessage();
	}
});

$app->post("/orders/contains",function() use($app) {
	try {
		$postdata = file_get_contents("php://input");

		$request = json_decode($postdata);
		$request = (array) $request;
		$conex = getConex();

		$sql = "CALL tInsertContains(
					'". $request['id_user'] . "',
					'". $request['id_orders'] . "',
					'". $request['id_products'] . "',
					'". $request['name'] . "',
					'". $request['name_type'] . "',
					'". $request['cantidad'] . "',
					'". $request['unidad'] . "',
					'". $request['price'] . "',
					'". $request['quantity'] . "',
					'". $request['quantity_type'] . "',
					'". $request['unity'] . "');";

		$hecho = $conex->prepare( $sql );
		$hecho->execute();
		$conex = null;

		$res = $hecho->fetchObject();

		$app->response->headers->set('Content-type','application/json');
		$app->response->status(200);
		$app->response->body(json_encode($res));

	}catch(PDOException $e) {
		echo "Error: ".$e->getMessage();
	}
});

$app->delete('/orders/:id',function($id) use($app) {
	try {
		$conex = getConex();
		$result = $conex->prepare("UPDATE orders 
									SET active   = '0'
								   WHERE id=".$id.";");

		$result->execute();
		$conex = null;

		$app->response->headers->set('Content-type','application/json');
		$app->response->status(200);
		$app->response->body(json_encode(array('id'=>$id,'error'=>'not','msj'=>'Empresa desactivada correctamente.')));

	} catch(PDOException $e) {
		echo 'Error: '.$e->getMessage();
	}
})->conditions(array('id'=>'[0-9]{1,11}'));


