**CLASS**

# `OraccJSONtoSwiftInterface`

```swift
public class OraccJSONtoSwiftInterface
```

> Base object for the framework. Initialise it with a source for Oracc JSON, then query it for text catalogues, individual texts within those catalogues, and cuneiform, transliteration and translation data for those texts.

## Properties
### `availableVolumes`

```swift
public var availableVolumes: [OraccVolume]
```

## Methods
### `init(fromLocation:)`

```swift
public init(fromLocation location: JSONSource)
```

> Initialises an OraccJSONtoSwiftInterface object that consumes JSON and returns Swift structs from the location specified. `.getAvailableVolumes()` must be called immediately after initialisation.
> - Parameter fromLocation: Takes a `JSONSource` value, with `local` requiring a local path specified.

#### Parameters

| Name | Description |
| ---- | ----------- |
| fromLocation | Takes a `JSONSource` value, with `local` requiring a local path specified. |

### `getAvailableVolumes()`

```swift
public func getAvailableVolumes()
```

> Refreshes the list of available volumes from the data source. Must be called immediately after initialisation

### `loadCatalogue(_:completion:)`

```swift
public func loadCatalogue(_ volume: OraccVolume, completion: @escaping (OraccCatalog) -> Void)
```

> Downloads and decodes an `OraccCatalogue` struct for the volume requested, then calls the supplied completion handler.
>
> - Parameter _: Takes an `OraccVolume` value.
> - Parameter completion: Called if an OraccCatalog has been successfully downloaded and decoded. Use the completion handler to store the returned OraccCatalog for querying.

#### Parameters

| Name | Description |
| ---- | ----------- |
| completion | Called if an OraccCatalog has been successfully downloaded and decoded. Use the completion handler to store the returned OraccCatalog for querying. |

### `loadText(_:inCatalogue:)`

```swift
public func loadText(_ key: String, inCatalogue: OraccCatalog) -> OraccTextEdition?
```

> Queries a catalogue for the supplied Text ID and Catalogue and returns an `OraccText` struct that can be queried for text edition information.
>
> - Parameter _: Takes a string specifying the text you want, in CDLI Text ID format. Usually a P number (Pxxxxxx) but X and Q designations are also common.
> - Parameter inCatalogue: Searches an `OraccCatalog` for the text specified. If the text isnt't available then an error is printed and nothing is returned.

#### Parameters

| Name | Description |
| ---- | ----------- |
| inCatalogue | Searches an `OraccCatalog` for the text specified. If the text isnt’t available then an error is printed and nothing is returned. |