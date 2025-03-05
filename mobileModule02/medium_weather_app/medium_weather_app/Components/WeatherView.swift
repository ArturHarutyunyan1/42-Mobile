//
//  WeatherView.swift
//  weather_app
//
//  Created by Artur Harutyunyan on 02.03.25.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

struct searchResultItem : Codable {
    let results: [searchResult]
}

struct searchResult: Codable, Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
    let admin1: String
}


enum apiCallError : Error {
    case invalidCityName
    case invalidResponse
    case invalidData
}

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
    @Published var searchResults: [searchResult] = []
    
    func setCoords(name: String, latitude: String, longitude: String) {
        cityName = name
        lat = latitude
        lon = longitude
    }
    
    func searchAPI(name: String) async {
        do {
            let result = try await getSearchResults(name: name)
            await MainActor.run { [weak self] in
                self?.searchResults = result.results
            }
        } catch {
            print("Error fetching search results:", error)
        }
    }
    func getSearchResults(name: String) async throws -> searchResultItem {
        let endpoint = "https://geocoding-api.open-meteo.com/v1/search?name=\(name)&count=10&language=en&format=json"
        guard let url = URL(string: endpoint) else {
            throw apiCallError.invalidCityName
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw apiCallError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(searchResultItem.self, from: data)
        } catch {
            throw apiCallError.invalidData
        }
    }
}
