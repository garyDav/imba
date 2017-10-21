// ================================================
//   Controlador de Empresas
// ================================================
angular.module('businessModule').controller('businessCtrl', ['$scope','businessService', function($scope,businessService){

	//var pag = $routeParams.pag;
	var pag = 1;

	$scope.activar('mUsers','','Usuarios','lista de usuarios');
	$scope.business   = {};
	$scope.businessSel = {};
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
		angular.copy( obj, $scope.businessSel );
		$("#modal_business").modal();

	}

	// ================================================
	//   Funcion para guardar
	// ================================================
	$scope.guardar = function( obj, form){

		businessService.guardar( obj ).then(function(){

			// codigo cuando se actualizo
			$("#modal_business").modal('hide');
			$scope.businessSel = {};

			form.autoValidateFormOptions.resetForm();

		});


	}
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
			businessService.eliminar( id ).then(function(){
				swal("Eliminado!", "Registro eliminado correctamente.", "success");
			});
		});

	}

}]);
