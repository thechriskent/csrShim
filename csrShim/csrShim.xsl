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

	<xsl:param name="BaseViewID" select="1"/>
	<xsl:param name="ListTemplateType" select="100"/>
	<xsl:param name="JSLink"/>
	<xsl:param name="ShimType" select="' '"/>
	
	<xsl:param name="RawDump" select="false()"/>

	<xsl:param name="IsDocLib" select="false()"/>
	<xsl:param name="View" select="' '"/>

	<xsl:output method="html" indent="no"/>

	
	<xsl:template match="dsQueryResponse[@ViewStyleID]">
		<xsl:call-template name="routeToShim">
			<xsl:with-param name="dsType" select="'List'"/>
			<xsl:with-param name="Rows" select="Rows/Row"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="dsQueryResponse[not(@ViewStyleID)]">
		<xsl:call-template name="routeToShim">
			<xsl:with-param name="dsType" select="'CQWP'"/>
			<xsl:with-param name="Rows" select="Rows/Row"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="rss">
		<xsl:call-template name="routeToShim">
			<xsl:with-param name="dsType" select="'RSS'"/>
			<xsl:with-param name="Rows" select="channel/item"/>
		</xsl:call-template>
	</xsl:template>
	

	<xsl:template match="*">
		<xsl:call-template name="routeToShim"/>
	</xsl:template>
	
	<xsl:template name="routeToShim">
		<xsl:param name="dsType" select="'Unknown'"/>
		<xsl:param name="Rows"/>
		
		<xsl:variable name="sType">
			<xsl:choose>
				<xsl:when test="$ShimType != ' '">
					<xsl:value-of select="$ShimType"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$dsType"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$RawDump">
				<xmp><xsl:copy-of select="/"/></xmp>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="csrShim">
					<xsl:with-param name="sType" select="$sType"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	
	<xsl:template name="csrShim">
		<xsl:param name="sType"/>

		<xsl:call-template name="jsLinks">
			<xsl:with-param name="linkString" select="$JSLink"/>
		</xsl:call-template>

		<div id="scriptCSRS">
		</div>
		<div id="scriptPagingCSRS">
		</div>

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
				ctx.ShimType = "<xsl:value-of select="$sType"/>";
				ctx.isXslView = true;
				ctx.IsClientRendering = true;
				ctx.Templates = {};
				ctx.IsDocLib = <xsl:value-of select="$IsDocLib"/>;
				ctx.view = "<xsl:value-of select="$View"/>";
				ctx.BaseViewID = <xsl:value-of select="$BaseViewID"/>;
				ctx.ListTemplateType = <xsl:value-of select="$ListTemplateType"/>;
				<xsl:call-template name="listData"/>
				<xsl:call-template name="listSchema"/>
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
	
	<xsl:template name="listData">
		<xsl:param name="Rows" select="/dsQueryResponse/Rows/Row"/>
		<xsl:variable name="RowCount" select="count($Rows)"/>
				ctx.ListData = {
					Row: [
					<xsl:for-each select="$Rows">
						{
						<xsl:for-each select="./@*">
							"<xsl:value-of select="name()"/>":<xsl:call-template name="jsValueText"><xsl:with-param name="rawValue" select="."/></xsl:call-template>
							<xsl:if test="position() != last()">,</xsl:if>
						</xsl:for-each>
						}<xsl:if test="position() != last()">,</xsl:if>
					</xsl:for-each>
					]<xsl:if test="$RowCount &gt; 0">,
					FirstRow:<xsl:value-of select="$Rows[1]/@ID"/>,
					LastRow:<xsl:value-of select="$Rows[position()=last()]/@ID"/></xsl:if>
				};
	</xsl:template>

	<xsl:template name="listSchema">
		<xsl:param name="Rows" select="/dsQueryResponse/Rows/Row"/>
				ctx.ListSchema = {
					IsDocLib: <xsl:choose><xsl:when test="$IsDocLib">"true"</xsl:when><xsl:otherwise>""</xsl:otherwise></xsl:choose>,
					Field:[
					<xsl:for-each select="$Rows[1]/@*">
						{Name:"<xsl:value-of select="name()"/>"}<xsl:if test="position() != last()">,</xsl:if>
					</xsl:for-each>
					]
				}
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

	<xsl:template name="jsValueText">
		<xsl:param name="rawValue" select="."/>
		"<xsl:call-template name="string-replace-all"><xsl:with-param name="text"><xsl:call-template name="string-replace-all"><xsl:with-param name="text" select="$rawValue"/><xsl:with-param name="replace" select="'&quot;'"/><xsl:with-param name="by" select="'\&quot;'"/></xsl:call-template></xsl:with-param><xsl:with-param name="replace" select="'&#10;'"/><xsl:with-param name="by" select="'\&#10;'"/></xsl:call-template>"
	</xsl:template>

</xsl:stylesheet>