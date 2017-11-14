(function(angular) {

	'use strict';
	angular.module('reportModule').factory('reportService',['$http','$q',
		function($http,$q) {
			var self= {
				cargarReport: function(data) {
					var d = $q.defer();

					$http.post('rest/v1/report/',data)
						.success(function( data ){
							if(data) {
								d.resolve(data);
							}
						}).error(function(err) {
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
