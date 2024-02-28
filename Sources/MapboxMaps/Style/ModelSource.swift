import Foundation

/// A structure represeting a Model
public struct Model: Equatable, Codable {

    /// The model's identifier
    public var id: String?

    /// URL to a `gltf` 3D asset in the application bundle
    public var uri: URL?

    /// Coordinates of the model in `[longitude, latitude]`format
    public var position: [Double]?

    /// Orientation of the model
    public var orientation: [Double]?

    public init(id: String? = nil, uri: URL? = nil, position: [Double]? = nil, orientation: [Double]? = nil) {
        self.id = id
        self.uri = uri
        self.position = position
        self.orientation = orientation
    }
}

@_spi(Experimental)
extension Model: PrimitiveMapStyleContent {
    func _visit(_ visitor: MapStyleContentVisitor) {
        guard let id, uri != nil else {
            Log.warning(forMessage: "Failed to add Model to StyleModel because it does not have an id or uri.", category: "styleDSL")
            return
        }
        visitor.model.models[id] = self
    }
}

/// A model data source used to power a `ModelLayer`
internal struct ModelSource: Source {
    internal let type: SourceType
    let id: String

    /// Dictionary of model identifiers to models
    internal var models: [String: Model]?

    internal init(id: String) {
        self.id = id
        type = .model
    }
}
