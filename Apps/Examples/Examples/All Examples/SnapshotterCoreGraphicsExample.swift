import UIKit
import MapboxMaps
import Combine

// Define the Polyline structure to hold coordinates
struct Polyline {
    let coordinates: [CLLocationCoordinate2D]
}

// SnapshotManager responsible for creating snapshots
class SnapshotManager {
    private var snapshotter: Snapshotter!
    private var cancelables = Set<AnyCancellable>()

    func setupSnapshotter(with options: MapSnapshotOptions) {
        snapshotter = Snapshotter(options: options)
        snapshotter.styleURI = .dark
        snapshotter.setCamera(to: CameraOptions(center: CLLocationCoordinate2D(latitude: 51.180885866921386, longitude: 16.26129435178828), zoom: 4))
    }
    
    @MainActor
    func snapshotPolyline(_ polyline: Polyline) async throws -> UIImage {
        return try await withCheckedThrowingContinuation {[weak self] continuation in
            guard let self = self else {
                continuation.resume(throwing: NSError(domain: "SnapshotManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "SnapshotManager deallocated"]))
                return
            }
            snapshotter.onStyleLoaded.observeNext { _ in
                Task {
                    self.startSnapshot(for: polyline) { result in
                        switch result {
                        case .success(let image):
                            continuation.resume(returning: image)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                }
            }.store(in: &cancelables)
            snapshotter.styleURI = .dark
        }
    }

    private func startSnapshot(for polyline: Polyline, completion: @escaping (Result<UIImage, Error>) -> Void) {
        snapshotter.start { overlayHandler in
            let context = overlayHandler.context
            guard let firstCoordinate = polyline.coordinates.first else {
                completion(.failure(NSError(domain: "SnapshotManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Polyline has no coordinates"])))
                return
            }

            let startPoint = overlayHandler.pointForCoordinate(firstCoordinate)
            context.setStrokeColor(UIColor.yellow.cgColor)
            context.setLineWidth(6.0)
            context.setLineCap(.round)
            context.move(to: startPoint)

            for coordinate in polyline.coordinates.dropFirst() {
                let point = overlayHandler.pointForCoordinate(coordinate)
                context.addLine(to: point)
            }

            context.strokePath()
        } completion: { result in
            switch result {
            case .success(let image):
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// ViewController responsible for UI and interacting with SnapshotManager
final class SnapshotterCoreGraphicsExample: UIViewController, NonMapViewExampleProtocol {
    private var snapshotView: UIImageView!
    private let snapshotManager = SnapshotManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSnapshotView()
        createSnapshot()
    }

    private func setupSnapshotView() {
        snapshotView = UIImageView(frame: .zero)
        snapshotView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(snapshotView)

        NSLayoutConstraint.activate([
            snapshotView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            snapshotView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func createSnapshot() {
        let options = MapSnapshotOptions(size: CGSize(width: view.bounds.size.width, height: 300), pixelRatio: 4)
        
        Task { @MainActor in
            await snapshotManager.setupSnapshotter(with: options)
            
            let polyline = Polyline(coordinates: [
                CLLocationCoordinate2D(latitude: 52.53, longitude: 13.38),
                CLLocationCoordinate2D(latitude: 50.06, longitude: 19.92)
            ])
            
            do {
                let image = try await snapshotManager.snapshotPolyline(polyline)
                snapshotView.image = image
            } catch {
                print("Error generating snapshot: \(error.localizedDescription)")
            }
            
            finish()
        }
    }
}
