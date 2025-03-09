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
    @Published var cityName: String?
    @Published var countryName: String?
    @Published var stateName: String?
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
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
            }
        }
    }
}

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var cityName: String = ""
    @Published var lat: String = ""
    @Published var lon: String = ""
    @Published var searchResults: [searchResult] = []
    @Published var locationInfo: LocationInfo?
    
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
    func getWeatherForecast(lat: Double, lon: Double, location: LocationManager) {
        let endpoint = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current=weathercode,temperature_2m,wind_speed_10m&hourly=weathercode,temperature_2m,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min"
        guard let url = URL(string: endpoint) else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching weather data: \(error)")
                return
            }
            guard let data = data else {
                print("Invalid data received")
                return
            }
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(WeatherData.self, from: data)
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                DispatchQueue.main.async {
                    self.locationInfo = LocationInfo(
                        latitude: lat,
                        longitude: lon,
                        city: location.cityName ?? "Unknown",
                        state: location.stateName ?? "Unknown",
                        country: location.countryName ?? "Unknown",
                        weaterData: decodedData
                    )
                    self.setCondition()
                }
            } catch {
                print("Error decoding weather data: \(error)")
            }
        }.resume()
    }
    func mapWeatherCodeToStatus(_ code: Int) -> String {
        switch code {
        case 0: return "Clear sky"
        case 1: return "Mainly clear"
        case 2: return "Partly cloudy"
        case 3: return "Cloudy"
        case 45, 48: return "Fog"
        case 51: return "Light Drizzle"
        case 53: return "Moderate Drizzle"
        case 55: return "Dense Drizzle"
        case 61: return "Light Rain"
        case 63: return "Moderate Rain"
        case 65: return "Heavy Rain"
        case 71: return "Light Snow"
        case 73: return "Moderate Snow"
        case 75: return "Heavy Snow"
        case 80: return "Light Showers"
        case 81: return "Moderate Showers"
        case 82: return "Heavy Showers"
        case 85: return "Light Snow Showers"
        case 86: return "Heavy Snow Showers"
        default: return "Unknown"
        }
    }
    func setCondition() {
        if let weatherCode = locationInfo?.weaterData!.current.weathercode {
            locationInfo?.currentStatus = mapWeatherCodeToStatus(weatherCode)
        }
        if let weatherStatuses = locationInfo?.weaterData?.hourly.weathercode {
            locationInfo?.todayStatus = weatherStatuses.map {mapWeatherCodeToStatus($0)}
        }
        if let weeklyStatuses = locationInfo?.weaterData?.daily.weather_code {
            locationInfo?.weeklyStatus = weeklyStatuses.map {mapWeatherCodeToStatus($0)}
        }
    }
}
