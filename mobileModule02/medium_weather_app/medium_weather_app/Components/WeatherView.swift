//
//  WeatherView.swift
//  weather_app
//
//  Created by Artur Harutyunyan on 02.03.25.
//

import SwiftUI
import CoreLocation
import CoreLocationUI



class WeatherViewModel: ObservableObject {
    @Published var cityName: String = ""
    
    func setCityName(input: String) {
        cityName = input
    }
}
