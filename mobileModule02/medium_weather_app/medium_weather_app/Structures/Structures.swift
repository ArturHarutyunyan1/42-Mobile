//
//  Structures.swift
//  medium_weather_app
//
//  Created by Artur Harutyunyan on 07.03.25.
//

import Foundation

struct searchResultItem : Codable {
    let results: [searchResult]
}

struct WeatherData : Codable {
    let current: CurrentData
}

struct searchResult: Codable, Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
    let admin1: String
}

struct CurrentData : Codable {
    let time: String
    let interval: Int
    let weathercode: Int
    let temperature_2m: Double
    let wind_speed_10m: Double

}

struct LocationInfo : Equatable {
    var latitude: Double
    var longitude: Double
    var city: String?
    var state: String?
    var country: String?
}

enum apiCallError : Error {
    case invalidCityName
    case invalidResponse
    case invalidData
}
