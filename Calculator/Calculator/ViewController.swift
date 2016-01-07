//
//  ViewController.swift
//  Calculator
//
//  Created by David Balcher on 5/14/15.
//  Copyright (c) 2015 Xpressive. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    
    var userIsInTheMiddleOfTypingNumber = false
    
    let brain = CalculatorBrain()
    var decimalsEntered = 0

    @IBAction func selectDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if(digit == ".") {
            decimalsEntered++
        }
        if(decimalsEntered < 2 || digit != "."){
            if(userIsInTheMiddleOfTypingNumber) {
                display.text = display.text! + "\(digit)"
            } else {
                display.text = "\(digit)"
                decimalsEntered = 0
                userIsInTheMiddleOfTypingNumber = true
            }
        }
        if settingAVariable {
            brain.variableValues[currentVariable] = displayValue
        }
    }
    
    @IBAction func selectOperator(sender: UIButton) {
        if(userIsInTheMiddleOfTypingNumber) {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result =  brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
        var currentVariable = ""
        var settingAVariable = false

    
    @IBAction func selectVariable(sender: UIButton) {
        if(userIsInTheMiddleOfTypingNumber) {
            enter()
        }
        if let variable = sender.currentTitle {
            if let operand = brain.variableValues[variable] {
                display.text = "\(operand)"
            } else {
                settingAVariable = true
                currentVariable = variable
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingNumber = false
        if displayValue != nil {
            if let result = brain.pushOperand(displayValue!) {
                displayValue = result
            } else {
                displayValue = 0
            }
        } else {
            display.text = "Error"
        }
    }
    
    @IBAction func backSpace() {
        brain.removeLastOp()
    }

    @IBAction func clear() {
        displayValue = 0
        history.text = ""
        brain.clear()
    }
    
    var displayValue: Double? {
        get {
            if let value = NSNumberFormatter().numberFromString(display.text!) {
                return value.doubleValue
            } else {
                return nil
            }
        }
        set {
            if newValue == nil {
                display.text = ""
            } else {
                display.text = "\(newValue!)"
                userIsInTheMiddleOfTypingNumber = false
            }
        }
    }
    
    var historyString: String {
        get {
            var opString = ""
            let opArray = brain.display()
            for ops in opArray {
                opString += ops + " "
            }
            opString += " ="
            return opString
        }
    }
    
//    var historyDisplay: String {
//        get {
//            return history.text!
//        }
//        set {
//            if newValue == "" {
//                history.text = ""
//            } else {
//                history.text = "\(newValue) "
//            }
//        }
//    }
    
}

