//
//  Navigation.swift
//  weather_app
//
//  Created by Artur Harutyunyan on 01.03.25.
//

import SwiftUI

struct Navigation: View {
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                HStack(spacing: 20) {
                    NavigationLink(destination: ContentView()) {
                        VStack(spacing: 4) {
                            Image(systemName: "sun.max.fill")
                                .font(.system(size: 20, weight: .medium))
                            Text("Currently")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    NavigationLink(destination: ContentView()) {
                        VStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 20, weight: .medium))
                            Text("Today")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    NavigationLink(destination: ContentView()) {
                        VStack(spacing: 4) {
                            Image(systemName: "calendar.circle.fill")
                                .font(.system(size: 20, weight: .medium))
                            Text("Weekly")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(Color(.systemGray6))
                .clipShape(Capsule())
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .frame(width: geometry.size.width * 0.8, height: 60, alignment: .center)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
