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
				
	<xsl:import href="/Style Library/csrShim/csrShim.xsl"/>
	<xsl:variable name="BaseViewID" select="55"/>
	<xsl:variable name="JSLink" select="'https://www.gstatic.com/charts/loader.js|/intranet/Style Library/csrShim/inmates.js'"/>
	
	<xsl:template match="response">
		<xsl:call-template name="routeToShim">
			<xsl:with-param name="dsType" select="'NY'"/>
			<xsl:with-param name="Rows" select="/response/row/row"/>
			<xsl:with-param name="Rows_UseElements" select="true()"/>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>