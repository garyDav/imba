// ================================================
//   Controlador de Reportes
// ================================================
angular.module('reportModule').controller('reportCtrl', ['$scope','reportService', function($scope,reportService){

	$scope.activar('mReport','','Reporte','todos los Reportes');
	$scope.report = {};
	$scope.reports = {};
	/**** Función date pickter range ****/
	$(function() {
		moment.locale('es-do'); // 'en'
		$('input[name="datefilter"]').daterangepicker({
		  autoUpdateInput: false,
		  locale: {
		      cancelLabel: 'Clear'
		  }
		});

		$('input[name="datefilter"]').on('apply.daterangepicker', function(ev, picker) {
			$(this).val(picker.startDate.format('D MMMM YYYY') + ' - ' + picker.endDate.format('D MMMM YYYY'));
			$scope.report.startDate = picker.startDate.format('YYYY-MM-DD');
			$scope.report.endDate = picker.endDate.format('YYYY-MM-DD');
			reportService.cargarReport($scope.report).then( function(response){
				$scope.reports = response;
				console.log($scope.reports);

				/**** Función jsPDF ****/
				var configPDF = {
				    title: 'Reporte de los pedidos',
				    subject: 'Reporte de pedidos por rango de fechas',
				    author: 'IMBA',
				    keywords: 'imba, pollos, carne',
				    creator: 'Grober Aguilar'
				};
				function header(doc) {
					doc.text(20, 20, 'Hello world!');
				};
				function content(doc) {
					doc.text(20, 30, 'This is client-side Javascript, pumping out a PDF.');
				};
				function footer(doc) {
					doc.text(100, 100, 'Este es mi footer');
				};

				function crearPDF(obj) {
					var doc = new jsPDF();
					doc.setProperties(obj);
					header(doc);
					content(doc);
					footer(doc);
					doc.save('Test.pdf');
				};

				crearPDF(configPDF);

			});

		});

		$('input[name="datefilter"]').on('cancel.daterangepicker', function(ev, picker) {
			$(this).val('');
		});
	});


	






}]);
