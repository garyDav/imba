// ================================================
//   Controlador de Empresas
// ================================================
angular.module('businessModule').controller('businessCtrl', ['$scope','businessService', function($scope,businessService){

	//var pag = $routeParams.pag;
	var pag = 1;

	$scope.activar('mBusiness','','Empresas','lista de empresas');
	$scope.business   = {};
	$scope.objSelt = {};
	$scope.load = true;

	$scope.moverA = function( pag ){
		$scope.load = true;

		businessService.cargarPagina( pag ).then( function(){
			$scope.business = businessService;
			$scope.load = false;
		});

	};

	$scope.moverA(pag);

	// ================================================
	//   Mostrar modal de edicion
	// ================================================
	$scope.mostrarModal = function( obj ){

		// console.log( user );
		angular.copy( obj, $scope.objSelt );
		$("#modal_business").modal();

	};

	// ================================================
	//   Funcion para guardar
	// ================================================
	$scope.guardar = function( obj, form){

		businessService.guardar( obj ).then(function(){

			// codigo cuando se actualizo
			$("#modal_business").modal('hide');
			$scope.objSelt = {};

			form.autoValidateFormOptions.resetForm();

		});

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
			businessService.eliminar( id ).then(function(response){
				swal("¡Eliminado!", response.msj, "success");
			});
		});

	};
	// ================================================
	//   Funcion para Habilitar
	// ================================================
	$scope.habilitar = function( id ){
		swal({
			title: "¿Esta seguro de habilitar?",
			text: "¡Si confirma esta acción habilitará la empresa!",
			type: "warning",
			showCancelButton: true,
			confirmButtonColor: "#DD6B55",
			confirmButtonText: "Si, Habilitar!",
			closeOnConfirm: false
		},
		function(){
			businessService.habilitar( id ).then(function(response){
				swal("¡Habilitado!", response.msj, "success");
			});
		});
	};

}]);
