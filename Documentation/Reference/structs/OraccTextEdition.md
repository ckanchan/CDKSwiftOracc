**STRUCT**

# `OraccTextEdition`

```swift
public struct OraccTextEdition: Codable
```

## Properties
### `type`

```swift
public let type: String
```

### `project`

```swift
public let project: String
```

### `loadedFrom`

```swift
public var loadedFrom: URL? = nil
```

### `cdl`

```swift
public let cdl: [OraccCDLNode]
```

> Access to the raw CDL node array

### `url`

```swift
public var url: URL?
```

> URL for online edition. Returns `nil` if unable to form URL.

### `transliteration`

```swift
public var transliteration: String
```

> Computed transliteration. This is recalculated every time it is called so you will need to store it yourself.

### `transcription`

```swift
public var transcription: String
```

> Computed normalisation. This may not be applicable if a text has not been lemmatised. This is recalculated every time it is called so you will need to store it yourself.

### `literalTranslation`

```swift
public var literalTranslation: String
```

> Computed literal translation. This may not be applicable if a text has not been lemmatised. This is recalculated every time it is called so you will need to store it yourself.

### `cuneiform`

```swift
public var cuneiform: String
```

> Computed cuneiform. This is recalculated every time it is called so you will need to store it yourself.

## Methods
### `createNewText(nodes:)`

```swift
public static func createNewText(nodes: [OraccCDLNode] = []) -> OraccTextEdition
```
