(function () {

	var itemCtx = {
		BaseViewID: 55,
		Templates: {
			Header: '<div id="inmateChart" style="width:600px;height:400px;"></div>',
			Item: ""
		},
		OnPostRender: inmatePostRender
	};
	
	function inmatePostRender(ctx){
		google.charts.load('current', {'packages':['bar']});
		google.charts.setOnLoadCallback(function(){
			drawInmateChart(ctx);
		});
	}
	
	function drawInmateChart(ctx){
		var dataArray = [['Year', 'Population']];
		for(var i = ctx.ListData.Row.length - 1; i >= 0; i--){
			dataArray[dataArray.length] = [ctx.ListData.Row[i].fiscal_year, ctx.ListData.Row[i].inmate_population];
		}
		var data = google.visualization.arrayToDataTable(dataArray);
		
		var options = {
			chart: {
				title: "NY City Average Daily Inmate Population"
			}
		};
		
		var chart = new google.charts.Bar(document.getElementById('inmateChart'));
		chart.draw(data,google.charts.Bar.convertOptions(options));
	}
	

	SP.SOD.executeFunc('clienttemplates.js','SPClientTemplates',function(){
		SPClientTemplates.TemplateManager.RegisterTemplateOverrides(itemCtx);
	});
	
})();