angular.module('businessModule').factory('businessService', ['$http', '$q', function($http, $q){

	var self = {

		'cargando'		: false,
		'err'     		: false, 
		'conteo' 		: 0,
		'business' 		: [],
		'pag_actual'    : 1,
		'pag_siguiente' : 1,
		'pag_anterior'  : 1,
		'total_paginas' : 1,
		'paginas'	    : [],


		guardar: function( business ){

			var d = $q.defer();

			$http.post('rest/v1/business/' , business )
				.success(function( respuesta ){

					if ( respuesta.error == 'not' ) {
						self.cargarPagina( self.pag_actual  );
						d.resolve();
						swal("CORRECTO", "¡"+respuesta.msj+"!", "success");
					} else 
					if ( respuesta.error == 'yes' )
						swal("ERROR", "¡"+respuesta.msj+"!", "error");
					else 
						swal("ERROR SERVER", "¡"+respuesta+"!", "error");;
				});

			return d.promise;

		},

		eliminar: function( id ){

			var d = $q.defer();

			$http.delete('rest/v1/business/' + id )
				.success(function( respuesta ){

					self.cargarPagina( self.pag_actual  );
					d.resolve();

				});

			return d.promise;

		},


		cargarPagina: function( pag ){

			var d = $q.defer();

			$http.get('rest/v1/business/' + pag )
				.success(function( data ){
					console.log( data );
					if(data) {

						self.err           = data.err;
						self.conteo        = data.conteo;
						self.business      = data.business;
						self.pag_actual    = data.pag_actual;
						self.pag_siguiente = data.pag_siguiente;
						self.pag_anterior  = data.pag_anterior;
						self.total_paginas = data.total_paginas;
						self.paginas       = data.paginas;

					}
					return d.resolve();
				});

			return d.promise;
		}


	};

	return self;

}]);
