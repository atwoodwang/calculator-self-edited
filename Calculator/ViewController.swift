//
//  ViewController.swift
//  Calculator
//
//  Created by Martin Mandl on 26.01.15.
//  Copyright (c) 2015 m2m server software gmbh. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        //println("digit = \(digit)");
        
        if userIsInTheMiddleOfTypingANumber {
            if (digit == ".") && (display.text!.rangeOfString(".") != nil) { return }
            if (digit == "0") && (display.text == "0") { return }
            if (digit != ".") && (display.text == "0") {
                display.text = digit
            } else {
                display.text = display.text! + digit
            }
        } else {
            if digit == "." {
                display.text = "0."
            } else {
                display.text = digit
            }
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                // error?
                displayValue = 0
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            // error?
            displayValue = 0
        }
    }
    

    @IBAction func backspace() {
        if userIsInTheMiddleOfTypingANumber {
            let displayText=display.text!
            if count(displayText)>1 {
                display.text=dropLast(displayText)
                if (count(displayText) == 2) && (display.text?.rangeOfString("-") != nil) {
                    display.text = "-0"
                }
            }else{
                display.text="0"
            }
        }
    }
    
    
    
    
    @IBAction func clear() {
        brain = CalculatorBrain()
        displayValue = 0
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
            history.text = brain.showStack()
        }
    }
}

