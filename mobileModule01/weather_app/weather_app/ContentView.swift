import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Spacer()
            // Bottom bar
            GeometryReader { geometry in
                Navigation()
            }
            .frame(height: 80)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
