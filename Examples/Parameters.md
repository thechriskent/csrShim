#Parameters
csrShim takes advantage of several XSLT Parameters. CQWPs and XSLTListView web parts can use standard [ParameterBinding](https://msdn.microsoft.com/en-us/library/office/ff806155(v=office.14).aspx) elements to specify the values. XMLViewer does not support XSLT Parameters directly, so you must use an XSL Wrapper with `xsl:variable` elements.

Although there are several listed, generally only **BaseViewID** and **JSLink** will be used except in advanced scenarios.

##BaseViewID
######Type: Number, Default: 1
Used in conjunction with the ListTemplateType to target your templates. Unlike, ListTemplateType, you should nearly always specify this parameter.

The BaseViewID parameter will be used with the ctx object regardless of the actual BaseViewID. This is a very powerful feature that allows you to tie specific web parts to your templates (even if the same list/view is used on the same page in a separate web part)!

####Example: CQWP or XSLTListView ParameterBinding
```XML
<ParameterBindings>
    <ParameterBinding Name="BaseViewID" Default="40"/>
</ParameterBindings>
```

####Example: XSL Wrapper
```XML
<xsl:variable name="BaseViewID" select="40"/>
```
&nbsp;

##ListTemplateType
######Type: Number, Default: 100
Used in conjunction with the BaseViewID to target your templates. The ListTemplateType is not necessary to correctly target your templates unless your templates also specify it.

####Example: CQWP or XSLTListView ParameterBinding
```XML
<ParameterBindings>
    <ParameterBinding Name="ListTemplateType" Default="200"/>
</ParameterBindings>
```

####Example: XSL Wrapper
```XML
<xsl:variable name="ListTemplateType" select="200"/>
```
&nbsp;

##JSLink
######Type: String
Used to specify your JavaScript file(s) containing your CSR templates. In general, this will be a single URL (relative or absolute) to your JavaScript file. This will be used to generate a `<script>` tag on the page with its src attribute set to this link.

####Example: CQWP or XSLTListView ParameterBinding
```XML
<ParameterBindings>
    <ParameterBinding Name="JSLink" Default="/Style Library/csrShim/jsLinkTest.js"/>
</ParameterBindings>
```

####Example: XSL Wrapper
```XML
<xsl:variable name="JSLink" select="'/Style Library/csrShim/jsLinkTest.js'"/>
```

###Multiple JavaScript Files
csrShim follows the standard CSR convention of allowing you to specify multiple files separated by a pipe `|`. This will generate a `<script>` tag for each file you specify in the order entered. This can be very helpful to include dependencies like jQuery or other plugins.

####Example: CQWP or XSLTListView ParameterBinding
```XML
<ParameterBindings>
    <ParameterBinding Name="JSLink" Default=" https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js|/Style Library/csrShim/jsLinkTest.js"/>
</ParameterBindings>
```

####Example: XSL Wrapper
```XML
<xsl:variable name="JSLink" select="' https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js|/Style Library/csrShim/jsLinkTest.js'"/>
```

###SOD Registration
CsrShim follows the standard CSR convention of allowing you to request Script On Demand (SOD) registration for the specified file by including `(d)` after your file. This can be combined with 1 or more standard loading scripts as well.

####Example: CQWP or XSLTListView ParameterBinding
```XML
<ParameterBindings>
    <ParameterBinding Name="JSLink" Default="/Style Library/someScript.js(d)|/Style Library/csrShim/jsLinkTest.js"/>
</ParameterBindings>
```

####Example: XSL Wrapper
```XML
<xsl:variable name="JSLink" select="'/Style Library/someScript.js(d)|/Style Library/csrShim/jsLinkTest.js'"/>
```

###SPURL Support
csrShim does not currently support the use of SPURLs (~site, ~sitecollection, etc.).

&nbsp;

##ShimType
######Type: String, Override
ShimType is a custom property attached to the ctx object. csrShim attempts to resolve this property automatically. However, you can specify it as a parameter and it will always use your value.

It is rare that you will use this parameter and it is generally recommended that you don’t. One use case might be to change the behavior of a JSLink file that is reliant upon that property.

####Example: CQWP or XSLTListView ParameterBinding
```XML
<ParameterBindings>
    <ParameterBinding Name="ShimType" Default="Atom"/>
</ParameterBindings>
```

####Example: XSL Wrapper
```XML
<xsl:variable name="ShimType" select="'Atom'"/>
```
&nbsp;

##IsDocLib
######Type: Boolean, Default: false
IsDocLib is used by the native rendering engine when your list is a document library. Set this to true when using a document library (since csrShim does not automatically detect this). In all other cases, leave it unset.

####Example: CQWP or XSLTListView ParameterBinding
```XML
<ParameterBindings>
    <ParameterBinding Name="IsDocLib" Default="true"/>
</ParameterBindings>
```

####Example: XSL Wrapper
```XML
<xsl:variable name="IsDocLib" select="true()"/>
```
&nbsp;

##View
######Type: String
This value will be passed directly to the ctx object and is expected to be a view GUID. If your CSR needs it to be a certain value on the ctx object you should pass this parameter, otherwise, leave it unset.

####Example: CQWP or XSLTListView ParameterBinding
```XML
<ParameterBindings>
    <ParameterBinding Name="View" Default="{90073DED-79C4-4E3D-B299-2D56FC731AF4}"/>
</ParameterBindings>
```

####Example: XSL Wrapper
```XML
<xsl:variable name="View" select="'{90073DED-79C4-4E3D-B299-2D56FC731AF4}'"/>
```
&nbsp;

##RawDump
######Type: Boolean, Default: false
This is for debugging the output of csrShim and should not be used outside of development. When true, the raw XML received will be written directly to the page. No other parameters will be used and no CSR rendering will be performed.

This can be helpful in situations where you aren’t even using csrShim but just want to quickly see the raw data.

####Example: CQWP or XSLTListView ParameterBinding
```XML
<ParameterBindings>
    <ParameterBinding Name="RawDump" Default="true"/>
</ParameterBindings>
```

####Example: XSL Wrapper
```XML
<xsl:variable name="RawDump" select="true()"/>
```
