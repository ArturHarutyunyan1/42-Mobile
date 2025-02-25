//
//  CalculatorView.swift
//  calculator_app
//
//  Created by Artur Harutyunyan on 24.02.25.
//

import SwiftUI


class CalculatorViewModel: ObservableObject {
    @Published var value: String = "0"
    
    func handleClick(input: String) {
        switch input {
        case "AC":
            value = "0"
        case "delete.left":
            if value != "0" {
                if value == "Error" {
                    value = "0"
                } else {
                    value.removeLast()
                    if value.isEmpty {
                        value = "0"
                    }
                }
            }
        case "plus.slash.minus":
            if value != "0" && value != "Error" {
                var operandRange: Range<String.Index>
                
                if value.last == ")" {
                    var count = 0
                    var index = value.index(before: value.endIndex)
                    var startIndex: String.Index? = nil
                    while true {
                        let char = value[index]
                        if char == ")" {
                            count += 1
                        } else if char == "(" {
                            count -= 1
                            if count == 0 {
                                startIndex = index
                                break
                            }
                        }
                        if index == value.startIndex { break }
                        index = value.index(before: index)
                    }
                    if let startIndex = startIndex {
                        operandRange = startIndex..<value.endIndex
                    } else {
                        operandRange = value.startIndex..<value.endIndex
                    }
                } else {
                    var start = value.endIndex
                    while start > value.startIndex {
                        let prevIndex = value.index(before: start)
                        if isOperator(value[prevIndex]) {
                            break
                        }
                        start = prevIndex
                    }
                    operandRange = start..<value.endIndex
                }
                
                let operand = String(value[operandRange])
                
                if operand.hasPrefix("(-") && operand.hasSuffix(")") {
                    let strippedOperand = operand.dropFirst(2).dropLast()
                    value.replaceSubrange(operandRange, with: strippedOperand)
                } else {
                    let newOperand = "(-" + operand + ")"
                    value.replaceSubrange(operandRange, with: newOperand)
                }
            }

        case "percent":
            if let number = Double(value) {
                value = String(number / 100)
            } else {
                value = "Error"
            }
        case "divide":
            checkLast(op: "÷")
        case "multiply":
            checkLast(op: "×")
        case "minus":
            checkLast(op: "-")
        case "plus":
            checkLast(op: "+")
        case ".":
            if !value.contains(".") {
                value.append(".")
            }
        case "equal":
            if let lastChar = value.last, !isOperator(lastChar) {
                value = handleCalculation(input: value)
            }
        default:
            if value == "Error" {
                value = "0"
            }
            value = (value == "0") ? input : value + input
        }
    }
    
    private func isOperator(_ input: Character) -> Bool {
        return ["+", "-", "×", "÷"].contains(input)
    }
    
    private func checkLast(op: Character) {
        if let last = value.last, isOperator(last) {
            value.removeLast()
        }
        value.append(op)
    }
    
    private func handleCalculation(input: String) -> String {
        let input = input.replacingOccurrences(of: "×", with: "*")
                         .replacingOccurrences(of: "÷", with: "/")
        
        if input.contains("/0") { return "Error" }
        
        let expression = NSExpression(format: input)
        return (expression.expressionValue(with: nil, context: nil) as? NSNumber)?.stringValue ?? "Error"
    }
}
