//
//  WeatherView.swift
//  weather_app
//
//  Created by Artur Harutyunyan on 02.03.25.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var cityName: String = ""
    @Published var lat: String = ""
    @Published var lon: String = ""
    @Published var searchResults: [searchResult] = []
    @Published var locationInfo: LocationInfo?
    @Published var errorMessage: String? = nil
    @Published var searchError: String? = nil
    @Published var date: String?
    
    func setCoords(name: String, latitude: String, longitude: String) {
        cityName = name
        lat = latitude
        lon = longitude
    }
    
    func searchAPI(name: String) async {
        do {
            let result = try await getSearchResults(name: name)
            await MainActor.run { [weak self] in
                if result.results.isEmpty {
                    self?.searchError = "No results found for the given city."
                } else {
                    self?.searchResults = result.results
                    self?.searchError = nil
                }
            }
        } catch {
            print("Error fetching search results:", error)
            await MainActor.run { [weak self] in
                self?.searchError = "Error fetching search results: \(error.localizedDescription)"
            }
        }
    }

    
    func getSearchResults(name: String) async throws -> searchResultItem {
        let endpoint = "https://geocoding-api.open-meteo.com/v1/search?name=\(name)&count=10&language1=en&format=json"
        guard let url = URL(string: endpoint) else {
            searchError = "Invalid city name"
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
        Task {
            DispatchQueue.main.async {
                self.errorMessage = nil
            }
        }
        let endpoint = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current=weathercode,temperature_2m,wind_speed_10m&hourly=weathercode,temperature_2m,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min"
        guard let url = URL(string: endpoint) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL for weather forecast."
            }
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching weather data: \(error)")
                DispatchQueue.main.async {
                    self.errorMessage = "Error fetching weather data: \(error.localizedDescription)"
                }
                return
            }
            guard let data = data else {
                print("Invalid data received")
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid data received"
                }
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
                        city: location.cityName ?? "-",
                        state: location.stateName ?? "-",
                        country: location.countryName ?? "-",
                        weaterData: decodedData
                    )
                    self.setCondition()
                    self.chartData()
                }
            } catch {
                print("Error decoding weather data: \(error)")
                DispatchQueue.main.async {
                    self.errorMessage = "Error decoding weather data: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

extension WeatherViewModel {
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
    func mapWeatherCodeToIconName(_ code: Int) -> String {
        switch code {
        case 0: return "sun.max.fill"
        case 1: return "cloud.sun.fill"
        case 2: return "cloud.sun.fill"
        case 3: return "cloud.fill"
        case 45, 48: return "cloud.fog.fill"
        case 51: return "cloud.drizzle.fill"
        case 53: return "cloud.drizzle.fill"
        case 55: return "cloud.drizzle.fill"
        case 61: return "cloud.rain.fill"
        case 63: return "cloud.rain.fill"
        case 65: return "cloud.rain.fill"
        case 71: return "cloud.snow.fill"
        case 73: return "cloud.snow.fill"
        case 75: return "cloud.snow.fill"
        case 80: return "cloud.showers.fill"
        case 81: return "cloud.showers.fill"
        case 82: return "cloud.showers.fill"
        case 85: return "cloud.snow.fill"
        case 86: return "cloud.snow.fill"
        default: return "questionmark.circle.fill"
        }
    }
    func setCondition() {
        if let weatherCode = locationInfo?.weaterData!.current.weathercode {
            locationInfo?.currentStatus = mapWeatherCodeToStatus(weatherCode)
            locationInfo?.iconName = mapWeatherCodeToIconName(weatherCode)
        }
        if let weatherStatuses = locationInfo?.weaterData?.hourly.weathercode {
            locationInfo?.todayStatus = weatherStatuses.map { mapWeatherCodeToStatus($0) }
        }
        if let weeklyStatuses = locationInfo?.weaterData?.daily.weather_code {
            locationInfo?.weeklyStatus = weeklyStatuses.map { mapWeatherCodeToStatus($0) }
        }
    }
    func chartData () {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date = dateFormatter.string(from: Date())
        
        if locationInfo?.chart == nil {
            locationInfo?.chart = ChartData(timeValue: [], temperatureValue: [])
        }
        
        if let data = locationInfo?.weaterData?.hourly {
            for (index, fullTime) in data.time.enumerated() {
                let time = fullTime.components(separatedBy: "T")
                if let datePart = time.first, datePart == date {
                    if let hour = time.last?.prefix(2), let hourInt = Int(hour), hourInt % 3 == 0 {
                        locationInfo?.chart?.timeValue.append(time.last ?? "")
                        if index < data.temperature_2m.count {
                            locationInfo?.chart?.temperatureValue.append(data.temperature_2m[index])
                        }
                    }
                }
            }
        }
    }
}
