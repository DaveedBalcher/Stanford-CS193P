//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by David Balcher on 5/18/15.
//  Copyright (c) 2015 Xpressive. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Result: Printable {
        case Value(Double)
        case Error(String)
        
        var description: String {
            get{
                switch self {
                case .Value(let value):
                    return "\(value)"
                case .Error(let errorMessage):
                    return errorMessage
                }
            }
        }
    }
    
    
    
    private enum Op: Printable {
        case Variable(String)
        case Operand(Double)
        case NullaryOperation(String, Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get{
                switch self {
                case .Variable(let symbol):
                    return "\(symbol)"
                case .Operand(let operand):
                    return "\(operand)"
                case .NullaryOperation(let symbol, _):
                    return symbol
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    //  public property to allow setting of variables
    var variableValues = [String: Double]()
    
    init() {
        func learnOp(operation: Op) {
            knownOps[operation.description] = operation
        }
        
        learnOp(Op.BinaryOperation("+", + ))
        learnOp(Op.BinaryOperation("-") { $1 - $0 })
        learnOp(Op.BinaryOperation("×", * ))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.UnaryOperation("√", sqrt ))
        learnOp(Op.UnaryOperation("SIN", sin ))
        learnOp(Op.UnaryOperation("COS", cos ))
        learnOp(Op.NullaryOperation("pi", 3.14 ))
    
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList //garenteed to be a property list
        {
        get {
            return opStack.map() { $0.description }
        }
        set {
            
            if let opSymbols = newValue as? [String] {
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    
    
    
    private func evaluate(ops: [Op]) -> (result: Result, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Variable(let symbol):
                if let value = variableValues[symbol] {
                    return (.Value(value), remainingOps)
                }
                return (.Error("Error: Did not set variable \(symbol)"), remainingOps)
                
            case .Operand(let operand):
                return (.Value(operand), remainingOps)

            case .NullaryOperation(_, let value):
                return (.Value(value), remainingOps)
                
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    switch result{
                    case .Value:
                        return (operation(operand), operandEvaluation.remainingOps)
                    }
                }
                
            case .BinaryOperation(_, let operation):
                let firstOpEvaluation = evaluate(remainingOps)
                if let operand1 = firstOpEvaluation.result {
                    let secondOpEvaluation = evaluate(firstOpEvaluation.remainingOps)
                    if let operand2 = secondOpEvaluation.result {
                        return (.Value(operation(operand1, operand2)), secondOpEvaluation.remainingOps)
                    }
                }
            }
        }
        return (.Error("0"), ops)
    }
    
    
    func evaluate() -> Double? {
        let (result, remaining) = evaluate(opStack)
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? {
        if let operand = variableValues[symbol] {
            opStack.append(Op.Operand(operand))
        }
        return evaluate()
    }
    
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func display() -> [String] {
        var opStrings = [String]()
        for ops in opStack {
            opStrings.append("\(ops)")
        }
        return opStrings
    }
    
    func removeLastOp() {
        if(!opStack.isEmpty) {
            opStack.removeLast()
        }
    }
    
    
    func clear() {
    opStack.removeAll(keepCapacity: false)
    }
}
