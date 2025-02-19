import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("Calculator")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(.blue)
                .foregroundStyle(.white)

            Text("Display")
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.3)
                .background(.red)
            Spacer()
            Text("Digits")
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.56)
                .background(.blue)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
