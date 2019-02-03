**EXTENSION**

# `OSL`

## Methods
### `convertToJSON(_:)`

```swift
public static func convertToJSON(_ asl: Data) throws -> Data
```

> Converts an Oracc [`.asl` sign list format](https://github.com/oracc/oracc/blob/master/doc/ns/sl/1.0/sl.xdf) to JSON format for use by the `Cuneifier` struct.
> - Parameter asl: Valid Oracc SL file in ASCII or UTF8 encoding.
> - Returns: Encoded JSON as a `Data` value suitable for writing to a file.

#### Parameters

| Name | Description |
| ---- | ----------- |
| asl | Valid Oracc SL file in ASCII or UTF8 encoding. |