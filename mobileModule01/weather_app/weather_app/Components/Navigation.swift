//
//  Navigation.swift
//  weather_app
//
//  Created by Artur Harutyunyan on 01.03.25.
//

import SwiftUI

struct Navigation: View {
    @Binding var selectedTab: AppTab
    var body: some View {
        HStack(spacing: 20) {
            Button(action: { selectedTab = .currently }) {
                navItem(image: "sun.max.fill", text: "Currently")
            }
            Button(action: { selectedTab = .today }) {
                navItem(image: "calendar", text: "Today")
            }
            Button(action: { selectedTab = .weekly }) {
                navItem(image: "calendar.circle.fill", text: "Weekly")
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(Color(.systemGray6))
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    @ViewBuilder
    func navItem(image: String, text: String) -> some View {
        VStack (spacing: 4) {
            Image(systemName: image)
                .font(.system(size: 20, weight: .medium))
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
    }
}
