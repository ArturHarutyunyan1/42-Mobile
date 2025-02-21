import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                HStack (alignment: .top) {
                    Text("Calculator")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(.white)
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                .background(.blue)
                VStack () {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("0")
                            .font(.system(size: 52, weight: .medium))
                            .padding(10)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(20)
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.3)
                .background(.red)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, geometry.safeAreaInsets.bottom)
            .ignoresSafeArea(.keyboard)
        }
    }
}

#Preview {
    ContentView()
}
