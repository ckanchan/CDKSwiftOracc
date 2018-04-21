**STRUCT**

# `OraccCDLNode`

```swift
public struct OraccCDLNode
```

> A single node in an Oracc CDL nested representation of a cuneiform document. Wraps a single `CDLNode` property.

## Properties
### `node`

```swift
public let node: CDLNode
```

## Methods
### `init(lemma:)`

```swift
public init(lemma l: Lemma)
```

### `init(chunk:)`

```swift
public init(chunk c: Chunk)
```

### `init(discontinuity:)`

```swift
public init(discontinuity d: Discontinuity)
```

### `init(linkbase:)`

```swift
public init(linkbase lb: [Linkset])
```
