**EXTENSION**

# `OraccTextEdition`

## Properties
### `scrapeTranslation`

```swift
public var scrapeTranslation: String?
```

> Tries to scrape translation from Oracc HTML. A bit hackish. Returns nil if a translation can't be formed.

## Methods
### `formattedNormalisation(withFont:)`

> Returns a string formatted with Akkadian normalisation.

### `formattedTransliteration(withFont:)`

> Returns a formatted transliteration.

### `formattedCuneiform(withFont:)`

> Returns a cuneified string with additional metadata
> - Parameter font: A font that covers cuneiform codepoints. Allows choice between OB or NA glyphs.

### `htmlTransliteration()`

```swift
public func htmlTransliteration() -> String
```

> Returns an HTML formatted transliteration suitable for embedding in a web page

### `formattedNormalisation(withFont:)`

```swift
public func formattedNormalisation(withFont font: NSFont) -> NSAttributedString
```

> Returns a string formatted with Akkadian normalisation.

### `formattedTransliteration(withFont:)`

```swift
public func formattedTransliteration(withFont font: NSFont) -> NSAttributedString
```

> Returns a formatted transliteration.

### `scrapeTranslation(_:)`

### `flattenNodes()`

```swift
public func flattenNodes() -> [OraccCDLNode]
```
