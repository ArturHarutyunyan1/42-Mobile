//
//  WeatherView.swift
//  weather_app
//
//  Created by Artur Harutyunyan on 02.03.25.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var lat: String?
    @Published var lon: String?
    @Published var status: Bool?
    let locationManager = CLLocationManager()

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
    }

}


class WeatherViewModel: ObservableObject {
    @Published var cityName: String = ""
    @Published var lat: String = ""
    @Published var lon: String = ""
    
    func setCityName(input: String) {
        cityName = input
    }
    func setLat(input: String) {
        lat = input
    }
    func setLon(input: String) {
        lon = input
    }
}
