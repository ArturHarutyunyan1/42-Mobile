import SwiftUI

enum AppTab: Hashable {
    case currently, today, weekly
}

struct ContentView: View {
    @State private var selectedTab: AppTab = .currently
    
    var body: some View {
        NavigationStack {
            ZStack {
                if selectedTab == .currently {
                    Home()
                        .id("currently")
                        .transition(.asymmetric(
                            insertion: AnyTransition.move(edge: .trailing).combined(with: .opacity),
                            removal: AnyTransition.move(edge: .leading).combined(with: .opacity)
                        ))
                } else if selectedTab == .today {
                    Today()
                        .id("today")
                        .transition(.asymmetric(
                            insertion: AnyTransition.move(edge: .trailing).combined(with: .opacity),
                            removal: AnyTransition.move(edge: .leading).combined(with: .opacity)
                        ))
                } else if selectedTab == .weekly {
                    Weekly()
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
            .animation(.smooth(duration: 0.3), value: selectedTab)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
