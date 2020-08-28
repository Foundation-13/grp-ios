import CoreLocation


enum LocationError: Error {
    case noValue
    case emptyCoordinate
    case accessDenied
}

enum LocationPermission {
    case notDetermined
    case restricted
    case allowed
}

// MARK:- LocationProvider
protocol LocationProvider {
    func checkPermissions() -> LocationPermission
    func askForPermissions()
}

// MARK: LocationService
final class LocationService: NSObject {
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    private let locationManager: CLLocationManager
}

extension LocationService: LocationProvider {
    func checkPermissions() -> LocationPermission {
        if CLLocationManager.locationServicesEnabled() {
            let authStatus = CLLocationManager.authorizationStatus()
            
            switch authStatus {
            case .notDetermined:
                return .notDetermined
            case .denied, .restricted:
                return .restricted
            case .authorizedAlways, .authorizedWhenInUse:
                return .allowed
            @unknown default:
                return .allowed
            }
        }
        
        return .restricted
    }
    
    func askForPermissions() {
        locationManager.requestWhenInUseAuthorization()
    }
}
