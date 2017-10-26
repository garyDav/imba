<?php if(!defined('SPECIALCONSTANT')) die(json_encode([array('id'=>'0','error'=>'Acceso Denegado')]));

$app->get('/type',function() use($app) {
	try {
		$conex = getConex();
		$sql = "SELECT id,name,quantity FROM type;";
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



$app->get('/products/:id',function($id) use($app) {
	try {
		//sleep(1);
		if( isset( $id ) ){
			$pag = $id;
		}else{
			$pag = 1;
		}
		$res = get_todo_paginado( 'products', $pag );

		$app->response->headers->set('Content-type','application/json');
		$app->response->headers->set('Access-Control-Allow-Origin','*');
		$app->response->status(200);
		$app->response->body(json_encode($res));
	}catch(PDOException $e) {
		echo 'Error: '.$e->getMessage();
	}
});

$app->post("/products/",function() use($app) {
	try {
		$postdata = file_get_contents("php://input");

		$request = json_decode($postdata);
		$request = (array) $request;
		$conex = getConex();
		$res = array( 'error'=>'yes', 'msj'=>'Puta no se pudo hacer nada, revisa mierda' );

		if( isset( $request['id'] )  ){  // ACTUALIZAR

			$sql = "UPDATE products 
						SET
							id_type 	 = '". $request['id_type'] ."',
							cod 	 = '". $request['cod'] ."',
							name 	 = '". $request['name'] ."',
							description 	 = '". $request['description'] ."',
							price 	 = '". $request['price'] ."',
							quantity 	 = '". $request['quantity'] ."',
							unity 	 = '". $request['unity'] ."',
							expiration 	 = '". $request['expiration'] ."'
							
					WHERE id=" . $request['id'].";";

			$hecho = $conex->prepare( $sql );
			$hecho->execute();
			$conex = null;
			
			$res = array( 'id'=>$request['id'], 'error'=>'not', 'msj'=>'Producto actualizado' );

		}else{  // INSERT

			$sql = "CALL pInsertProducts(
						'". $request['id_type'] . "',
						'". $request['cod'] . "',
						'". $request['name'] . "',
						'". $request['description'] . "',
						'". $request['price'] . "',
						'". $request['quantity'] . "',
						'". $request['unity'] . "',
						'". $request['expiration'] . "');";

			$hecho = $conex->prepare( $sql );
			$hecho->execute();
			$conex = null;

			$res = $hecho->fetchObject();

		}

		$app->response->headers->set('Content-type','application/json');
		$app->response->status(200);
		$app->response->body(json_encode($res));

	}catch(PDOException $e) {
		echo "Error: ".$e->getMessage();
	}
});

$app->delete('/products/:id',function($id) use($app) {
	try {
		$conex = getConex();
		$result = $conex->prepare("UPDATE products 
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


