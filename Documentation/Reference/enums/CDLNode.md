**ENUM**

# `CDLNode`

```swift
public enum CDLNode
```

> Base element of a cuneiform document: a `Chunk` representing a section of text, which contains further `Chunk`s, `Discontinuity` or `Lemma`

## Cases
### `l`

```swift
case l(Lemma)
```

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
