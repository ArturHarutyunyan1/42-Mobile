
import SwiftUI

struct ContentView: View {
    @State private var value: String = "0"
    
    let buttons: [[String]] = [
        ["AC", "plus.slash.minus", "percent", "divide"],
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
                                    handleClick(input: btn)
                                }) {
                                    if (Int(btn) != nil || btn == "." || btn == "AC") {
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
    func handleClick(input: String) {
        switch input {
        case "AC":
            value = "0"
            break
        case "delete.left":
            if value != "0" {
                if value == "Error" {
                    value = "0"
                } else {
                    value.removeLast()
                    if (value == "") {
                        value = "0"
                    }
                }
            }
        case "plus.slash.minus":
            if value != "0" {
                if Double(value)! > 0 {
                    value = "-" + value
                } else {
                    if let index = value.firstIndex(of: "-") {
                        value.remove(at: index)
                    }
                }
            }
        case "percent":
            if value != "0" {
                if let number = Double(value) {
                    value = String(number / 100)
                } else {
                    value = "Error"
                }
            }
            break
        case "divide":
            if value != "0" {
                checkLast(op: "÷")
            }
            break
        case "multiply":
            if value != "0" {
                checkLast(op: "×")
            }
            break
        case "minus":
            if value != "0" {
                checkLast(op: "-")
            }
            break
        case "plus":
            if value != "0" {
                checkLast(op: "+")
            }
            break
        case ".":
            if !value.contains(".") {
                value.append(".")
            }
            break
        case "equal":
            if let lastChar = value.last {
                if !isOperator(lastChar) {
                    value = handleCalculation(input: value)
                }
            }
            break
        default:
            if value == "Error" {
                value = "0"
            }
            if value == "0" {
                value = input
            } else {
                value += input
            }
            break
        }
        func isOperator(_ input: Character) -> Bool {
            if input == "+" || input == "-" || input == "×" || input == "÷" {
                return true
            }
            return false
        }
        func checkLast(op: Character) {
            if let last = value.last {
                if isOperator(last) {
                    value.removeLast()
                    value.append(op)
                } else {
                    value.append(op)
                }
            }
        }
        func handleCalculation(input: String) -> String {
            var input = input
            
            input = input.replacingOccurrences(of: "×", with: "*")
            input = input.replacingOccurrences(of: "÷", with: "/")
            
            if input.contains("/0") {
                return "Error"
            }
            
            let expression = NSExpression(format: input)
            if let value = expression.expressionValue(with: nil, context: nil) as? NSNumber {
                return value.stringValue
            } else {
                return "Error"
            }
        }
    }
}

#Preview {
    ContentView()
}
