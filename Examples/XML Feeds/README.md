# Client Side Rendering (JSLink) with XML Feeds
##### (RSS, Atom, Atom2, RDF)

The sample code and the tutorial write-up demonstrate how to use Client Side Rendering (CSR) to display standard XML feeds. RSS, Atom, Atom2, and RDF are all supported with this approach but this tutorial focuses specifically on RSS.

By the end of the tutorial, you should know:
- How to configure the XMLViewer web part
- Supported Feed types
- How to create a basic XSL Wrapper
- How to use csrShim with the XMLViewer web part

## Example Files
- [csrShimXMLWrapper.xsl](csrShimXMLWrapper.xsl) - A standard XSL Wrapper (needed to set csrShim parameters with the XMLViewer). This file is used in the tutorial but can also serve as the starting point for any feed implementation
- [FeedDisplay.js](FeedDisplay.js) - A JSLink file to use in the tutorial
- **README.md** - This file, wow!

## Required csrShim Files
- [csrShim.xsl](../../csrShim/csrShim.xsl)

## Tutorial
The tutorial is provided as a blog post here:

[Client Side Rendering (JSLink) with RSS Feeds](https://thechriskent.com/2016/11/14/client-side-rendering-jslink-with-rss-feeds/)
