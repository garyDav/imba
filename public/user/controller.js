// ================================================
//   Controlador de usuarios
// ================================================
angular.module('userModule').controller('userCtrl', ['$scope', 'userService', function($scope, userService){

	var pag = 1;

	//$scope.bussines = {nombre:["Santa Cruz de la Sierra","El Alto","La Paz","Cochabamba","Oruro","Sucre","Tarija","Potosí","Sacaba","Quillacollo","Montero","Trinidad","Riberalta","Warnes","La Guardia","Viacha","Yacuiba","Colcapirhua","Tiquipaya","Cobija","Vinto","Guayaramerín","Villazón","Villa Yapacaní","Villa Montes","Bermejo","Camiri","Tupiza","Llallagua","San Ignacio de Velasco","San Julián","Huanuni"]};
	$scope.bussines = {};
	$scope.activar('mUsers','','Usuarios','lista de usuarios');
	$scope.users   = {};
	$scope.userSel = {};
	$scope.load = true;


	$scope.completeReg = function(string){
        if(string) {
            $scope.hidethis = false;
            var output = [];
            angular.forEach($scope.bussines, function(element){ 
                if(element.name.toLowerCase().indexOf(string.toLowerCase()) >= 0)  {
                    output.push(element);
                }
            });
            $scope.filterObj = output;
        } else
            $scope.filterObj = [];
    };
    $scope.fillTextbox = function(elem){
       $scope.userSel.id_business = elem.id;
       $scope.userSel.complete = elem.name;
       $scope.hidethis = true;
    };


	$scope.moverA = function( pag ){
		$scope.load = true;

		userService.cargarPagina( pag ).then( function(){
			$scope.users = userService;
			$scope.load = false;
		});

	};

	$scope.moverA(pag);

	// ================================================
	//   Mostrar modal de edicion
	// ================================================
	$scope.mostrarModal = function( user ){

		// console.log( user );
		angular.copy( user, $scope.userSel );
		$("#modal_user").modal();


		userService.cargarEmpresas().then( function(response){
			$scope.bussines = response;
			$scope.bussines.forEach(function(element,index,array) {
				if( element.id == $scope.userSel.id_business ) {
					$scope.userSel.complete = element.name;
				}
			});
			console.log($scope.bussines);
		});

	};

	// ================================================
	//   Funcion para guardar
	// ================================================
	$scope.guardar = function( user, frmUser){

		userService.guardar( user ).then(function(){

			// codigo cuando se actualizo
			$("#modal_user").modal('hide');
			$scope.userSel = {};

			frmUser.autoValidateFormOptions.resetForm();

		});


	};
	// ================================================
	//   Funcion para eliminar
	// ================================================
	$scope.eliminar = function( id ){

		swal({
			title: "¿Esta seguro desactivar la cuenta?",
			text: "¡Si confirma esta acción dará de baja el usuario!",
			type: "warning",
			showCancelButton: true,
			confirmButtonColor: "#DD6B55",
			confirmButtonText: "Si, Eliminar!",
			closeOnConfirm: false
		},
		function(){
			userService.eliminar( id ).then(function(response){
				swal("Eliminado!", response.msj, "success");
			});
		});

	};
	// ================================================
	//   Funcion para Habilitar
	// ================================================
	$scope.habilitar = function( id ){
		swal({
			title: "¿Esta seguro de habilitar?",
			text: "¡Si confirma esta acción habilitará el usuario!",
			type: "warning",
			showCancelButton: true,
			confirmButtonColor: "#DD6B55",
			confirmButtonText: "Si, Habilitar!",
			closeOnConfirm: false
		},
		function(){
			userService.habilitar( id ).then(function(response){
				swal("¡Habilitado!", response.msj, "success");
			});
		});
	};

}]);
