**ENUM**

# `CuneiformSignReading`

```swift
public enum CuneiformSignReading
```

> Datatype enumerating a localized reading of a cuneiform sign from a tablet.

## Cases
### `value`

```swift
case value(String)
```

> Sign read with syllabic value.

### `name`

```swift
case name(String)
```

> Sign read with name. Usually indicates a logogram in Akkadian texts.

### `number`

```swift
case number(String)
```

> Sexagesimal number

### `formVariant`

```swift
case formVariant(form: String, base: String, modifier: [Modifier])
```

> Complex sign form variant
>  - Parameter form: simple text representation of the complex sign.
>  - Parameter base: basic sign value component
>  - Parameter modifier: array of cuneiform sign modifiers, represented as `CuneiformSign.Modifier`

### `null`

```swift
case null
```

> Debug value; shouldn't appear under normal circumstances and shouldn't be used directly.
