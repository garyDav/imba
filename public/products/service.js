angular.module('productsModule').factory('productsService', ['$http', '$q', function($http, $q){

	var self = {

		'cargando'		: false,
		'err'     		: false,
		'conteo' 		: 0,
		'products' 		: [],
		'pag_actual'    : 1,
		'pag_siguiente' : 1,
		'pag_anterior'  : 1,
		'total_paginas' : 1,
		'paginas'	    : [],

		formatDate: function( date ) {
			var d = new Date(date);
			var month = '' + (d.getMonth() + 1);
			var day = '' + d.getDate();
			var year = d.getFullYear();

			if (month.length < 2) month = '0' + month;
			if (day.length < 2) day = '0' + day;

			return [year, month, day].join('-');
		},


		guardar: function( pro ){
			//console.log(pro);

			var products = JSON.parse( JSON.stringify( pro ) );
			products.expiration = self.formatDate(products.expiration);

			var d = $q.defer();

			$http.post('rest/v1/products/' , products )
				.success(function( respuesta ){

					if ( respuesta.error == 'not' ) {
						self.cargarPagina( self.pag_actual  );
						d.resolve();
						swal("CORRECTO", "¡"+respuesta.msj+"!", "success");
					} else 
					if ( respuesta.error == 'yes' )
						swal("ERROR", "¡"+respuesta.msj+"!", "error");
					else 
						console.error(respuesta);
						//swal("ERROR SERVER", "¡"+respuesta+"!", "error");;
				});

			return d.promise;

		},

		eliminar: function( id ){

			var d = $q.defer();

			$http.delete('rest/v1/products/' + id )
				.success(function( respuesta ){

					self.cargarPagina( self.pag_actual  );
					d.resolve(respuesta);

				});

			return d.promise;

		},

		habilitar: function( id ){

			var d = $q.defer();

			$http.delete('rest/v1/products/active/' + id )
				.success(function( respuesta ){

					self.cargarPagina( self.pag_actual  );
					d.resolve(respuesta);

				});

			return d.promise;

		},


		cargarPagina: function( pag ){

			var d = $q.defer();

			$http.get('rest/v1/products/' + pag )
				.success(function( data ){
					console.log( data );
					if(data) {

						data.products.forEach(function(element,index,array) {
							var values = element.expiration.split("-");
							element.expiration = new Date(Number(values[0]), Number(values[1]-1), Number(values[2]));
						});

						self.err           = data.err;
						self.conteo        = data.conteo;
						self.products      = data.products;
						self.pag_actual    = data.pag_actual;
						self.pag_siguiente = data.pag_siguiente;
						self.pag_anterior  = data.pag_anterior;
						self.total_paginas = data.total_paginas;
						self.paginas       = data.paginas;

					}
					return d.resolve();
				});

			return d.promise;
		},

		cargarType: function(){

			var d = $q.defer();

			$http.get('rest/v1/type')
				.success(function( response ){

				d.resolve( response );

			}).error(function( err ) {
				d.reject( err );
				console.error( err );
			});

			return d.promise;

		}


	};

	return self;

}]);
