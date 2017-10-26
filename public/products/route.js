(function(angular) {

	'use strict';	
	
	angular.module('businessModule')
	.config(['$routeProvider',function($routeProvider) {
		$routeProvider.
			when('/products',{
				templateUrl: 'public/products/views/list.view.html',
				controller: 'productsCtrl'
			});
	}]);



})(window.angular);

