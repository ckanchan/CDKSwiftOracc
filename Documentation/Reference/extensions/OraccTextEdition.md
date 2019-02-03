**EXTENSION**

# `OraccTextEdition`

## Methods
### `html5Transliteration()`

```swift
public func html5Transliteration() -> String
```

> Returns an HTML formatted transliteration suitable for embedding in a web page

### `html5Normalisation()`

```swift
public func html5Normalisation() -> String
```

### `html5NormalisationPage()`

```swift
public func html5NormalisationPage() -> String
```

### `init(withCDL:textID:)`

```swift
public init(withCDL nodes: [OraccCDLNode] = [], textID: TextID = "")
```

### `scrapeTranslation()`

```swift
public func scrapeTranslation() -> String?
```

> Tries to scrape translation from Oracc HTML using the XML tree-based parser. A bit hackish. Returns nil if a translation can't be formed. If you use this method you *must* include the copyright and license for the text manually.

### `scrapeTranslation(_:)`

> Asynchronously scrapes a text translation from the Oracc webpage using an event-based parser, then calls the supplied completion handler. You will need to check manually whether the copyright notice and license are included in the scraped text. If the copyright notice and license are not included, you *must* include this manually.
> - Throws: `ScrapeError.NoDataAtURL` if the URL could not be reached.

### `normalised()`

```swift
public func normalised() -> NSAttributedString
```

> Returns a normalisation of the text edition with formatting hints as a platform-independent NSAttributedString

### `transliterated()`

```swift
public func transliterated() -> NSAttributedString
```

> Returns a transliteration of the text edition with formatting hints as a platform-independent NSAttributedString
