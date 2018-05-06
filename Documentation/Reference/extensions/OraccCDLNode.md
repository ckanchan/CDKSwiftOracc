**EXTENSION**

# `OraccCDLNode`

## Properties
### `description`

```swift
public var description: String
```

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
