**STRUCT**

# `Lemma`

```swift
public struct Lemma: Equatable, Hashable, CustomStringConvertible
```

> A single unit of meaning, in cuneiform and translated forms. Summary information is included in the top-level properties; more detailed information can be accessed under the Form property and its Translation and GraphemeDescription fields.

## Properties
### `hashValue`

```swift
public var hashValue: Int
```

### `description`

```swift
public var description: String
```

### `fragment`

```swift
public let fragment: String
```

> Transliteration with diacritical marks.

### `instanceTranslation`

```swift
public let instanceTranslation: String?
```

> String key containing normalisation[translation]partofspeech

### `wordForm`

```swift
public let wordForm: WordForm
```

> Detailed wordform information

### `reference`

```swift
public let reference: NodeReference
```

> Reference for glossary lookup

### `transliteration`

```swift
public var transliteration: String
```

## Methods
### `==(_:_:)`

```swift
public static func ==(lhs: OraccCDLNode.Lemma, rhs: OraccCDLNode.Lemma) -> Bool
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | A value to compare. |
| rhs | Another value to compare. |

### `init(fragment:instanceTranslation:wordForm:reference:)`

```swift
public init(fragment: String, instanceTranslation: String?, wordForm: WordForm, reference: NodeReference)
```
