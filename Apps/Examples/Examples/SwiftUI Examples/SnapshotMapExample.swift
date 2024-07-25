import SwiftUI
import MapboxMaps

// Tạo MapItem struct
@available(iOS 13.0, *)
struct MapItem: Identifiable {
    let id = UUID()
    let initialViewport: Viewport
}

@available(iOS 13.0, *)
struct SnapshotMapExample: View {
    @State private var images: [UUID: UIImage] = [:]
    let mapItems: [MapItem] = Array(repeating: MapItem(initialViewport: .helsinkiOverview), count: 20)
    
    var body: some View {
        List(mapItems) { item in
            GeometryReader { geometry in
                VStack(spacing: 10) {
                    MapReader { proxy in
                        Map(initialViewport: item.initialViewport)
                            .mapStyle(.outdoors)
                            .onMapIdle { _ in
                                images[item.id] = proxy.captureSnapshot()
                            }
                            .frame(height: 300)
                    }
                    
                    if let snapshot = images[item.id] {
                        Image(uiImage: snapshot)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 300)
                    } else {
                        Text("Loading snapshot...")
                            .frame(height: 300)
                    }
                }
                .frame(width: geometry.size.width)
            }
            .frame(height: 300)
        }
    }
}

@available(iOS 13.0, *)
private extension Viewport {
    static let helsinkiOverview = Self.overview(geometry: Polygon(center: .helsinki, radius: 10000, vertices: 30))
}

@available(iOS 13.0, *)
struct SnapshotMapExample_Preview: PreviewProvider {
    static var previews: some View {
        SnapshotMapExample()
    }
}
