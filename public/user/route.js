(function(angular) {
	'use strict';

	angular.module('userModule')
	.config(['$routeProvider',function($routeProvider) {
		$routeProvider.
			when('/users',{
				templateUrl: 'public/user/views/list.view.html',
				controller: 'userCtrl'
			});
	}]);


})(window.angular);