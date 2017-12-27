**STRUCT**

# `OraccCatalog`

```swift
public struct OraccCatalog: Decodable
```

## Properties
### `source`

```swift
public let source: URL
```

### `project`

```swift
public let project: String
```

### `members`

```swift
public let members: [String: OraccCatalogEntry]
```

### `keys`

```swift
public lazy var keys: [String] =
```

## Methods
### `sortBySAANum()`

```swift
public mutating func sortBySAANum()
```
