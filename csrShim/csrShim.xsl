﻿<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:x="http://www.w3.org/2001/XMLSchema"
				xmlns:d="http://schemas.microsoft.com/sharepoint/dsp"
				version="1.0"
				exclude-result-prefixes="xsl msxsl x d ddwrt asp SharePoint ddwrt2 o __designer rss1 atom atom2 rdf dc itunes"
				xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime"
				xmlns:asp="http://schemas.microsoft.com/ASPNET/20"
				xmlns:__designer="http://schemas.microsoft.com/WebParts/v2/DataView/designer"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:msxsl="urn:schemas-microsoft-com:xslt"
				xmlns:SharePoint="Microsoft.SharePoint.WebControls"
				xmlns:ddwrt2="urn:frontpage:internal"
				xmlns:o="urn:schemas-microsoft-com:office:office"
				xmlns:rss1="http://purl.org/rss/1.0/"
				xmlns:atom="http://www.w3.org/2005/Atom"
				xmlns:atom2="http://purl.org/atom/ns#"
				xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
				xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
				xmlns:dc="http://purl.org/dc/elements/1.1/"
				ddwrt:ghost="show_all">

	<xsl:param name="BaseViewID" select="1"/>
	<xsl:param name="ListTemplateType" select="100"/>
	<xsl:param name="JSLink"/>
	<xsl:param name="ShimType" select="' '"/>
	<xsl:param name="UseTableLayoutFixed" select="true()"/>
	
	<xsl:param name="RawDump" select="false()"/>

	<xsl:param name="IsDocLib" select="false()"/>
	<xsl:param name="View" select="' '"/>

	<xsl:output method="html" indent="no"/>

	
	<xsl:template match="dsQueryResponse[@ViewStyleID]">
		<xsl:call-template name="routeToShim">
			<xsl:with-param name="dsType" select="'List'"/>
			<xsl:with-param name="Rows" select="/dsQueryResponse/Rows/Row"/>
			<xsl:with-param name="Root" select="/dsQueryResponse"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="dsQueryResponse[not(@ViewStyleID)]">
		<xsl:call-template name="routeToShim">
			<xsl:with-param name="dsType" select="'CQWP'"/>
			<xsl:with-param name="Rows" select="/dsQueryResponse/Rows/Row"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="rss">
		<xsl:call-template name="routeToShim">
			<xsl:with-param name="dsType" select="'RSS'"/>
			<xsl:with-param name="Rows" select="/rss/channel/item"/>
			<xsl:with-param name="Rows_UseElements" select="true()"/>
			<xsl:with-param name="Root" select="/rss/channel"/>
			<xsl:with-param name="Root_UseElements" select="true()"/>
			<xsl:with-param name="Root_Exclude" select="'item'"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="rdf:RDF">
		<xsl:call-template name="routeToShim">
			<xsl:with-param name="dsType" select="'RDF'"/>
			<xsl:with-param name="Rows" select="rss1:item"/>
			<xsl:with-param name="Rows_UseElements" select="true()"/>
			<xsl:with-param name="Root" select="rss1:channel"/>
			<xsl:with-param name="Root_UseElements" select="true()"/>
			<xsl:with-param name="Root_Exclude" select="'item'"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="atom:feed">
		<xsl:call-template name="routeToShim">
			<xsl:with-param name="dsType" select="'Atom'"/>
			<xsl:with-param name="Rows" select="/atom:feed/atom:entry"/>
			<xsl:with-param name="Rows_UseElements" select="true()"/>
			<xsl:with-param name="Root" select="/atom:feed"/>
			<xsl:with-param name="Root_UseElements" select="true()"/>
			<xsl:with-param name="Root_Exclude" select="'entry'"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="atom2:feed">
		<xsl:call-template name="routeToShim">
			<xsl:with-param name="dsType" select="'Atom2'"/>
			<xsl:with-param name="Rows" select="/atom2:feed/atom2:entry"/>
			<xsl:with-param name="Rows_UseElements" select="true()"/>
			<xsl:with-param name="Root" select="/atom2:feed"/>
			<xsl:with-param name="Root_UseElements" select="true()"/>
			<xsl:with-param name="Root_Exclude" select="'entry'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="*">
		<xsl:call-template name="routeToShim">
			<xsl:with-param name="Rows" select="*"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="routeToShim">
		<xsl:param name="dsType" select="'Unknown'"/>
		<xsl:param name="Rows"/>
		<xsl:param name="Rows_UseElements"/>
		<xsl:param name="Root"/>
		<xsl:param name="Root_UseElements"/>
		<xsl:param name="Root_Exclude"/>
		
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
					<xsl:with-param name="Rows" select="$Rows"/>
					<xsl:with-param name="Rows_UseElements" select="$Rows_UseElements"/>
					<xsl:with-param name="Root" select="$Root"/>
					<xsl:with-param name="Root_UseElements" select="$Root_UseElements"/>
					<xsl:with-param name="Root_Exclude" select="$Root_Exclude"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	
	<xsl:template name="csrShim">
		<xsl:param name="sType"/>
		<xsl:param name="Rows"/>
		<xsl:param name="Rows_UseElements"/>
		<xsl:param name="Root"/>
		<xsl:param name="Root_UseElements"/>
		<xsl:param name="Root_Exclude"/>

		<xsl:call-template name="jsLinks">
			<xsl:with-param name="linkString" select="$JSLink"/>
		</xsl:call-template>
		
		<xsl:call-template name="placeholders"/>

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
				ctx.BasePermissions = {};
				ctx.IsDocLib = <xsl:value-of select="$IsDocLib"/>;
				ctx.view = "<xsl:value-of select="$View"/>";
				ctx.BaseViewID = <xsl:value-of select="$BaseViewID"/>;
				ctx.ListTemplateType = <xsl:value-of select="$ListTemplateType"/>;
				<xsl:call-template name="listData">
					<xsl:with-param name="Rows" select="$Rows"/>
					<xsl:with-param name="Rows_UseElements" select="$Rows_UseElements"/>
				</xsl:call-template>
				<xsl:call-template name="listSchema">
					<xsl:with-param name="Rows" select="$Rows"/>
					<xsl:with-param name="Rows_UseElements" select="$Rows_UseElements"/>
				</xsl:call-template>
				<xsl:call-template name="rootData">
					<xsl:with-param name="Root" select="$Root"/>
					<xsl:with-param name="Root_UseElements" select="$Root_UseElements"/>
					<xsl:with-param name="Root_Exclude" select="$Root_Exclude"/>
				</xsl:call-template>

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
	
	<xsl:template name="placeholders">
		<table width="100%" cellspacing="0" cellpadding="0" border="0">
		<xsl:if test="$UseTableLayoutFixed">
			<xsl:attribute name="style"><xsl:text>table-layout:fixed;</xsl:text></xsl:attribute>
		</xsl:if>
			<tbody>
				<tr>
					<td id="scriptCSRS"></td>
				</tr>
			</tbody>
		</table>
		<div id="scriptPagingCSRS">
		</div>
	</xsl:template>
	
	<xsl:template name="rootData">
		<xsl:param name="Root"/>
		<xsl:param name="Root_UseElements" select="false()"/>
		<xsl:param name="Root_Exclude" select="''"/>
				ctx.RootData = {
				<xsl:if test="$Root">
					<xsl:choose>
						<xsl:when test="$Root_UseElements">
							<xsl:for-each select="$Root/*[name()!=$Root_Exclude]">
								"<xsl:value-of select="name()"/>":<xsl:call-template name="jsValueText"><xsl:with-param name="rawValue" select="."/></xsl:call-template>
								<xsl:if test="position() != last()">,</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="$Root/@*">
								"<xsl:value-of select="name()"/>":<xsl:call-template name="jsValueText"><xsl:with-param name="rawValue" select="."/></xsl:call-template>
								<xsl:if test="position() != last()">,</xsl:if>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				};
	</xsl:template>
	
	<xsl:template name="listData">
		<xsl:param name="Rows" select="."/>
		<xsl:param name="Rows_UseElements" select="false()"/>
		<xsl:variable name="RowCount" select="count($Rows)"/>
				ctx.ListData = {
					Row: [
					<xsl:choose>
						<xsl:when test="$Rows_UseElements">
							<xsl:for-each select="$Rows">
								{<xsl:if test="position() = 1">firstRow:true,</xsl:if><xsl:if test="position() = last()">lastRow:true,</xsl:if>
								<xsl:for-each select="./*">
									"<xsl:value-of select="name()"/>":<xsl:call-template name="jsValueText"><xsl:with-param name="rawValue" select="."/></xsl:call-template>
									<xsl:if test="position() != last()">,</xsl:if>
								</xsl:for-each>
								}<xsl:if test="position() != last()">,</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="$Rows">
								{<xsl:if test="position() = 1">firstRow:true,</xsl:if><xsl:if test="position() = last()">lastRow:true,</xsl:if>
								<xsl:for-each select="./@*">
									"<xsl:value-of select="name()"/>":<xsl:call-template name="jsValueText"><xsl:with-param name="rawValue" select="."/></xsl:call-template>
									<xsl:if test="position() != last()">,</xsl:if>
								</xsl:for-each>
								}<xsl:if test="position() != last()">,</xsl:if>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					]<xsl:if test="($RowCount &gt; 0) and ($Rows[1]/@ID)">,
					FirstRow:<xsl:value-of select="$Rows[1]/@ID"/>,
					LastRow:<xsl:value-of select="$Rows[position()=last()]/@ID"/></xsl:if>
				};
	</xsl:template>

	<xsl:template name="listSchema">
		<xsl:param name="Rows" select="."/>
		<xsl:param name="Rows_UseElements" select="false()"/>
				ctx.ListSchema = {
					IsDocLib: <xsl:choose><xsl:when test="$IsDocLib">"true"</xsl:when><xsl:otherwise>""</xsl:otherwise></xsl:choose>,
					Field:[
					<xsl:choose>
						<xsl:when test="$Rows_UseElements">
							<xsl:for-each select="$Rows[1]/*">
								{Name:"<xsl:value-of select="name()"/>"}<xsl:if test="position() != last()">,</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="$Rows[1]/@*">
								{Name:"<xsl:value-of select="name()"/>"}<xsl:if test="position() != last()">,</xsl:if>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					]
				};
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
		"<xsl:call-template name="string-replace-all"><xsl:with-param name="text"><xsl:call-template name="string-replace-all"><xsl:with-param name="text"><xsl:call-template name="string-replace-all"><xsl:with-param name="text"><xsl:call-template name="string-replace-all"><xsl:with-param name="text" select="$rawValue"/><xsl:with-param name="replace" select="'&quot;'"/><xsl:with-param name="by" select="'\&quot;'"/></xsl:call-template></xsl:with-param><xsl:with-param name="replace" select="'\'"/><xsl:with-param name="by" select="'\\'"/></xsl:call-template></xsl:with-param><xsl:with-param name="replace" select="'\\&quot;'"/><xsl:with-param name="by" select="'\&quot;'"/></xsl:call-template></xsl:with-param><xsl:with-param name="replace" select="'&#10;'"/><xsl:with-param name="by" select="'\&#10;'"/></xsl:call-template>"
	</xsl:template>

</xsl:stylesheet>