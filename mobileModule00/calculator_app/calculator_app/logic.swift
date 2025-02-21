//
//  logic.swift
//  calculator_app
//
//  Created by Artur Harutyunyan on 22.02.25.
//

import Foundation

class CalculatorLogic {
    func handleClick(input: String, currentValue: String) -> String {
        var value = currentValue

        switch input {
        case "AC":
            return "0"
        case "delete.left":
            if value != "0" {
                if value == "Error" {
                    return "0"
                } else {
                    value.removeLast()
                    if value.isEmpty {
                        return "0"
                    }
                }
            }
        case "plus.slash.minus":
            if value != "0" {
                if Double(value)! > 0 {
                    return "-" + value
                } else {
                    if let index = value.firstIndex(of: "-") {
                        value.remove(at: index)
                    }
                }
            }
        case "percent":
            if let number = Double(value) {
                return String(number / 100)
            } else {
                return "Error"
            }
        case "divide":
            return value != "0" ? value + "÷" : value
        case "multiply":
            return value != "0" ? value + "×" : value
        case "minus":
            return value != "0" ? value + "-" : value
        case "plus":
            return value != "0" ? value + "+" : value
        case ".":
            return !value.contains(".") ? value + "." : value
        case "equal":
            return handleCalculation(input: value)
        default:
            return value == "0" ? input : value + input
        }

        return value
    }

    private func handleCalculation(input: String) -> String {
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
