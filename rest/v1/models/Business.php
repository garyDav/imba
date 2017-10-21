<?php if(!defined('SPECIALCONSTANT')) die(json_encode([array('id'=>'0','error'=>'Acceso Denegado')]));

$app->get('/business/:id',function($id) use($app) {
	try {
		//sleep(1);
		if( isset( $id ) ){
			$pag = $id;
		}else{
			$pag = 1;
		}
		$res = get_todo_paginado( 'business', $pag );

		$app->response->headers->set('Content-type','application/json');
		$app->response->headers->set('Access-Control-Allow-Origin','*');
		$app->response->status(200);
		$app->response->body(json_encode($res));
	}catch(PDOException $e) {
		echo 'Error: '.$e->getMessage();
	}
});

$app->post("/business/",function() use($app) {
	try {
		$postdata = file_get_contents("php://input");

		$request = json_decode($postdata);
		$request = (array) $request;
		$conex = getConex();
		$res = array( 'error'=>'yes', 'msj'=>'Puta no se pudo hacer nada, revisa mierda' );

		if( isset( $request['id'] )  ){  // ACTUALIZAR

			$sql = "UPDATE business 
						SET
							name 	 = '". $request['name'] ."',
							place 	 = '". $request['place'] ."',
							latitude = '". $request['latitude'] ."',
							length   = '". $request['length'] ."'
					WHERE id=" . $request['id'].";";

			$hecho = $conex->prepare( $sql );
			$hecho->execute();
			$conex = null;
			
			$res = array( 'id'=>$request['id'], 'error'=>'not', 'msj'=>'Registro actualizado' );

		}else{  // INSERT

			$sql = "CALL pInsertBusiness(
						'". $request['name'] . "',
						'". $request['place'] . "',
						'". $request['latitude'] . "',
						'". $request['length'] . "');";

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

$app->delete('/business/:id',function($id) use($app) {
	try {
		$conex = getConex();
		$result = $conex->prepare("UPDATE business 
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


