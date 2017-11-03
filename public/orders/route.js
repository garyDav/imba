(function(angular) {

	'use strict';	

	angular.module('ordersModule')
	.config(['$routeProvider',function($routeProvider) {
		$routeProvider.
			when('/orders',{
				templateUrl: 'public/orders/views/list.view.html',
				controller: 'ordersCtrl'
			});
	}]);



})(window.angular);

