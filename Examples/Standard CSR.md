#Standard Client Side Rendering
Client Side Rendering (CSR), often referred to as JSLink, is a technology introduced with SharePoint 2013 that provides extension points to use JavaScript to render SharePoint data. CSR continues to be supported in SharePoint 2016 and Office 365.

In many ways, CSR is far more powerful and flexible than its predecessor XSLT (eXtensible Stylesheet Language Transformations). JavaScript knowledge is more prevalent and accessible than XSL and the tooling is far superior (debugging, frameworks, simplified templates, easy web service integration, etc.). However, CSR support, even in the latest versions of SharePoint, does not extend as far as XSLT.

Additional information about how to use standard client side rendering with list views can be found in the [List View Client Side Rendering (JSLink) Primer series](https://thechriskent.com/2016/04/11/csr1-an-introduction-to-client-side-rendering/).

##Limitations
- Potential for flashing based on client performance
- Not fully supported – Display templates are used in some search web parts, but only the XSLTListView web part provides the JS Link property
- Targeting multiple list views on the same page requires fragile or hacky workarounds

##Why csrShim?
Standard Client Side Rendering (CSR) is an extremely powerful SharePoint technology but there are limitations when working with web parts outside of the XSLTListView web part. Many of these limitations are addressed through the csrShim XSL stylesheet.

Using csrShim, developers can utilize CSR (generally called JSLink) with Content by Query web parts (CQWP) and XMLViewer web parts (XML based feeds). Additionally, csrShim provides an extremely easy and contained solution for solving the multiple list views per page issue inherent to standard CSR.
