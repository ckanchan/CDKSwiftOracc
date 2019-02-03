**STRUCT**

# `Cuneifier`

```swift
public struct Cuneifier
```

> Provides an interface for converting transliterated syllables to cuneiform glyphs.

## Methods
### `cuneifySyllable(_:)`

```swift
public func cuneifySyllable(_ syllable: String) -> String
```

> Converts a transliterated syllable to a cuneiform glyph, looking up the sign in an internal sign dictionary.
> - Parameter syllable: transliterated representation of a cuneiform sign following standard Assyriological conventions
> - Returns: standard string representation of the cuneiform grapheme, or "[X]" if the sign couldn't be found.

#### Parameters

| Name | Description |
| ---- | ----------- |
| syllable | transliterated representation of a cuneiform sign following standard Assyriological conventions |