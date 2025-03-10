//
//  Today.swift
//  weather_app
//
//  Created by Artur Harutyunyan on 01.03.25.
//

import SwiftUI
import Foundation
import Charts

struct Today: View {
    @Binding var locationInfo: LocationInfo?
    @ObservedObject var handler: WeatherViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let error = handler.errorMessage {
                    Text(error)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.red)
                        .padding(.top, 20)
                } else {
                    VStack(spacing: 12) {
                        Text(locationInfo?.city ?? "-")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.white)
                        Text("\(locationInfo?.state ?? "-"), \(locationInfo?.country ?? "-")")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .opacity(0.8)
                        VStack {
                            if let chart = locationInfo?.chart {
                                Chart {
                                    ForEach(0..<chart.timeValue.count, id: \.self) { index in
                                        LineMark(
                                            x: .value("Time", chart.timeValue[index]),
                                            y: .value("Temperature", chart.temperatureValue[index])
                                        )
                                        .symbol(.circle)
                                        AreaMark(
                                            x: .value("Time", chart.timeValue[index]),
                                            y: .value("Temperature", chart.temperatureValue[index])
                                        )
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: 300)
                                .padding(.vertical, 20)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        .background(Color(.systemGray6).opacity(0.3))
                        .cornerRadius(15)
                    }
                    ScrollView (.horizontal, showsIndicators: false) {
                        HStack {
                            
                        }
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .scrollIndicators(.hidden)
    }
}
