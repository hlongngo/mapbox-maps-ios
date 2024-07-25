// Wraps a layer with its ``LayerPosition`` so it can be placed appropriately in the layer stack.

@_documentation(visibility: public)
@available(iOS 13.0, *)
public struct LayerAtPosition<L>: MapStyleContent, PrimitiveMapContent where L: Layer, L: Equatable {
    // The layer wrapped in its ``LayerPosition``
    var layer: L
    var position: LayerPosition

    func visit(_ node: MapContentNode) {
        node.mount(MountedLayer(layer: layer, customPosition: position))
    }
}


@available(iOS 13.0, *)
extension SlotLayer {
    /// Positions this layer at a specified position.
    ///
    /// - Note: This method should be called last in a chain of layer updates.
    
    @_documentation(visibility: public)
    public func position(_ position: LayerPosition) -> LayerAtPosition<Self> {
        LayerAtPosition(layer: self, position: position)
    }
}
