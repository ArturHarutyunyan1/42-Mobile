import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack (alignment: .top) {
                    Text("Calculator")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(.white)
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                .background(.blue)
                Spacer()
                VStack {
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    ContentView()
}
