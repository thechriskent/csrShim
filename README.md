# csrShim
csrShim fills the gap of many of the limitations presented by **SharePoint** 2013, 2016, & Office 365's Out Of The Box (OOTB) **[Client Side Rendering](Examples/Standard%20CSR.md)** (CSR).

csrShim is an XSLT solution that can be used to:
- Enable JSLink CSR with Content by Query web parts
- Enable JSLink CSR with XMLViewer web parts supporting RSS, RDF, Atom, and Atom2
- Can be easily extended to enable JSLink CSR with XMLViewer web parts and custom XML
- Solve the multiple list views per page issue through simple parameter configuration

## Getting Started
In most cases, you'll only need the csrShim.xsl stylesheet and you'll use it just like any other XSL stylesheet. There are a couple of parameters needed to load up your JSLink files but you should be able to get everything working in less than 5 minutes.

Just download csrShim.xsl, upload it to your SharePoint site *(The Style Library is a great spot)*, reference it in your webpart and specify the JSLink and BaseViewID parameters.

#### Examples
For more details on how to use csrShim, there are several examples provided (along with detailed tutorials):
- [Targeted JSLink for List View Web Parts](/Examples/Multiple%20List%20Views)
- [Client Side Rendering (JSLink) with Content by Query Web Parts](/Examples/CQWP)
- [Client Side Rendering (JSLink) with Feeds (RSS, Atom, Atom2, RDF)](/Examples/XML%20Feeds)
- [Extending csrShim for Custom XML](/Examples/Custom%20XML)
- [List View Client Side Rendering (JSLink) Primer](/Examples/CSR%20Primer) (No csrShim required!)

#### Documentation
You can also consult the documentation for details around the following:
- [Parameters](Examples/Parameters.md): What you can pass to csrShim
- [Properties](Examples/Properties.md): What csrShim gives you back 
- [Extensibility](Examples/Extensibility.md): How to extend csrShim

## Background
csrShim was originally developed to enable CSR with CQWPs but has since been expanded to be used with list views *(to solve the multiple list view per page issue)* and the XMLViewer with support for RSS, RDF, Atom, and Atom2 feeds.

Using XSL, a ContextInfo (ctx) object is generated with the data and some additional information. The ctx is then passed into the OOTB client rendering engine and developers can use CSR (JSLink) templates. The additional information included with the ctx is only a subset of the information provided by the standard CSR implementation, but the information needed for most rendering is available.

csrShim is an XSL stylesheet and is therefore applied to web parts as an XSL solution. Parameters are accepted to provide JS Link resources and to indicate targeting information.

csrShim may be used wherever XSL transforms can be applied. However, csrShim was designed to work specifically with:
- Content by Query Web Parts
- XSLTListView Web Parts
- XMLViewer Web Parts

*csrShim does not work with the RSSViewer web part, but all feed types are supported through the XMLViewer web part.*

## Features
- Lightweight implementation
- Can be used with XML based feeds
- Can be easily extended for use with custom XML feeds
- Provides RootData object
- Provides ctx.CurrentItem.startRow and ctx.CurrentItem.lastRow properties
  - startRow is included in list views in standard CSR, but not lastRow
  - Both are provided even when not used with list items
- Allows BaseViewID and ListTemplateType overrides allowing for web part specific targeting
  - Standard CSR is unable to do this without complicated or hacky workarounds
- Provides ShimType parameter with override
- Utilizes OOTB rendering and can be used alongside standard CSR without issue
- Supports ctx.ListData.FirstRow and ctx.ListData.LastRow for list items (IDs)
- Supports multiple JS Link file syntax
- Supports SOD registration JS Link file syntax

## Limitations
- Does not use the XSLTListView JS Link property (csrShim JSLink is specified through a Parameter Binding)
- Does not support SPURLs (~site, ~sitecollection) in JS Link files
- Limited subset of standard ctx properties
- Properties are always returned as strings
  - Unlike standard CSR where some types (for instance, user) come back as complex objects
  - Often properties with listviews are returned with periods to denote additional elements
