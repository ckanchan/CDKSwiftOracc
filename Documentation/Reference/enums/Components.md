**ENUM**

# `Components`

```swift
public enum Components
```

> Presents a single interface to any signs that are comprised of subsigns, whilst preserving the 'group|gdl|seq' metadata

## Cases
### `group`

```swift
case group([GraphemeDescription])
```

> If a logogram consists of multiple graphemes, it seems to be represented by this

### `gdl`

```swift
case gdl([GraphemeDescription])
```

> Seems to represent subelements in a name

### `sequence`

```swift
case sequence([GraphemeDescription])
```

> Some kind of container for further elements
