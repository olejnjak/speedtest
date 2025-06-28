import CoreLocation
import OSLog

protocol GetLocationUseCase {
    func callAsFunction() async -> CLLocationCoordinate2D?
}

@MainActor
func createGetLocationUseCase() -> GetLocationUseCase {
    GetLocationUseCaseImpl(accuracy: kCLLocationAccuracyThreeKilometers)
}

@MainActor
private final class GetLocationUseCaseImpl: NSObject, GetLocationUseCase, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var continuations = [UnsafeContinuation<CLLocationCoordinate2D?, Never>]()

    // MARK: - Initializers

    init(accuracy: CLLocationAccuracy) {
        super.init()

        locationManager.desiredAccuracy = accuracy
    }

    // MARK: - Actions

    func callAsFunction() async -> CLLocationCoordinate2D? {
        await withUnsafeContinuation { continuation in
            locationManager.delegate = self

            switch locationManager.authorizationStatus {
            case .notDetermined:
                continuations.append(continuation)
                locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                continuations.append(continuation)
                locationManager.requestLocation()
            case .restricted, .denied:
                continuation.resume(returning: nil)
            @unknown default:
                continuation.resume(returning: nil)
            }
        }
    }

    // MARK: - CLLocationManager delegate

    nonisolated func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        Logger.location
            .debug("Location manager is authorized: \(manager.authorizationStatus.isAuthorized)")

        guard manager.authorizationStatus.isAuthorized else {
            return
        }

        Task {
            await locationManager.requestLocation()
        }
    }

    nonisolated func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        Logger.location.debug("Location manager got locations: \(locations)")

        Task {
            await updateLocations(locations.last)
        }
    }

    nonisolated func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: any Error
    ) {
        Logger.location.error("Location manager error: \(error.localizedDescription)")
        Logger.location.debug("Location manager error debug info: \((error as NSError).debugDescription)")

        Task {
            await updateLocations(nil)
        }
    }

    // MARK: - Private helpers

    private func updateLocations(_ location: CLLocation?) {
        while continuations.isEmpty == false {
            let continuation = continuations.removeFirst()
            continuation.resume(returning: location?.coordinate)
        }
    }
}

private extension CLAuthorizationStatus {
    var isAuthorized: Bool {
        switch self {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
}
