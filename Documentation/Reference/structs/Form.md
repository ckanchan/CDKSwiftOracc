**STRUCT**

# `Form`

```swift
public struct Form: Codable
```

> Encodes information about individual spellings for a given headword.

## Properties
### `spelling`

```swift
public let spelling: String?
```

> Spelling of a lemma, given in transliteration. Not given for forms of type "normform"

### `reference`

```swift
public let reference: String?
```

> For 'normforms', a reference to the concrete form.

### `id`

```swift
public let id: String
```

> A unique ID for this spelling.

### `instanceCount`

```swift
public let instanceCount: String
```

> The number of times this spelling appears in the corpus

### `instancePercentage`

```swift
public let instancePercentage: String
```

> The percentage of spellings this form makes up within the corpus.
