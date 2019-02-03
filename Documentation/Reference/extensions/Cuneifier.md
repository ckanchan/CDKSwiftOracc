**EXTENSION**

# `Cuneifier`

## Methods
### `init(json:)`

```swift
public init(json: Data) throws
```

> Initialises a `Cuneifier` struct from a validly formatted JSON file.

### `init(asl:)`

```swift
public init(asl: Data) throws
```

> Initialises a `Cuneifier` from an Oracc [`.asl` sign list format](https://github.com/oracc/oracc/blob/master/doc/ns/sl/1.0/sl.xdf). This is twice as slow as initialising from a codable JSON file so that method is preferred.
