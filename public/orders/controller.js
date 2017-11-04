// ================================================
//   Controlador de Empresas
// ================================================
angular.module('ordersModule').controller('ordersCtrl', ['$scope','ordersService', function($scope,ordersService){

	//var pag = $routeParams.pag;
	var pag = 1;

	$scope.activar('mOrders','','Pedidos','lista de pedidos');
	$scope.orders    = {};
	$scope.objSelt   = {};
	$scope.load      = true;
	$scope.products  = [];
	$scope.s_products= [];
	$scope.monto = 0;
	$scope.account = 0;
	$scope.fillProducts = {};

	$scope.moverA = function( pag ){
		$scope.load = true;

		ordersService.cargarPagina( pag ).then( function(){
			$scope.orders = ordersService;
			$scope.load = false;
		});

	};

	$scope.moverA(pag);

	// ================================================
	//   Mostrar modal de edicion
	// ================================================
	$scope.mostrarModal = function( obj ){

		angular.copy( obj, $scope.objSelt );
		$("#modal_orders").modal();


		ordersService.cargarProducts().then( function(response){
			response.forEach(function(element,index,array) {
				element.cantidad = Number(element.cantidad);
				element.unidad = Number(element.unidad);
				element.price = Number(element.price);
				element.quantity = Number(element.quantity);
				element.quantity_type = Number(element.quantity_type);
				element.unity = Number(element.unity);
			});
			$scope.products = response;
		});

		ordersService.cargarAccount().then( function(response){
			$scope.account = Number(response.account);
		});

	};

	$scope.llenar_products = function(producto,form) {
		var obj = JSON.parse( JSON.stringify( producto ) );
		if( obj.quantity < (obj.cantidad+obj.unidad/obj.quantity_type) ) {
			$("#modal_orders").modal('hide');
			$scope.objSelt = {};
			form.autoValidateFormOptions.resetForm();
			$scope.s_products = [];
			swal("ERROR", "¡Producto Agotado! lo sentimos, producto insuficiente para el pedido.", "error");
			return;
		}
		if(!obj.cantidad)
			return;
		else {
			var valid = true;
			$scope.s_products.forEach(function(element,index,array) {
				if(element.id_products == obj.id_products) {
					valid = false;
					return;
				}
			});
			if(valid) {
				$scope.monto = (obj.cantidad*obj.price)+(obj.unidad*obj.price)/obj.quantity_type;
				if($scope.account >= $scope.monto) {
					$scope.s_products.push(obj);
					$scope.account -= $scope.monto;
				} else {
					$("#modal_orders").modal('hide');
					$scope.objSelt = {};
					form.autoValidateFormOptions.resetForm();
					$scope.s_products = [];
					swal("ERROR", "¡Saldo insuficiente! por favor recargue la cuenta para nuevos pedidos.", "error");
				}
			}
		}
	};
	$scope.dropProducts = function(index,obj) {
		$scope.monto = (obj.cantidad*obj.price)+(obj.unidad*obj.price)/obj.quantity_type;
		$scope.account += $scope.monto;
		$scope.s_products.splice(index,1);
	};

	// ================================================
	//   Funcion para guardar
	// ================================================
	$scope.guardar = function( obj, form){
		if($scope.s_products.length > 0) {
			ordersService.guardarOrders( obj ).then(function(response){

				$scope.s_products.forEach(function(element,index,array) {
					element.id_orders = response.id;
					element.id_user = response.id_user;
					ordersService.guardarContains( element ).then(function(res){

						if( $scope.s_products.length-1 == index ) {
							// codigo cuando se actualizo
							ordersService.cargarPagina( $scope.orders.pag_actual ).then( function(){
								$scope.orders = ordersService;
							});

							$("#modal_orders").modal('hide');
							$scope.objSelt = {};

							form.autoValidateFormOptions.resetForm();

							swal("CORRECTO", "¡"+response.msj+"!", "success");
						}

					});
				});

			});
		}

	};
	// ================================================
	//   Funcion para eliminar
	// ================================================
	$scope.eliminar = function( id ){

		swal({
			title: "¿Esta seguro de eliminar?",
			text: "¡Si confirma esta acción dará de baja la empresa!",
			type: "warning",
			showCancelButton: true,
			confirmButtonColor: "#DD6B55",
			confirmButtonText: "Si, Eliminar!",
			closeOnConfirm: false
		},
		function(){
			ordersService.eliminar( id ).then(function(){
				swal("Eliminado!", "Registro eliminado correctamente.", "success");
			});
		});

	};

	$scope.mostrarProducts = function(id) {
		console.log("puta que lo parió: "+id);
		$("#modal_contains").modal();

		ordersService.cargarProductsSelect( id ).then(function(response){
			$scope.fillProducts = response;
			console.log($scope.fillProducts);
		});
	};

}]);
