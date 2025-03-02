//
//  ContentView.swift
//  weather_app
//
//  Created by Artur Harutyunyan on 01.03.25.
//


import SwiftUI

enum AppTab: CaseIterable, Hashable {
    case currently, today, weekly
}

struct ContentView: View {
    @State private var selectedTab: AppTab = .currently
    @StateObject private var handler = WeatherViewModel()
    var body: some View {
        VStack (spacing: 0) {
            Search(handler: handler)
            NavigationStack {
                ZStack {
                    if selectedTab == .currently {
                        Home(cityName: $handler.cityName)
                            .id("currently")
                            .transition(.asymmetric(
                                insertion: AnyTransition.move(edge: .trailing).combined(with: .opacity),
                                removal: AnyTransition.move(edge: .leading).combined(with: .opacity)
                            ))
                    } else if selectedTab == .today {
                        Today(cityName: $handler.cityName)
                            .id("today")
                            .transition(.asymmetric(
                                insertion: AnyTransition.move(edge: .trailing).combined(with: .opacity),
                                removal: AnyTransition.move(edge: .leading).combined(with: .opacity)
                            ))
                    } else if selectedTab == .weekly {
                        Weekly(cityName: $handler.cityName)
                            .id("weekly")
                            .transition(.asymmetric(
                                insertion: AnyTransition.move(edge: .trailing).combined(with: .opacity),
                                removal: AnyTransition.move(edge: .leading).combined(with: .opacity)
                            ))
                    }
                    VStack {
                        Spacer()
                        Navigation(selectedTab: $selectedTab)
                            .frame(height: 80)
                            .padding(.horizontal)
                    }
                }
                .animation(.linear(duration: 0.3), value: selectedTab)
                .navigationBarBackButtonHidden(true)
            }
            .gesture(
                DragGesture(minimumDistance: 50)
                    .onEnded { value in
                        if abs(value.translation.width) > abs(value.translation.height) {
                            let tabs = AppTab.allCases
                            if let currentIndex = tabs.firstIndex(of: selectedTab) {
                                if value.translation.width > 0 {
                                    let newIndex = (currentIndex - 1 + tabs.count) % tabs.count
                                    selectedTab = tabs[newIndex]
                                } else {
                                    let newIndex = (currentIndex + 1) % tabs.count
                                    selectedTab = tabs[newIndex]
                                }
                            }
                        }
                    }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
