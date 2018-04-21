**STRUCT**

# `OraccCatalogEntry`

```swift
public struct OraccCatalogEntry
```

## Properties
### `displayName`

```swift
public let displayName: String
```

> Short name for referencing

### `title`

```swift
public let title: String
```

> Descriptive title for the text content assigned by its editors

### `id`

```swift
public let id: String
```

> CDLI ID, ususally a P or X number

### `ancientAuthor`

```swift
public let ancientAuthor: String?
```

> Ancient author, if available

### `project`

```swift
public let project: String
```

> Path for the originating project

### `chapterNumber`

```swift
public let chapterNumber: Int?
```

### `chapterName`

```swift
public let chapterName: String?
```

### `chapter`

```swift
public var chapter: String
```

### `genre`

```swift
public let genre: String?
```

### `material`

```swift
public let material: String?
```

### `period`

```swift
public let period: String?
```

### `provenience`

```swift
public let provenience: String?
```

### `primaryPublication`

```swift
public let primaryPublication: String?
```

### `museumNumber`

```swift
public let museumNumber: String?
```

### `publicationHistory`

```swift
public let publicationHistory: String?
```

### `notes`

```swift
public let notes: String?
```

### `credits`

```swift
public let credits: String?
```

> Copyright and editorial information

## Methods
### `initFromSaved(id:displayName:ancientAuthor:title:project:)`

```swift
public static func initFromSaved(id: String, displayName: String, ancientAuthor: String?, title: String, project: String) -> OraccCatalogEntry
```
