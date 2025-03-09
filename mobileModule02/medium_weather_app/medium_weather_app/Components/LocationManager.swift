//
//  LocationManager.swift
//  medium_weather_app
//
//  Created by Artur Harutyunyan on 09.03.25.
//

import SwiftUI
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var lat: String?
    @Published var lon: String?
    @Published var status: Bool?
    @Published var cityName: String?
    @Published var countryName: String?
    @Published var stateName: String?

    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var locationUpdateCompletion: (() -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkStatus()
    }

    func checkStatus() {
        if CLLocationManager.locationServicesEnabled() {
            checkAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            print("Location services are disabled")
        }
    }

    private func checkAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            status = true
        case .restricted:
            print("Location access is restricted")
            status = false
        case .denied:
            print("Location access is denied")
            status = false
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        lat = String(location.coordinate.latitude)
        lon = String(location.coordinate.longitude)
        reverseGeocode(location: location)
    }

    private func reverseGeocode(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) {[weak self] placemarks, error in
            guard let self = self, error == nil, let placemark = placemarks?.first else {
                print("Unknown error")
                return
            }

            DispatchQueue.main.async {
                self.cityName = placemark.locality
                self.countryName = placemark.country
                self.stateName = placemark.administrativeArea

//                self.locationUpdateCompletion?()
            }
        }
    }

    func requestLocationUpdate(completion: @escaping () -> Void) {
        locationUpdateCompletion = completion
        locationManager.startUpdatingLocation()
    }
}

