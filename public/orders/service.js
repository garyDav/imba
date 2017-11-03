angular.module('ordersModule').factory('ordersService', ['$http', '$q', '$rootScope', function($http, $q, $rootScope){

	var self = {

		'cargando'		: false,
		'err'     		: false,
		'conteo' 		: 0,
		'orders' 		: [],
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

		guardarOrders: function( obj ) {

			var d = $q.defer();
			var orders = JSON.parse( JSON.stringify( obj ) );
			orders.fec_up = self.formatDate(orders.fec_up);
			orders.id_user = $rootScope.userID;

			$http.post('rest/v1/orders/' , orders )
				.success(function( respuesta ){
					if ( respuesta.error == 'not' ) {
						//self.cargarPagina( self.pag_actual  );
						d.resolve(respuesta);
					} else {
						console.error(respuesta);
					}
				}).error(function( err ) {
					d.reject( err );
					console.error( err );
				});

			return d.promise;

		},

		guardarContains: function( obj ) {
			console.log(obj);

			var d = $q.defer();

			$http.post('rest/v1/orders/contains' , obj )
				.success(function( respuesta ){
					//console.log(respuesta);
					if ( respuesta.error == 'not' ) {
						d.resolve(respuesta);
					} else {
						console.error(respuesta);
					}
				}).error(function( err ) {
					d.reject( err );
					console.error( err );
				});

			return d.promise;

		},

		eliminar: function( id ){

			var d = $q.defer();

			$http.delete('rest/v1/orders/' + id )
				.success(function( respuesta ){

					self.cargarPagina( self.pag_actual  );
					d.resolve();

				});

			return d.promise;

		},


		cargarPagina: function( pag ){

			var d = $q.defer();

			$http.get('rest/v1/orders/' + pag )
				.success(function( data ){
					//console.log( data );
					if(data) {

						data.orders.forEach(function(element,index,array) {
							var values = element.fec_up.split("-");
							element.fec_up = new Date(Number(values[0]), Number(values[1]-1), Number(values[2]));
						});

						self.err           = data.err;
						self.conteo        = data.conteo;
						self.orders        = data.orders;
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

		cargarProducts: function(){

			var d = $q.defer();

			$http.get('rest/v1/products')
				.success(function( response ){

				d.resolve( response );

			}).error(function( err ) {
				d.reject( err );
				console.error( err );
			});

			return d.promise;

		},

		cargarAccount: function() {
			var d = $q.defer();

			$http.get('rest/v1/orders/account/'+$rootScope.userID)
				.success(function( response ){

				d.resolve( response );

			}).error(function( err ) {
				d.reject( err );
				console.error( err );
			});

			return d.promise;
		},

		cargarProductsSelect: function(id) {
			var d = $q.defer();

			$http.get('rest/v1/orders/products/'+id)
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
