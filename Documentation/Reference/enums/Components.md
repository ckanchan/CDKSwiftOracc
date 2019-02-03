**ENUM**

# `Components`

```swift
public enum Components
```

> Presents a single interface to any signs that are comprised of subsigns, whilst preserving the 'group|gdl|seq' metadata

## Cases
### `group(_:)`

```swift
case group([GraphemeDescription])
```

> If a logogram consists of multiple graphemes, it seems to be represented by this

### `gdl(_:)`

```swift
case gdl([GraphemeDescription])
```

> Seems to represent subelements in a name

### `sequence(_:)`

```swift
case sequence([GraphemeDescription])
```

> Some kind of container for further elements
