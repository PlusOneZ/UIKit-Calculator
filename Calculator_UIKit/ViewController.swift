//
//  ViewController.swift
//  Calculator_UIKit
//
//  Created by Zhengyi on 2021/5/6.
//

import UIKit

extension Double {
    var cleanZero : String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%g", self)
    }
}


class ViewController: UIViewController {

    @IBOutlet weak var result: UILabel!
    var currentOperator:String = ""
    var currentResult:Double = 0.0
    var lastEvaluate:Bool = false
    var lastOperate:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func clickNumber(_ sender: UIButton) {
        if lastOperate || lastEvaluate {
            result.text = ""
        }
        if result.text == "0" {
            result.text = ""
        }
        result.text = result.text! + String(sender.titleLabel?.text ?? "")
        lastEvaluate = false
        lastOperate = false
    }
    
    @IBAction func clickOperator(_ sender: UIButton) {
        switch sender.titleLabel?.text {
        case "AC":
            result.text = "0"
            lastOperate = false
            lastEvaluate = false
            currentOperator = ""
            currentResult = 0
            break
        case "±":
            if result.text != nil && String(result.text ?? " ").starts(with: "-") {
                let s:String = result.text ?? " "
                let offset = s.index(s.startIndex, offsetBy: 1)
                result.text = String(s[offset...])
            } else if result.text == "0" {
                // Do nothing
            }else {
                result.text = "-" + (result.text ?? "1")
            }
            break
        case "%":
            if (result.text != nil) {
                var temp = Double(result.text ?? "0")
                temp = (temp ?? 0) / 100
                result.text = String(temp ?? 0)
                lastEvaluate = true
            }
            break
        case "÷", "×", "–", "+":
            if (currentOperator != "") {
                evaluate()
            }
            currentOperator = sender.titleLabel?.text ?? ""
            currentResult = Double(result.text ?? "nil") ?? 0
            lastOperate = true
            break
        case "=":
            evaluate()
            lastOperate = true
            currentOperator = ""
            break
        default:
            print("???????")
        }
    }
    
    func calculate() -> Double? {
        if (result.text == nil || result.text == "") {
            return nil
        }
        let oprand = Double(result.text ?? "?")
        if (oprand == nil) {
            return nil
        }
        
        switch currentOperator {
        case "÷":
            return currentResult / (oprand ?? 1)
        case "×":
            return currentResult * (oprand ?? 1)
        case "+":
            return currentResult + (oprand ?? 0)
        case "–":
            return currentResult - (oprand ?? 0)
        default:
            return Double(result.text ?? "0")
        }
    }
    
    func evaluate() {
        let res:Double? = calculate()
        if (res == nil || res == Double.infinity || res == -Double.infinity) {
            result.text = "Error"
        } else {
            result.text = (res ?? 0.0).cleanZero
            currentResult = res ?? 0
        }
        lastEvaluate = true
    }
}

