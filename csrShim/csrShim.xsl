<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:x="http://www.w3.org/2001/XMLSchema"
                xmlns:d="http://schemas.microsoft.com/sharepoint/dsp"
                version="1.0"
                exclude-result-prefixes="xsl msxsl"
                xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime"
                xmlns:asp="http://schemas.microsoft.com/ASPNET/20"
                xmlns:__designer="http://schemas.microsoft.com/WebParts/v2/DataView/designer"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:SharePoint="Microsoft.SharePoint.WebControls"
                xmlns:ddwrt2="urn:frontpage:internal"
                xmlns:o="urn:schemas-microsoft-com:office:office"
                ddwrt:ghost="show_all">

	<xsl:param name="IsDocLib" select="false()"/>
	<xsl:param name="View" select="' '"/>
	<xsl:param name="JSLink" />

  <xsl:output method="html" indent="no"/>

  <xsl:variable name="Rows" select="/dsQueryResponse/Rows/Row"/>
  <xsl:variable name="dvt_RowCount" select="count($Rows)"/>

  <xsl:template match="/">
    
      <div id="scriptCSRS">
      </div>
      <div id="scriptPagingCSRS">
      </div>
      <xsl:if test="boolean($JSLink)">
      	Orig: <xsl:value-of select="$JSLink"/>
      	<br />
      	<xsl:call-template name="jsLinks">
      		<xsl:with-param name="linkString" select="$JSLink"/>
      	</xsl:call-template>
      </xsl:if>
      
      
      <script type="text/javascript" src="/intranet/hr/documents/csrsample.js"></script>
      
      <script type="text/javascript">
      	(function(){
      		var wpq = 500;
      		while(window['ctx'+wpq]){
      			wpq+=1;
      		}
      		document.getElementById('scriptCSRS').id = 'scriptCSRS'+wpq;
      		document.getElementById('scriptPagingCSRS').id = 'scriptPagingCSRS'+wpq;
      		ctx = new ContextInfo();
      		ctx.wpq = 'CSRS'+wpq;
      		ctx.ctxId = wpq;
      		ctx.csrShim = true;
      		ctx.superfun = 'Chris Kent';
      		ctx.isXslView = true;
			ctx.IsClientRendering = true;
      		ctx.Templates = {};
      		ctx.IsDocLib = <xsl:value-of select="$IsDocLib"/>;
      		ctx.view = "<xsl:value-of select="$View"/>";
      		ctx.ListData = {
      			Row: [
      			<xsl:for-each select="$Rows">
      				{
      				<xsl:for-each select="./@*">
      					<xsl:value-of select="name()"/>:"<xsl:value-of select="."/>"
      					<xsl:if test="position() != last()">,</xsl:if>
      				</xsl:for-each>
      				}<xsl:if test="position() != last()">,</xsl:if>
      			</xsl:for-each>
      			],
      			FirstRow:<xsl:value-of select="$Rows[1]/@ID"/>,
      			LastRow:<xsl:value-of select="$Rows[position()=last()]/@ID"/>
       		};
      		ctx.ListSchema = {
      			IsDocLib: <xsl:choose><xsl:when test="$IsDocLib">"true"</xsl:when><xsl:otherwise>""</xsl:otherwise></xsl:choose>,
      			Field:[
      			<xsl:for-each select="$Rows[1]/@*">
      				{Name:"<xsl:value-of select="name()"/>"}<xsl:if test="position() != last()">,</xsl:if>
  				</xsl:for-each>
      			]
      		}
      		ctx.BasePermissions = {};
      		
      		window['ctx'+wpq] = ctx;
      		
      		SP.SOD.executeFunc('clienttemplates.js','RenderListView',function(){
				window['ctx'+wpq].bInitialRender = true;
				RenderListView(window['ctx'+wpq], 'CSRS'+wpq);
				window['ctx'+wpq].bInitialRender = false;
			});
      	})();
      </script>
  </xsl:template>
  
  <xsl:template name="jsLinks">
  	<xsl:param name="linkString" select="."/>
  	<xsl:param name="splitChar" select="'|'"/>
  	
  	<xsl:if test="string-length($linkString)">
  		<xsl:variable name="linkText" select="substring-before(concat($linkString,$splitChar),$splitChar)"/>
  		<xsl:value-of select="$linkText"/>
  		<br />
  		<xsl:variable name="linkSOD" select="substring($linkText,string-length($linkText) - 2)='(d)'"/>
  		<xsl:variable name="linkURL">
  			<xsl:choose>
  				<xsl:when test="$linkSOD">
  					<xsl:value-of select="substring($linkText,0,string-length($linkText)-2)"/>
  				</xsl:when>
  				<xsl:otherwise>
  					<xsl:value-of select="$linkText"/>
  				</xsl:otherwise>
  			</xsl:choose>
  		</xsl:variable>
  		<xsl:value-of select="$linkURL"/>
  		
  		<br/>
  		<xsl:call-template name="jsLinks">
  			<xsl:with-param name="linkString" select="substring-after($linkString,$splitChar)"/>
  			<xsl:with-param name="splitChar" select="$splitChar"/>
  		</xsl:call-template>
  	</xsl:if>
  </xsl:template>

</xsl:stylesheet>