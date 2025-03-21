//
//  Home.swift
//  weather_app
//
//  Created by Artur Harutyunyan on 01.03.25.
//

import SwiftUI


struct Home: View {
    @Binding var cityName: String
    var body: some View {
        VStack {
            Text("\(cityName)")
                .font(.system(size: 50))
            Text("Currently")
                .font(.system(size: 50))
        }
    }
}
