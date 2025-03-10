//
//  Home.swift
//  weather_app
//
//  Created by Artur Harutyunyan on 01.03.25.
//
import SwiftUI

struct Home: View {
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
                        if let data = locationInfo?.weaterData {
                            Text("\(String(format: "%.1f", data.current.temperature_2m))℃")
                                .font(.system(size: 80, weight: .light))
                                .foregroundColor(.white)
                                .padding(.top, 30)
                            Image(systemName: locationInfo?.iconName ?? "questionmark.circle")
                                .resizable()
                                .scaledToFit()
                                .symbolRenderingMode(.hierarchical)
                                .frame(width: 120, height: 120)
                                .foregroundStyle(.white)
                            HStack {
                                Image(systemName: "wind")
                                    .resizable()
                                    .foregroundStyle(.white)
                                    .frame(width: 22, height: 22)
                                Text("\(String(format: "%.1f", data.current.wind_speed_10m)) km/h")
                                    .font(.system(size: 22, weight: .light))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .scrollIndicators(.hidden)
    }
}
