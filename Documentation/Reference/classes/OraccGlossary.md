**CLASS**

# `OraccGlossary`

```swift
public final class OraccGlossary
```

> Class representing an Oracc glossary

## Properties
### `project`

```swift
public let project: String
```

### `lang`

```swift
public let lang: String
```

### `entries`

```swift
public let entries: [GlossaryEntry]
```

### `instances`

```swift
public let instances: [String: [XISReference]]
```

> Dictionary of XISReference paths to instances of a glossary entry in the corpus, keyed by the XISKey property. Use `instancesOf(_ entry: GlossaryEntry)` to access.

## Methods
### `instancesOf(_:)`

```swift
public func instancesOf(_ entry: GlossaryEntry) -> [XISReference]
```

> Look up paths to instances of a specific glossary entry
> - Parameter entry: A 'GlossaryEntry' struct, which can be looked up directly in the `OraccGlossary.entries` array or through one of the lookup methods.

#### Parameters

| Name | Description |
| ---- | ----------- |
| entry | A ‘GlossaryEntry’ struct, which can be looked up directly in the `OraccGlossary.entries` array or through one of the lookup methods. |

### `lookUp(citationForm:)`

```swift
public func lookUp(citationForm: String) -> GlossaryEntry?
```

> Gets the full entry for a specific citation form
> - Parameter citationForm: the CDA conventional form of the Akkadian lemma.

#### Parameters

| Name | Description |
| ---- | ----------- |
| citationForm | the CDA conventional form of the Akkadian lemma. |

### `lookUp(node:)`

```swift
public func lookUp(node: OraccCDLNode) -> GlossaryEntry?
```

> Gets a full entry for a text edition lemma, if present.
> - Parameter node: any OraccCDLNode within an OraccTextEdition.
> - Returns: `GlossaryEntry` if a valid lemma, `nil` if otherwise

#### Parameters

| Name | Description |
| ---- | ----------- |
| node | any OraccCDLNode within an OraccTextEdition. |

### `searchResults(citationForm:inCatalogue:)`

```swift
public func searchResults(citationForm: String, inCatalogue catalogue: OraccCatalog) -> TextSearchCollection?
```

> Returns a set of texts containing the search term
> - Parameter citationForm: the CDA citation form of the search term
> - Parameter inCatalogue: the catalogue in which to perform the search, which must correspond to the catalogue from which the glossary is derived
> - Returns: `TextSearchCollection`, which conforms to the same interface as an OraccCatalog and thus can be used to display and look up results.

#### Parameters

| Name | Description |
| ---- | ----------- |
| citationForm | the CDA citation form of the search term |
| inCatalogue | the catalogue in which to perform the search, which must correspond to the catalogue from which the glossary is derived |