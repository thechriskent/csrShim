(function(){
	
	var HallOfFame = {
		BaseViewID: 1,
		ListTemplateType: 100,
		OnPreRender: hofPreRender,
		Templates: {
			Header: hofHeader,
			Item: hofItem,
			Footer: hofFooter
		},
		OnPostRender: hofPostRender
	};
	
	function hofPreRender(ctx){
		if(window.console && window.console.log){
			console.log('Begin Hall Of Fame!');
		}
	}
	
	function hofHeader(ctx){
		var styles = '<style type="text/css">' +
					 '.halloffame{' +
					 ' text-align:center;' +
					 ' width:504px;}' +
					 '.halloffame div{'+
					 ' box-sizing:border-box;}' +
					 '.hof-header{' +
					 ' font-size:18px;' +
					 ' font-weight:bold;' +
					 ' border:solid black 4px;' +
					 ' padding:6px;}' +
					 '.hof-items{' +
					 ' border-right:solid black 4px;}' +
					 '.hof-items:after{' +
					 ' clear:both;' +
					 ' content:"";' +
					 ' display:block;}' +
					 '.hof-item{' +
					 ' float:left;' +
					 ' width:125px;' +
					 ' border-left:solid black 4px;' +
					 ' border-bottom:solid black 4px;' +
					 ' height:100px;}' +
					 '.hof-item div{' +
					 ' color:black;' +
					 ' font-weight:bold;' +
					 ' font-size:15px;}' +
					 '.hof-item:hover{' +
					 ' filter:brightness(75%);}' +
					 '.hof-footer{' +
					 ' border:solid black 4px;' +
					 ' border-top:none;' +
					 ' padding:3px;' +
					 ' font-size:10px;}' +
					 '</style>';
		var header = '<div class="halloffame"><div class="hof-header">- Hall of Fame -</div><div class="hof-items">';
		return styles + header;
	}
	
	function hofItem(ctx){
		var sip = ctx.CurrentItem.Person[0].sip;
		var photoUrl = '/_layouts/15/images/PersonPlaceholder.96x96x32.png';
		if(ctx.CurrentItem.Person[0].picture){
			photoUrl = ctx.CurrentItem.Person[0].picture;
		}
	    var photo = '/_layouts/15/userphoto.aspx?accountname=' + sip + '&size=L&url=' + photoUrl;	
	    var userUrl = _spPageContextInfo.siteServerRelativeUrl + '/_layouts/15/userdisp.aspx?ID=' + ctx.CurrentItem.Person[0].id; 		    				
	
		var item = '<a href="' + userUrl + '">' +
				   ' <div class="hof-item" style="background-color:' + ctx.CurrentItem.Color + ';">' +
				   '  <div>' + ctx.CurrentItem.Title + '</div>' +
				   '  <img style="max-height:72px;max-width:72px;" src="' + photo + '"/>' +
				   ' </div>' +
				   '</a>';
		if(ctx.ListData.LastRow == ctx.CurrentItem.ID){
			var closures = '</div></div>';
			return item + closures;
		} else {
			return item;
		}
	}
	
	function hofFooter(ctx){
		var footer = '<div class="halloffame"><div class="hof-footer">Click on a person to learn more</div></div>';
		return footer;
	}
	
	function hofPostRender(ctx){
		if(window.console && window.console.log){
			console.log('Finished Hall Of Fame!');
		}
	}
	
	SP.SOD.executeFunc('clienttemplates.js','SPClientTemplates',function(){
		SPClientTemplates.TemplateManager.RegisterTemplateOverrides(HallOfFame);
	});

})();