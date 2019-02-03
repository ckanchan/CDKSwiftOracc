**STRUCT**

# `XISReference`

```swift
public struct XISReference: CustomStringConvertible
```

> A path reference to a specific instance of a glossary lemma. Indexed by a XISKey string.

## Properties
### `description`

```swift
public var description: String
```

### `project`

```swift
public let project: String
```

### `cdliID`

```swift
public var cdliID: TextID
```

### `reference`

```swift
public let reference: NodeReference
```

## Methods
### `init(withReference:)`

```swift
public init?(withReference key: String)
```
