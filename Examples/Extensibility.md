#####Documentation:
- [Parameters](Parameters.md): What you can pass to csrShim
- [Properties](Properties.md): What csrShim gives you back 
- [Extensibility](Extensibility.md): How to extend csrShim

#Extensibility
csrShim is an open source project and you may request to contribute through this GitHub repository. You can either fork the project or submit a pull request to have it integrated back into the main repository.

Additionally, csrShim is setup to accept multiple templates. You can easily create a wrapper stylesheet that imports csrShim and provide your own template that calls the routeToShim template with appropriate values. Examples of this are provided in the [Extending csrShim for Custom XML (JSLink)](Custom XML/README.md) example.
