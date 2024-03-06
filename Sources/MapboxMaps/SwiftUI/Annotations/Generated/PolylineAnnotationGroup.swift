// This file is generated

/// Displays a group of ``PolylineAnnotation``s.
///
/// When multiple annotation grouped, they render by a single layer. This makes annotations more performant and
/// allows to modify group-specific parameters.  For example, you canmodify ``lineCap(_:)`` or define layer slot with ``slot(_:)``.
///
/// - Note: `PolylineAnnotationGroup` is a SwiftUI analog to ``PolylineAnnotationManager``.
///
/// The group can be created with dynamic data, or static data. When first method is used, you specify array of identified data and provide a closure that creates a ``PolylineAnnotation`` from that data, similar to ``ForEvery``:
////// ```swift
/// Map {
///   PolylineAnnotationGroup(routes) { route in
///     PolylineAnnotation(lineCoordinates: route.coordinates)
///       .lineColor("blue")
///   }
///   .lineCap(.round)
///   .slot("middle")
/// }
/// ```
///
/// When the number of annotations is static, you use static that groups one or more annotations:
////// ```swift
/// Map {
///     PolylineAnnotationGroup {
///         PolylineAnnotation(lineCoordinates: route.coordinates)
///             .lineColor("blue")
///         if let alternativeRoute {
///             PolylineAnnotation(lineCoordinates: alternativeRoute.coordinates)
///                 .lineColor("green")
///         }
///     }
///     .lineCap(.round)
///     .slot("middle")
/// }
/// ```
    @_documentation(visibility: public)
@_spi(Experimental)
public struct PolylineAnnotationGroup<Data: RandomAccessCollection, ID: Hashable>: PrimitiveMapContent {
    let store: ForEvery<PolylineAnnotation, Data, ID>

    /// Creates a group that identifies data by given key path.
    ///
    /// - Parameters:
    ///     - data: Collection of data.
    ///     - id: Data identifier key path.
    ///     - content: A closure that creates annotation for a given data item.
    @_documentation(visibility: public)
    public init(_ data: Data, id: KeyPath<Data.Element, ID>, content: @escaping (Data.Element) -> PolylineAnnotation) {
        store = ForEvery(data: data, id: id, content: content)
    }

    /// Creates a group from identifiable data.
    ///
    /// - Parameters:
    ///     - data: Collection of identifiable data.
    ///     - content: A closure that creates annotation for a given data item.
    @_documentation(visibility: public)
    @available(iOS 13.0, *)
    public init(_ data: Data, content: @escaping (Data.Element) -> PolylineAnnotation) where Data.Element: Identifiable, Data.Element.ID == ID {
        self.init(data, id: \.id, content: content)
    }

    /// Creates static group.
    ///
    /// - Parameters:
    ///     - content: A builder closure that creates annotations.
    @_documentation(visibility: public)
    public init(@ArrayBuilder<PolylineAnnotation> content: @escaping () -> [PolylineAnnotation?])
        where Data == Array<(Int, PolylineAnnotation)>, ID == Int {
        let annotations = content().enumerated().compactMap {
            $0.element == nil ? nil : ($0.offset, $0.element!)
        }
        self.init(annotations, id: \.0, content: \.1)
    }

    func _visit(_ visitor: MapContentVisitor) {
        let group = AnnotationGroup(
            positionalId: visitor.positionalId,
            layerId: layerId,
            layerPosition: layerPosition,
            store: store,
            make: { $0.makePolylineAnnotationManager(id: $1, layerPosition: $2) },
            updateProperties: { self.updateProperties(manager: $0) })
        visitor.add(annotationGroup: group)
    }

    private func updateProperties(manager: PolylineAnnotationManager) {
        assign(manager, \.lineCap, value: lineCap)
        assign(manager, \.lineMiterLimit, value: lineMiterLimit)
        assign(manager, \.lineRoundLimit, value: lineRoundLimit)
        assign(manager, \.lineDasharray, value: lineDasharray)
        assign(manager, \.lineDepthOcclusionFactor, value: lineDepthOcclusionFactor)
        assign(manager, \.lineEmissiveStrength, value: lineEmissiveStrength)
        assign(manager, \.lineTranslate, value: lineTranslate)
        assign(manager, \.lineTranslateAnchor, value: lineTranslateAnchor)
        assign(manager, \.lineTrimOffset, value: lineTrimOffset)
        assign(manager, \.slot, value: slot)
    }

    // MARK: - Common layer properties

    private var lineCap: LineCap?
    /// The display of line endings.
    @_documentation(visibility: public)
    public func lineCap(_ newValue: LineCap) -> Self {
        with(self, setter(\.lineCap, newValue))
    }

    private var lineMiterLimit: Double?
    /// Used to automatically convert miter joins to bevel joins for sharp angles.
    @_documentation(visibility: public)
    public func lineMiterLimit(_ newValue: Double) -> Self {
        with(self, setter(\.lineMiterLimit, newValue))
    }

    private var lineRoundLimit: Double?
    /// Used to automatically convert round joins to miter joins for shallow angles.
    @_documentation(visibility: public)
    public func lineRoundLimit(_ newValue: Double) -> Self {
        with(self, setter(\.lineRoundLimit, newValue))
    }

    private var lineDasharray: [Double]?
    /// Specifies the lengths of the alternating dashes and gaps that form the dash pattern. The lengths are later scaled by the line width. To convert a dash length to pixels, multiply the length by the current line width. Note that GeoJSON sources with `lineMetrics: true` specified won't render dashed lines to the expected scale. Also note that zoom-dependent expressions will be evaluated only at integer zoom levels.
    @_documentation(visibility: public)
    public func lineDasharray(_ newValue: [Double]) -> Self {
        with(self, setter(\.lineDasharray, newValue))
    }

    private var lineDepthOcclusionFactor: Double?
    /// Decrease line layer opacity based on occlusion from 3D objects. Value 0 disables occlusion, value 1 means fully occluded.
    @_documentation(visibility: public)
    public func lineDepthOcclusionFactor(_ newValue: Double) -> Self {
        with(self, setter(\.lineDepthOcclusionFactor, newValue))
    }

    private var lineEmissiveStrength: Double?
    /// Controls the intensity of light emitted on the source features.
    @_documentation(visibility: public)
    public func lineEmissiveStrength(_ newValue: Double) -> Self {
        with(self, setter(\.lineEmissiveStrength, newValue))
    }

    private var lineTranslate: [Double]?
    /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
    @_documentation(visibility: public)
    public func lineTranslate(_ newValue: [Double]) -> Self {
        with(self, setter(\.lineTranslate, newValue))
    }

    private var lineTranslateAnchor: LineTranslateAnchor?
    /// Controls the frame of reference for `line-translate`.
    @_documentation(visibility: public)
    public func lineTranslateAnchor(_ newValue: LineTranslateAnchor) -> Self {
        with(self, setter(\.lineTranslateAnchor, newValue))
    }

    private var lineTrimOffset: [Double]?
    /// The line part between [trim-start, trim-end] will be marked as transparent to make a route vanishing effect. The line trim-off offset is based on the whole line range [0.0, 1.0].
    @_documentation(visibility: public)
    public func lineTrimOffset(_ newValue: [Double]) -> Self {
        with(self, setter(\.lineTrimOffset, newValue))
    }

    private var slot: String?
    /// 
    /// Slot for the underlying layer.
    ///
    /// Use this property to position the annotations relative to other map features if you use Mapbox Standard Style.
    /// See <doc:Migrate-to-v11##21-The-Mapbox-Standard-Style> for more info.
    @_documentation(visibility: public)
    public func slot(_ newValue: String) -> Self {
        with(self, setter(\.slot, newValue))
    }


    private var layerPosition: LayerPosition?

    /// Defines relative position of the layers drawing the annotations managed by the current group.
    ///
    /// - NOTE: Layer position isn't updatable. Only the first value passed to this function set will take effect.
    @_documentation(visibility: public)
    public func layerPosition(_ newValue: LayerPosition) -> Self {
        with(self, setter(\.layerPosition, newValue))
    }

    private var layerId: String?

    /// Specifies identifier for underlying implementation layer.
    ///
    /// Use the identifier in ``layerPosition(_:)``, or to create view annotations bound the annotations from the group.
    /// For more information, see the ``MapViewAnnotation/init(layerId:featureId:content:)``.
    @_documentation(visibility: public)
    public func layerId(_ layerId: String) -> Self {
        with(self, setter(\.layerId, layerId))
    }
}

extension PolylineAnnotation: PrimitiveMapContent, MapContentAnnotation {
    func _visit(_ visitor: MapContentVisitor) {
        PolylineAnnotationGroup { self }
            ._visit(visitor)
    }
}

extension PolylineAnnotationManager: MapContentAnnotationManager {}

// End of generated file.
