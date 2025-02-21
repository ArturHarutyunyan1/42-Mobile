import SwiftUI

struct ContentView: View {
    @State private var value: String = "0"
    @State private var result: Float = 0
    
    let buttons: [[String]] = [
        ["clear", "plus.slash.minus", "percent", "divide"],
        ["7", "8", "9", "multiply"],
        ["4", "5", "6", "minus"],
        ["1", "2", "3", "plus"],
        ["delete.left","0", ".", "equal"]
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                HStack (alignment: .top) {
                    Text("Calculator")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(.white)
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                .background(Color.black)
                VStack () {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("\(value)")
                            .font(.custom("Helvetica Neue", size: 52))
                            .foregroundStyle(Color.white)
                            .padding(10)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(20)
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.3)
                .background(Color.black)
                
                VStack {
                    Spacer()
                    ForEach(buttons, id: \.self) { row in
                        HStack(spacing: 10) {
                            ForEach(row, id: \.self) { btn in
                                Button(action: {
                                    print("\(btn)")
                                }) {
                                    if (Int(btn) != nil || btn == ".") {
                                        Text(btn)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .contentShape(Rectangle())
                                            .foregroundStyle(.white)
                                            .font(.system(size: 28))
                                    } else {
                                        Image(systemName: btn)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .contentShape(Rectangle())
                                            .foregroundStyle(.white)
                                            .font(.system(size: 28))
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .foregroundStyle(Color.white)
                                .font(.system(size: 24, weight: .bold))
                                .cornerRadius(50)
                            }
                        }
                        .frame(width: geometry.size.width * 0.9)
                        .padding(3)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.6)
                .background(Color.gray)
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
