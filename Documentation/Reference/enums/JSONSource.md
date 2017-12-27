**ENUM**

# `JSONSource`

```swift
public enum JSONSource
```

> Represents possible locations that expose Oracc JSON data.
> - Oracc: Connects to http://oracc.org to get JSON data. Should be the most up to date, but most JSON isn't available yet.
> - Github: Connects to the Oracc Github repository which contains ZIP archives of JSON. Requires local disk space as the uncompressed archives are quite large.
> - Local: Takes a local path to JSON stored on disk. Useful for debugging.

## Cases
### `github`

```swift
case github
```

### `oracc`

```swift
case oracc
```

### `local`

```swift
case local(String)
```
