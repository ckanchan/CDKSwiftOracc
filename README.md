# OraccJSONtoSwift

This package is a Swift implementation of the Open Richly Annotated Cuneiform Corpus ("Oracc")  schemas for encoding cuneiform texts. In particular, it seeks to provide:
- Easy to use Swift types to work with signs, words, texts and glossaries
- Codable types compatible with Oracc JSON open data
- Catalogue types compatible with Oracc-defined datasets
- Methods to provide plain-text, HTML, or NSAttributedString output for cuneiform, transliteration and normalisation

## Documentation
Documentation is available [here](./Documentation/README.md)


## Specifications
Oracc XML standards are available on the [Oracc website](http://oracc.museum.upenn.edu/doc/about/standards/index.html) although many of them are inaccessible at the moment, so they can alternatively be found directly in the Oracc [Github repository](https://github.com/oracc/oracc/tree/master/doc/ns).

Oracc JSON specifications are available on the [Oracc website](http://oracc.museum.upenn.edu/doc/opendata/index.html)]. This package implements:

- catalogue.json: type "catalogue"
- JSON for individual text editions: type "cdl"
- glossary-XXX.json: type "glossary"
