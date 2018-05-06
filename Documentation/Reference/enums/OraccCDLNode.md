**ENUM**

# `OraccCDLNode`

```swift
public enum OraccCDLNode
```

> A single node in an Oracc CDL nested representation of a cuneiform document.

## Cases
### `l`

```swift
case l(Lemma)
```

> Base element of a cuneiform document: a `Chunk` representing a section of text, which contains further `Chunk`s, `Discontinuity` or `Lemma`. The abbreviated `c`, `d`, `l`, cases reflect the Oracc usage.

### `c`

```swift
case c(Chunk)
```

### `d`

```swift
case d(Discontinuity)
```

### `linkbase`

```swift
case linkbase([Linkset])
```
