(function(angular) {

	'use strict';	
	
	angular.module('businessModule')
	.config(['$routeProvider',function($routeProvider) {
		$routeProvider.
			when('/empresas',{
				templateUrl: 'public/business/views/list.view.html',
				controller: 'businessCtrl'
			});
	}]);



})(window.angular);

