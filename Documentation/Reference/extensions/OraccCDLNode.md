**EXTENSION**

# `OraccCDLNode`

## Properties
### `description`

```swift
public var description: String
```

### `reference`

```swift
public var reference: String
```

> The unique `NodeReference` for the node. Only implemented for `OraccCDLNode.Lemma` at the moment. An empty string if not a lemma.

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

### `transliterated()`

```swift
public func transliterated() -> String
```

### `normalised()`

```swift
func normalised() -> String
```

### `literalTranslation()`

```swift
func literalTranslation() -> String
```

### `cuneiform()`

```swift
func cuneiform() -> String
```

### `discontinuityTypes()`

```swift
func discontinuityTypes() -> Set<String>
```

### `chunkTypes()`

```swift
func chunkTypes() -> Set<String>
```

### `init(normalisation:transliteration:translation:cuneifier:documentID:position:)`

```swift
public init(normalisation: String, transliteration: String, translation: String, cuneifier: ((String) -> String?), documentID: UUID, position: Int)
```
