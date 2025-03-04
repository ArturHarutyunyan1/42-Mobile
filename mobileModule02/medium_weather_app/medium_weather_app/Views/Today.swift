//
//  Today.swift
//  weather_app
//
//  Created by Artur Harutyunyan on 01.03.25.
//

import SwiftUI

struct Today: View {
    @Binding var cityName: String
    @Binding var latitude: String?
    @Binding var longitude: String?
    var body: some View {
        VStack {
            Text(cityName.isEmpty
                 ? (latitude != nil && longitude != nil
                    ? "\(latitude!), \(longitude!)"
                    : "")
                 : cityName)
                .font(.system(size: 20))
            Text("Today")
                .font(.system(size: 50))
        }
    }
}
