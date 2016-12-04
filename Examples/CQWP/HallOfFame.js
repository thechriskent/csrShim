(function(){
	
	var HallOfFame = {
		BaseViewID: 40,
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
	    var photo = '/_layouts/15/userphoto.aspx?accountname=' + sip + '&size=L&url=' + photoUrl;	
	    var userUrl = "/";
	    
	    var itemId = 'hofItem' + ctx.CurrentItem.ID;
	
		var item = '<a id="' + itemId + '" href="' + userUrl + '">' +
				   ' <div class="hof-item" style="background-color:' + ctx.CurrentItem.Color + ';">' +
				   '  <div>' + ctx.CurrentItem.Title + '</div>' +
				   '  <img style="max-height:72px;max-width:72px;visibility:hidden;" src="' + photo + '"/>' +
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
		SP.SOD.executeFunc('sp.js', 'SP.ClientContext', function(){
			SP.SOD.executeFunc('userprofile','PeopleManager', function(){
				var jsCtx = SP.ClientContext.get_current();
				var peopleManager = new SP.UserProfiles.PeopleManager(jsCtx);
				
				this.userProps = [];
				for(var i=0;i<ctx.ListData.Row.length;i++){
					var username = ctx.ListData.Row[i].Person;
					var username = username.substring(username.indexOf('|')+1);
					this.userProps[i] = {
						username:username,
						properties: peopleManager.getPropertiesFor(username),
						id: ctx.ListData.Row[i].ID
					};
					jsCtx.load(this.userProps[i].properties,'PictureUrl','UserUrl');
				}
				
				jsCtx.executeQueryAsync(
					Function.createDelegate(this,applyPictures),
					function(s,a){
						if(window.console && window.console.log){
							console.log('Unable to get profile pictures!');
							console.log(a.get_message());
						}
					}
				);
			});
		});
		
		if(window.console && window.console.log){
			console.log('Finished Hall Of Fame!');
		}
	}
	
	function applyPictures(){
		for(var i=0; i<this.userProps.length; i++){
			var userUrl = this.userProps[i].properties.get_userUrl();
			var pictureUrl = this.userProps[i].properties.get_pictureUrl();
			var accountName = encodeURIComponent(this.userProps[i].username);
			var itemElem = document.getElementById('hofItem' + this.userProps[i].id);
			itemElem.href = userUrl;
			var itemImg = itemElem.getElementsByTagName('img')[0];
			if(pictureUrl){
				itemImg.src = '/_layouts/15/userphoto.aspx?accountname=' + accountName + '&size=L&url=' + pictureUrl;
			}
			itemImg.style.visibility = 'visible';
		}
	}
	
	SP.SOD.executeFunc('clienttemplates.js','SPClientTemplates',function(){
		SPClientTemplates.TemplateManager.RegisterTemplateOverrides(HallOfFame);
	});

})();