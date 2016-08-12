<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:x="http://www.w3.org/2001/XMLSchema"
                xmlns:d="http://schemas.microsoft.com/sharepoint/dsp"
                version="1.0"
                exclude-result-prefixes="xsl msxsl x d ddwrt asp SharePoint ddwrt2 o __designer"
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
	
	<xsl:param name="BaseViewID" select="1"/>
	<xsl:param name="ListTemplateType" select="100"/>
	<xsl:param name="JSLink" />
	<xsl:param name="FieldMapping" select="''"/>

  <xsl:output method="html" indent="no"/>

  <xsl:variable name="Rows" select="/dsQueryResponse/Rows/Row"/>
  <xsl:variable name="dvt_RowCount" select="count($Rows)"/>

  <xsl:template match="/">
    

	  <xsl:call-template name="jsLinks">
      	<xsl:with-param name="linkString" select="$JSLink"/>
      </xsl:call-template>
      	
      <div id="scriptCSRS">
      </div>
      <div id="scriptPagingCSRS">
      </div>
      <xmp><xsl:copy-of select="/dsQueryResponse"/></xmp>
      <xsl:value-of select="$FieldMapping"/>
            
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
      		ctx.BaseViewID = <xsl:value-of select="$BaseViewID"/>;
      		ctx.ListTemplateType = <xsl:value-of select="$ListTemplateType"/>;
      		ctx.ListData = {
      			Row: [
      			<xsl:for-each select="$Rows">
      				{
      				<xsl:for-each select="./@*">
      					<xsl:value-of select="name()"/>:<xsl:call-template name="buildJSValue"><xsl:with-param name="fieldName" select="name()"/><xsl:with-param name="rawValue" select="."/></xsl:call-template>
      					<xsl:if test="position() != last()">,</xsl:if>
      				</xsl:for-each>
      				}<xsl:if test="position() != last()">,</xsl:if>
      			</xsl:for-each>
      			]<xsl:if test="dvt_RowCount &gt; 0">,
      			FirstRow:<xsl:value-of select="$Rows[1]/@ID"/>,
      			LastRow:<xsl:value-of select="$Rows[position()=last()]/@ID"/></xsl:if>
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
  		
  		<xsl:choose>
  			<xsl:when test="$linkSOD">
  				<script type="text/javascript">
  					RegisterSod("<xsl:value-of select="$linkURL"/>","<xsl:value-of select="$linkURL"/>");
  				</script>
  			</xsl:when>
  			<xsl:otherwise>
  				<script type="text/javascript" src="{$linkURL}"></script>
  			</xsl:otherwise>
  		</xsl:choose>
  		
  		<xsl:call-template name="jsLinks">
  			<xsl:with-param name="linkString" select="substring-after($linkString,$splitChar)"/>
  			<xsl:with-param name="splitChar" select="$splitChar"/>
  		</xsl:call-template>
  	</xsl:if>
  </xsl:template>
  
  <xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:value-of select="$by" />
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="by" select="$by" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="buildJSValue">
  	<xsl:param name="rawValue" select="."/>
  	<xsl:param name="fieldName"/>
  	<xsl:param name="mapping" select="$FieldMapping"/>
  	
  	<xsl:variable name="valueType">
  		<xsl:choose>
  			<xsl:when test="contains($mapping,concat($fieldName,','))">
  				<xsl:variable name="rawType" select="substring-before(substring-after($mapping,concat($fieldName,',')),';')"/>
  				<xsl:choose>
  					<xsl:when test="$rawType='Number'">
  						<xsl:value-of select="$rawType"/>
  					</xsl:when>
  					<xsl:when test="$rawType='Currency'">
  						<xsl:value-of select="'Number'"/>
  					</xsl:when>
  					<xsl:when test="$rawType='Integer'">
  						<xsl:value-of select="'Number'"/>
  					</xsl:when>
  					<xsl:when test="$rawType='Boolean'">
  						<xsl:value-of select="$rawType"/>
  					</xsl:when>
  					<xsl:when test="$rawType='DateTime'">
  						<xsl:value-of select="$rawType"/>
  					</xsl:when>
  					<xsl:when test="$rawType='Lookup'">
  						<xsl:value-of select="$rawType"/>
  					</xsl:when>
  					<xsl:when test="$rawType='URL'">
  						<xsl:value-of select="$rawType"/>
  					</xsl:when>
  					<xsl:when test="$rawType='Counter'">
  						<xsl:value-of select="'Number'"/>
  					</xsl:when>
  					<xsl:when test="$rawType='User'">
  						<xsl:value-of select="$rawType"/>
  					</xsl:when>
  					<xsl:otherwise>
  						<xsl:value-of select="'Text'"/>
  					</xsl:otherwise>
  				</xsl:choose>
  			</xsl:when>
  			<xsl:otherwise>
  				<xsl:value-of select="'Text'"/>
  			</xsl:otherwise>
  		</xsl:choose>
  	</xsl:variable>
  	
  	<xsl:choose>
  		<xsl:when test="$valueType='Boolean'">
  			<xsl:call-template name="jsValueBoolean">
  				<xsl:with-param name="rawValue" select="$rawValue"/>
  			</xsl:call-template>
  		</xsl:when>
  		<xsl:when test="$valueType='URL'">
  			<xsl:call-template name="jsValueURL">
  				<xsl:with-param name="rawValue" select="$rawValue"/>
  			</xsl:call-template>
  		</xsl:when>
  		<xsl:when test="$valueType='Number'">
  			<xsl:call-template name="jsValueNumber">
  				<xsl:with-param name="rawValue" select="$rawValue"/>
  			</xsl:call-template>
  		</xsl:when>
  		<xsl:otherwise>
  			<xsl:call-template name="jsValueText">
  				<xsl:with-param name="rawValue" select="$rawValue"/>
  			</xsl:call-template>
  		</xsl:otherwise>
  	</xsl:choose>
  </xsl:template>
  
  <xsl:template name="jsValueText">
  	<xsl:param name="rawValue" select="."/>
  	"<xsl:call-template name="string-replace-all"><xsl:with-param name="text" select="$rawValue"/><xsl:with-param name="replace" select="'&quot;'"/><xsl:with-param name="by" select="'\&quot;'"/></xsl:call-template>"
  </xsl:template>
  
  <xsl:template name="jsValueBoolean">
  	<xsl:param name="rawValue" select="."/>
	<xsl:choose>
		<xsl:when test="$rawValue='True'">
			<xsl:value-of select="'true'"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="'false'"/>
		</xsl:otherwise>
	</xsl:choose>
  </xsl:template>
  
  <xsl:template name="jsValueURL">
  	<xsl:param name="rawValue" select="."/>
  	{link:
  	<xsl:call-template name="jsValueText">
  		<xsl:with-param name="rawValue" select="substring-before($rawValue,', ')"/>
  	</xsl:call-template>,text:
	<xsl:choose>
		<xsl:when test="contains($rawValue,', ')">
			<xsl:call-template name="jsValueText">
		  		<xsl:with-param name="rawValue" select="substring-after($rawValue,', ')"/>
		  	</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="jsValueText">
		  		<xsl:with-param name="rawValue" select="$rawValue"/>
		  	</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>}
  </xsl:template>
  
  <xsl:template name="jsValueNumber">
  	<xsl:param name="rawValue" select="."/>
  	<xsl:value-of select="$rawValue"/>
  </xsl:template>


  

</xsl:stylesheet>