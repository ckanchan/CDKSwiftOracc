**ENUM**

# `CuneiformSignReading`

```swift
public enum CuneiformSignReading
```

> Datatype enumerating a localized reading of a cuneiform sign from a tablet.

## Cases
### `value(_:)`

```swift
case value(String)
```

> Sign read with syllabic value.

### `name(_:)`

```swift
case name(String)
```

> Sign read with name. Usually indicates a logogram in Akkadian texts.

### `number(value:sexagesimal:)`

```swift
case number(value: Float, sexagesimal: String)
```

> Sexagesimal number

### `formVariant(form:base:modifier:)`

```swift
case formVariant(form: String, base: String, modifier: [Modifier])
```

> Complex sign form variant
> - Parameter form: simple text representation of the complex sign.
> - Parameter base: basic sign value component
> - Parameter modifier: array of cuneiform sign modifiers, represented as `CuneiformSign.Modifier`

### `null`

```swift
case null
```

> Debug value; shouldn't appear under normal circumstances and shouldn't be used directly.
