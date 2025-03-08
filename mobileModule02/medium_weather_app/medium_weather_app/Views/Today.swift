//
//  Today.swift
//  weather_app
//
//  Created by Artur Harutyunyan on 01.03.25.
//

import SwiftUI

struct Today: View {
    @Binding var locationInfo: LocationInfo?
    var body: some View {
        VStack {
            Text("\(locationInfo?.weaterData?.current.temperature_2m)")
        }
    }
}
