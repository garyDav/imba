// ================================================
//   Controlador de Empresas
// ================================================
angular.module('productsModule').controller('productsCtrl', ['$scope','productsService', function($scope,productsService){

	//var pag = $routeParams.pag;
	var pag = 1;

	$scope.p_type  = {}; 
	$scope.activar('mProducts','','Productos','lista de productos');
	$scope.products= {};
	$scope.objSelt = {};
	$scope.load    = true;

	$scope.completeReg = function(string){
        if(string) {
            $scope.hidethis = false;
            var output = [];
            angular.forEach($scope.p_type, function(element){ 
                if(element.name.toLowerCase().indexOf(string.toLowerCase()) >= 0)  {
                    output.push(element);
                }
            });
            $scope.filterObj = output;
        } else
            $scope.filterObj = [];
    };
    $scope.fillTextbox = function(elem){
       $scope.objSelt.id_type = elem.id;
       $scope.objSelt.complete = elem.name;
       $scope.hidethis = true;
    };

	$scope.moverA = function( pag ){
		$scope.load = true;

		productsService.cargarPagina( pag ).then( function(){
			$scope.products = productsService;
			$scope.load = false;
		});

	};

	$scope.moverA(pag);

	// ================================================
	//   Mostrar modal de edicion
	// ================================================
	$scope.mostrarModal = function( obj ){

		angular.copy( obj, $scope.objSelt );
		//console.log( $scope.objSelt );
		$("#modal_products").modal();

		productsService.cargarType().then( function(response){
			$scope.p_type = response;
			$scope.p_type.forEach(function(element,index,array) {
				if( element.id == $scope.objSelt.id_type ) {
					$scope.objSelt.complete = element.name;
				}
			});
			console.log($scope.p_type);
		});

	}

	// ================================================
	//   Funcion para guardar
	// ================================================
	$scope.guardar = function( obj, form){

		productsService.guardar( obj ).then(function(){

			// codigo cuando se actualizo
			$("#modal_products").modal('hide');
			$scope.objSelt = {};

			form.autoValidateFormOptions.resetForm();

		});


	}
	// ================================================
	//   Funcion para eliminar
	// ================================================
	$scope.eliminar = function( id ){

		swal({
			title: "¿Esta seguro de eliminar?",
			text: "¡Si confirma esta acción dará de baja el producto!",
			type: "warning",
			showCancelButton: true,
			confirmButtonColor: "#DD6B55",
			confirmButtonText: "Si, Eliminar!",
			closeOnConfirm: false
		},
		function(){
			productsService.eliminar( id ).then(function(response){
				swal("Eliminado!", response.msj, "success");
			});
		});

	}

	// ================================================
	//   Funcion para Habilitar
	// ================================================
	$scope.habilitar = function( id ){

		swal({
			title: "¿Esta seguro de habilitar?",
			text: "¡Si confirma esta acción habilitará el producto!",
			type: "warning",
			showCancelButton: true,
			confirmButtonColor: "#DD6B55",
			confirmButtonText: "Si, Habilitar!",
			closeOnConfirm: false
		},
		function(){
			productsService.habilitar( id ).then(function(response){
				swal("Habilitado!", response.msj, "success");
			});
		});

	}

}]);
