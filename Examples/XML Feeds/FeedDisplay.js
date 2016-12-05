(function () {

	function safeLog(message){
		if(window.console && window.console.log){
			console.log(message);
		}
	}

	var itemCtx = {
		BaseViewID: 50,
		OnPreRender: feedPreRender,
		Templates: {
			Header: feedHeader,
			Item: feedItem,
			Footer: feedFooter
		},
		OnPostRender: feedPostRender
	};
	
	function feedPreRender(ctx){
		safeLog('Feed Starting!');
	}
	
	function feedHeader(ctx){
		var header = '<h1>' + ctx.RootData.title + '</h1>';
		return header + '<ul>';
	}
	
	function feedItem(ctx){
		var item = '<li>' +
				    '<a href="' +ctx.CurrentItem.link + '"><h2><b>' + ctx.CurrentItem.title + '</b></h2></a>' +
				    '<table>' +
				     '<tr>' + 
				      '<td style="padding-right:6px;">' + ctx.CurrentItem.description.substring(0,ctx.CurrentItem.description.indexOf('<br>')) + '</td>' +
				      '<td style="vertical-align:top">' + ctx.CurrentItem.description.substring(ctx.CurrentItem.description.indexOf('<br>') + 4) + '</td>' +
				     '</tr>' +
				    '</table>' +
				   '</li>';
		if(ctx.CurrentItem.lastRow){
			var closures = '</ul>';
			return item + closures;
		} else {
			return item;
		}
	}
	
	function feedFooter(ctx){
		return ctx.RootData.description;
	}
	
	function feedPostRender(ctx){
		safeLog('Feed All Done!');
	}

	SP.SOD.executeFunc('clienttemplates.js','SPClientTemplates',function(){
		SPClientTemplates.TemplateManager.RegisterTemplateOverrides(itemCtx);
	});
	
})();