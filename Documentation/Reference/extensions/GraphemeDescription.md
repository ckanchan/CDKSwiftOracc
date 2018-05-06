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

### `transliteratedHTML5()`

```swift
public func transliteratedHTML5() -> String
```
