# CDKSwiftOracc
Cuneiform documents for Swift.

## WARNINGS
This package is in alpha and is deficient in important ways:
- Not yet able to decode cuneiform numbers
- Formatting across broken and half-broken signs is messy
- HTML output is simplistic, using inline HTML style tags, and needs to be updated to allow CSS styling.


## Introduction
This package is a Swift implementation of the Open Richly Annotated Cuneiform Corpus ("Oracc")  schemas for encoding cuneiform texts. In particular, it seeks to provide:
- Easy to use Swift types to work with signs, words, texts and glossaries
- Codable types compatible with Oracc JSON open data
- Catalogue types compatible with Oracc-defined datasets
- Methods to provide plain-text, HTML, or NSAttributedString output for cuneiform, transliteration and normalisation

## Documentation
Documentation is available [here](./Documentation/Reference/README.md)


## Specifications
Oracc XML standards are available on the [Oracc website](http://oracc.museum.upenn.edu/doc/about/standards/index.html) although many of them are inaccessible at the moment, so they can alternatively be found directly in the Oracc [Github repository](https://github.com/oracc/oracc/tree/master/doc/ns).

Oracc JSON specifications are available on the [Oracc website](http://oracc.museum.upenn.edu/doc/opendata/index.html). This package implements:

- catalogue.json: type "catalogue"
- JSON for individual text editions: type "cdl"
- glossary-XXX.json: type "glossary"
