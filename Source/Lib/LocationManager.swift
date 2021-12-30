//
//  LocationManager.swift
//  Fast Foodz (iOS)
//
//  Created by Andrew Barba on 12/29/21.
//

import Foundation
import CoreLocation

class LocationManager: ObservableObject {

    @Published var location: CLLocation?

    private lazy var manager: _LocationManager = {
        let manager = _LocationManager()
        manager.onLocation = { [weak self] location in
            self?.location = location
        }
        return manager
    }()

    func requestCurrentLocation() {
        manager.requestCurrentLocation()
    }
}

private class _LocationManager: NSObject {

    var onLocation: ((CLLocation?) -> Void)?

    private lazy var manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()

    func requestCurrentLocation() {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            self.onLocation?(Constants.Location.newYorkCity)
        }
    }
}

extension _LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.onLocation?(locations.first)
        manager.stopUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            self.onLocation?(Constants.Location.newYorkCity)
        default:
            break
        }
    }
}


