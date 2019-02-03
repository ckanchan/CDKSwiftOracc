**EXTENSION**

# `GraphemeDescription`

## Properties
### `cuneiform`

```swift
public var cuneiform: String
```

> A computed property that returns cuneiform.

### `transliteration`

```swift
public var transliteration: String
```

> A computed property that returns transliteration as an unformatted string.

## Methods
### `init(from:)`

```swift
public init(from decoder: Decoder) throws
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| decoder | The decoder to read data from. |

### `encode(to:)`

```swift
public func encode(to encoder: Encoder) throws
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| encoder | The encoder to write data to. |

### `init(syllable:delimiter:cuneifier:)`

```swift
init(syllable: String, delimiter: String, cuneifier: ((String) -> String?))
```

> A simplified initialiser that creates a basic grapheme with no complex metadata.
> - Parameter syllable: transliterated syllable in Roman script
> - Parameter delimiter: separator between this sign and the next. Supply the empty string if at the end of a word.
> - Parameter cuneifier: function that converts a transliterated syllable into a cuneiform glyph.

#### Parameters

| Name | Description |
| ---- | ----------- |
| syllable | transliterated syllable in Roman script |
| delimiter | separator between this sign and the next. Supply the empty string if at the end of a word. |
| cuneifier | function that converts a transliterated syllable into a cuneiform glyph. |

### `transliteratedHTML5()`

```swift
public func transliteratedHTML5() -> String
```
