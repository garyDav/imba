(function(angular) {

	'use strict';	
	
	angular.module('reportModule')
	.config(['$routeProvider',function($routeProvider) {
		$routeProvider.
			when('/report',{
				templateUrl: 'public/report/views/list.view.html',
				controller: 'reportCtrl'
			});
	}]);



})(window.angular);