**STRUCT**

# `GlossaryEntry`

```swift
public struct GlossaryEntry: Codable, CustomStringConvertible
```

> An Oracc glossary entry

## Properties
### `id`

```swift
public let id: String
```

> Unique ID for entry

### `xisKey`

```swift
public let xisKey: String
```

> Index key allowing lookup of references

### `headWord`

```swift
public let headWord: String
```

> Main heading for entry, formatted as `entry[translation]POS`

### `citationForm`

```swift
public let citationForm: String
```

> Conventional citation form as found in the Concise Dictionary of Akkadian

### `guideWord`

```swift
public let guideWord: String?
```

> Guide translation

### `partOfSpeech`

```swift
public let partOfSpeech: String?
```

> Part of speech

### `instanceCount`

```swift
public let instanceCount: String
```

> Number of times this headword appears in the corpus

### `forms`

```swift
public let forms: [Form]?
```

> Transliterated spellings found in the corpus

### `norms`

```swift
public let norms: [Norm]?
```

> Transcriptions of spellings suggested by editors

### `senses`

```swift
public let senses: [Sense]?
```

> Various senses for translation

### `description`

```swift
public var description: String
```

## Methods
### `init(id:xisKey:headWord:citationForm:guideWord:partOfSpeech:instanceCount:forms:norms:senses:)`

```swift
public init(id: String, xisKey: String, headWord: String, citationForm: String, guideWord: String?, partOfSpeech: String?, instanceCount: String, forms: [Form]?, norms: [Norm]?, senses: [Sense]?)
```
