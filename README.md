# csrShim
csrShim fills the gap of many of the limitations presented by **SharePoint** 2013, 2016, & Office 365's Out Of The Box (OOTB) **Client Side Rendering** (CSR).

csrShim is an XSLT solution that can be used to:
- Enable JSLink CSR with Content by Query web parts
- Enable JSLink CSR with XMLViewer web parts supporting RSS, RDF, Atom, and Atom2
- Can be easily extended to enable JSLink CSR with XMLViewer web parts and custom XML
- Solve the multiple list views per page issue through simple parameter configuration

##Getting Started
In most cases, you'll only need the csrShim.xsl stylesheet and you'll use it just like any other XSL stylesheet. There are a couple of parameters needed to load up your JSLink files but you should be able to get everything working in less than 5 minutes.

Just download csrShim.xsl, upload it to your SharePoint site *(The Style Library is a great spot)*, reference it in your webpart and specify the JSLink and BaseViewID parameters.

For more details on how to use csrShim, there are several **examples** provided (along with detailed tutorials):
- [Targeted JSLink for List View Web Parts](/Examples/Multiple List Views/README.md)
- [Client Side Rendering (JSLink) with Content by Query Web Parts](/Examples/CQWP/README.md)
- [Client Side Rendering (JSLink) with Feeds (RSS, Atom, Atom2, RDF)](/Examples/XML Feeds/README.md)
- [Extending csrShim for Custom XML](/Examples/Custom XML/README.md)

You can also consult the **documentation** for details around the following:
- [Parameters](Examples/Parameters.md): What you can pass to csrShim
- [Properties](Examples/Properties.md): What csrShim gives you back 
- [Extensibility](Examples/Extensibility.md): How to extend csrShim

For those new to CSR (or who'd like to brush up), there is a series of posts to serve as an introduction to using CSR (JSLink) with List View Web Parts including a detailed example of using the standard templates in a JSLink JavaScript file:

1. [An Introduction to Client Side Rendering](https://thechriskent.com/2016/04/11/csr1-an-introduction-to-client-side-rendering/)
2. [Benefits of Client Side Rendering](https://thechriskent.com/2016/05/16/csr2-benefits-of-client-side-rendering/)
3. [Getting Started](https://thechriskent.com/2016/06/13/csr3-getting-started-list-view-csr/)
4. [List View Extension Points](https://thechriskent.com/2016/07/11/csr4-list-view-extension-points-csr/)
5. [Client Side Rendering Best Practices](https://thechriskent.com/2016/08/15/csr5-client-side-rendering-best-practices/)

##Background
csrShim was originally developed to enable CSR with CQWPs but has since been expanded to be used with list views *(to solve the multiple list view per page issue)* and the XMLViewer with support for RSS, RDF, Atom, and Atom2 feeds.

Using XSL, a ContextInfo (ctx) object is generated with the data and some additional information. The ctx is then passed into the OOTB client rendering engine and developers can use CSR (JSLink) templates. The additional information included with the ctx is only a subset of the information provided by the standard CSR implementation, but the information needed for most rendering is available.

csrShim is an XSL stylesheet and is therefore applied to web parts as an XSL solution. Parameters are accepted to provide JS Link resources and to indicate targeting information.

csrShim may be used wherever XSL transforms can be applied. However, csrShim was designed to work specifically with:
- Content by Query Web Parts
- XSLTListView Web Parts
- XMLViewer Web Parts

*csrShim does not work with the RSSViewer web part, but all feed types are supported through the XMLViewer web part.*

##Features
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

##Limitations
- Does not use the XSLTListView JS Link property (csrShim JSLink is specified through a Parameter Binding)
- Does not support SPURLs (~site, ~sitecollection) in JS Link files
- Limited subset of standard ctx properties
- Properties are always returned as strings
  - Unlike standard CSR where some types (for instance, user) come back as complex objects
  - Often properties with listviews are returned with periods to denote additional elements
