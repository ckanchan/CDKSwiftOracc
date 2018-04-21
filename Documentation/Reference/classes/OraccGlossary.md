**CLASS**

# `OraccGlossary`

```swift
public final class OraccGlossary
```

> Class representing an Oracc glossary

## Properties
### `project`

```swift
public let project: String
```

### `lang`

```swift
public let lang: String
```

### `entries`

```swift
public let entries: [GlossaryEntry]
```

### `instances`

```swift
public let instances: [String: [XISReference]]
```

## Methods
### `instancesOf(_:)`

```swift
public func instancesOf(_ entry: GlossaryEntry) -> [XISReference]
```
