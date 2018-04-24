**EXTENSION**

# `OraccTextEdition`

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

### `scrapeTranslation()`

```swift
public func scrapeTranslation() -> String?
```

> Tries to scrape translation from Oracc HTML using the XML tree-based parser. A bit hackish. Returns nil if a translation can't be formed. If you use this method you *must* include the copyright and license for the text manually.

### `scrapeTranslation(_:)`

> Asynchronously scrapes a text translation from the Oracc webpage using an event-based parser, then calls the supplied completion handler. You will need to check manually whether the copyright notice and license are included in the scraped text. If the copyright notice and license are not included, you *must* include this manually.
> - Throws: `ScrapeError.NoDataAtURL` if the URL could not be reached.

### `flattenNodes()`

```swift
public func flattenNodes() -> [OraccCDLNode]
```
