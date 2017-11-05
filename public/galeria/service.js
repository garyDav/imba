(function(angular) {

	'use strict';
	angular.module('galeriaModule').factory('galeriaService',['$http','$q','$rootScope',
		function($http,$q,$rootScope) {
			var self= {
				cargar: function(pag) {
					var d = $q.defer();

					$http.get('rest/v1/img/')
						.success(function( data ){
							if(data) {
								d.resolve(data);
							}
						}).error(function(err) {
							d.reject(err);
							console.error(err);
						});

					return d.promise;
				},
				guardar: function(data) {
					//console.log(data);
					var d = $q.defer();

					$http.post('rest/v1/img/' , data )
					.success(function( response ){

						if ( response.error == 'not' ) {
							self.cargarPagina( self.pag_actual );
							d.resolve();
							swal("CORRECTO", "¡"+response.msj+"!", "success");
						} else 
						if ( response.error == 'yes' )
							swal("ERROR", "¡"+response.msj+"!", "error");
						else {
							swal("ERROR SERVER", "¡"+response+"!", "error");
							console.error(response);
						}

					}).error(function( err ) {
						d.reject(err);
						console.error(err);
					});

					return d.promise;
				}

			};

			return self;
		}
	]);

})(window.angular);
