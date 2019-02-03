**EXTENSION**

# `OraccCatalogEntry`

## Properties
### `description`

```swift
public var description: String
```

## Methods
### `init(displayName:title:id:ancientAuthor:project:chapterNumber:chapterName:genre:material:period:provenience:primaryPublication:museumNumber:publicationHistory:notes:pleiadesID:pleiadesCoordinate:credits:)`

```swift
public init(displayName: String, title: String, id: String, ancientAuthor: String?, project: String, chapterNumber: Int?, chapterName: String?, genre: String?, material: String?, period: String?, provenience: String?, primaryPublication: String?, museumNumber: String?, publicationHistory: String?, notes: String?, pleiadesID: Int?, pleiadesCoordinate: (Double, Double)?, credits: String?)
```

### `init(id:displayName:ancientAuthor:title:project:)`

```swift
public init(id: String, displayName: String, ancientAuthor: String?, title: String, project: String)
```

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