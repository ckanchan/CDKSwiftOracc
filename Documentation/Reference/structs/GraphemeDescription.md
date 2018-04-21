**STRUCT**

# `GraphemeDescription`

```swift
public struct GraphemeDescription
```

> Base structure for representing cuneiform signs (graphemes) decoded from the grapheme description language. Enables sign-by-sign cuneiform and transliteration functionality. Simplified implementation of the GDL specification, found [here](https://github.com/oracc/oracc/blob/master/doc/ns/gdl/1.0/gdl.xdf)

## Properties
### `graphemeUTF8`

```swift
public let graphemeUTF8: String?
```

> Cuneiform glyph in UTF-8

### `sign`

```swift
public let sign: CuneiformSignReading
```

> Sign reading metadata

### `isLogogram`

```swift
public let isLogogram: Bool
```

> True if the sign is a logogram; used for formatting purposes.

### `preservation`

```swift
public let preservation: Preservation
```

> Sign preservation

### `breakPosition`

```swift
public let breakPosition: BreakPosition?
```

> If broken, whether it's at the start or the end

### `isDeterminative`

```swift
public let isDeterminative: Determinative?
```

> If a determinative, what role it plays (usually 'semantic'), and position it occupies

### `group`

```swift
public let group: [GraphemeDescription]?
```

> If a logogram consists of multiple graphemes, it seems to be represented by this

### `gdl`

```swift
public let gdl: [GraphemeDescription]?
```

> Seems to represent subelements in a name

### `sequence`

```swift
public let sequence: [GraphemeDescription]?
```

> Some kind of container for further elements

### `delim`

```swift
public let delim: String?
```

> If defined, a string that separates this character from the next one.

## Methods
### `init(graphemeUTF8:sign:isLogogram:preservation:breakPosition:isDeterminative:group:gdl:sequence:delimiter:)`

```swift
public init(graphemeUTF8: String?, sign: CuneiformSignReading, isLogogram: Bool, preservation: Preservation = Preservation.preserved, breakPosition: BreakPosition?, isDeterminative: Determinative?, group: [GraphemeDescription]?, gdl: [GraphemeDescription]?, sequence: [GraphemeDescription]?, delimiter: String?)
```

> Creates a single grapheme description containing the Unicode cuneiform, sign metadata and delimiter information for formatting
