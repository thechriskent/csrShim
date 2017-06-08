##### Documentation:
- [Parameters](Parameters.md): What you can pass to csrShim
- [Properties](Properties.md): What csrShim gives you back 
- [Extensibility](Extensibility.md): How to extend csrShim

# Properties
csrShim creates a ContextInfo (ctx) object and passes it off to the OOTB rendering engine. Some additional properties may be added during that process (like `Templates`).

csrShim provides the most important properties provided by standard CSR *(however, this is only a subset of standard CSR properties)*  and a few additional ones as well.

# Standard Properties
## wpq
ctx objects are created in the global namespace (matching OOTB SharePoint). They are given a wpq as a unique identifier for each ctx. Standard CSR begins with 1, creating the ctx1 object.

csrShim begins with 500, creating the ctx500 object. However, if multiple csrShim web parts are on the page it will increment as necessary (ctx501, ctx502, etc.). The wpq value is used in the internal render target ids (i.e. `scriptCSRS500` and `scriptPagingCSRS500`) as well. This number is not guaranteed to stay the same between loads since it is determined based on the order the parts were rendered in.

The `ctx.wpq` value is just this number starting with CSRS (i.e. `CSRS500`).

## ctxId
The ctxId is the number portion of the wpq (i.e. 500).

## isXslView
This is always true when using csrShim.

## IsClientRendering
This is always true when using csrShim.

## Templates
These are the template functions as provided by the JS Link files. csrShim does not provide these. These are determined by the OOTB rendering engine as it pares templates up with ctx objects.

## IsDocLib
This is the value of the [IsDocLib parameter](Parameters.md#isdoclib) (defaults to false).

## view
This is the value of the [View parameter](Parameters.md#view) (defaults to blank).

## BaseViewID
This is the value of the [BaseViewID parameter](Parameters.md#baseviewid) (defaults to 1).

## ListTemplateType
This is the value of the [ListTemplateType parameter](Parameters.md#listtemplatetype) (defaults to 100).

# Data Properties
The ctx object supports the `CurrentItem` property (when passed to the Item template) using the data pulled from the `Row` array on the `ListData` object.
## ListData
### `ListData.Row`
This is an array of objects with the item properties. csrShim always returns these properties as strings.
Properties can sometimes contain periods and therefore these properties cannot be accessed using the standard dot notation:
```JavaScript
//Standard Access
var created = ctx.CurrentItem.Created;
	
//Access Properties with Periods
var createdF = ctx.CurrentItem["Created.FriendlyDisplay"];
```

### `ListData.Row[n].firstRow`
When true, the item is the first item returned. This value is typically accessed from the `ctx.CurrentItem` copy. This is a standard CSR value.

### `ListData.Row[n].lastRow`
When true, the item is the last item returned. This value is typically accessed from the `ctx.CurrentItem` copy. This property is unique to csrShim.

### `ListData.FirstRow`
Available when used with Lists (not feeds/XML). This is the item ID of the first item returned.

### `ListData.LastRow`
Available when used with Lists (not feeds/XML). This is the item ID of the last item returned.

## ListSchema
### IsDocLib
This is the value of the [IsDocLib parameter](Parameters.md#isdoclib) (defaults to false). However, this property is returned as a string. When true, the value will be `"true"`. When false, the value will be `""`. This follows the standard CSR conventions.

### Field
This is an array of the internal names of the fields. Field templates can target individual fields based on this information. This is a much more limited subset of information as provided by the standard CSR.

# Unique Properties
## csrShim
This is always true when using csrShim.

This property can be helpful if you need to alter your rendering based on the values being provided by csrShim vs standard CSR.

## ShimType
If provided, this is the value of the [ShimType parameter](Parameters.md#shimtype). Otherwise, this value is automatically determined by csrShim as one of the following:
- List
- CQWP
-	RSS
-	RDF
-	Atom
-	Atom2
-	Unknown

This value can be helpful to determine how properties are accessed in your CSR templates since their format can vary depending on the underlying data type.

## RootData
RootData contains extra properties from the data source as available:

- **List Views** – Extra properties from the dsQueryResponse element which generally includes:
  - BaseViewID (original)
  - RowLimit
  - TemplateType
  - ViewStyleID
- **CQWPs** – No additional information is provided
- **RSS** – Extra properties from the channel element (depends on the feed)
- **RDF** – Extra properties from the channel element (depends on the feed)
- **Atom** – Extra properties from the feed element (depends on the feed)
- **Atom2** – Extra properties from the feed element (depends on the feed)

This property is available to be extended when using custom XML.

# Placeholder Properties
## BasePermissions
This property, provided by standard CSR, is always an empty object in csrShim. This object is required to exist by the rendering engine (although it is not used).
