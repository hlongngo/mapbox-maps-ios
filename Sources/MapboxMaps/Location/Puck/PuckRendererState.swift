/// Substate of ``PuckRenderingData`` which contains only data needed for ``FollowPuckViewportState`` rendering.
/// Allows to use ``Signal.skipRepeats()`` and avoid unnecessary recalculations.
public struct PuckRendererState<Configuration: Equatable>: Equatable {
    public var coordinate: CLLocationCoordinate2D
    public var horizontalAccuracy: CLLocationAccuracy?
    public var accuracyAuthorization: CLAccuracyAuthorization
    public var bearing: CLLocationDirection?
    public var heading: Heading?
    public var configuration: Configuration
    public var bearingEnabled: Bool
    public var bearingType: PuckBearing
}

extension PuckRendererState {
    public init(
        data: PuckRenderingData,
        bearingEnabled: Bool,
        bearingType: PuckBearing,
        configuration: Configuration
    ) {
        self.coordinate = data.location.coordinate
        self.horizontalAccuracy = data.location.horizontalAccuracy
        self.accuracyAuthorization = data.location.accuracyAuthorization
        self.bearing = data.location.bearing
        self.heading = data.heading
        self.configuration = configuration
        self.bearingEnabled = bearingEnabled
        self.bearingType = bearingType
    }
}
