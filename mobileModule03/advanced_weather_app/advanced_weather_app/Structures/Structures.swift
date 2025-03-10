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
    let hourly: HourlyData
    let daily: DailyData
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

struct HourlyData : Codable {
    let time: [String]
    let weathercode: [Int]
    let temperature_2m: [Double]
    let wind_speed_10m: [Double]
}

struct DailyData : Codable {
    let time: [String]
    let weather_code: [Int]
    let temperature_2m_max: [Double]
    let temperature_2m_min: [Double]
}

struct LocationInfo : Codable {
    var latitude: Double
    var longitude: Double
    var city: String?
    var state: String?
    var country: String?
    var currentStatus: String?
    var todayStatus: [String]?
    var weeklyStatus: [String]?
    var weaterData: WeatherData?
    var iconName: String?
}

enum apiCallError : Error {
    case invalidCityName
    case invalidResponse
    case invalidData
}
