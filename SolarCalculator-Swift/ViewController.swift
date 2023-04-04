//
//  ViewController.swift
//  SolarCalculator-Swift
//
//  Created by Ryan Wright-Zinniger on 4/3/23.
//  Copyright © 2023 Ryan Zinniger. All rights reserved.
//

import Cocoa


class ViewController: NSViewController {
    
    @IBOutlet var viewHome: NSView!
    
    @IBOutlet var labelTitle: NSTextField!
    
    @IBOutlet var labelEnergy: NSTextField!
    @IBOutlet var labelCost: NSTextField!
    
    @IBOutlet var textName: NSTextField!
    @IBOutlet var textAddress: NSTextField!
    
    @IBOutlet var numJanEnergy: NSTextField!
    @IBOutlet var numJanCost: NSTextField!
    @IBOutlet var numFebEnergy: NSTextField!
    @IBOutlet var numFebCost: NSTextField!
    @IBOutlet var numMarEnergy: NSTextField!
    @IBOutlet var numMarCost: NSTextField!
    
    @IBOutlet var buttonRunTool: NSButton!
    
    @IBOutlet var labelResults: NSTextField!
    @IBOutlet var labelEnergyArray: NSTextField!
    @IBOutlet var labelCostArray: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set background image
        self.view.wantsLayer = true
        let image = NSImage(named: "bg-masthead")
        self.view.layer!.contents = image
        // Fill out Title Label
        labelTitle.stringValue = "TheSolarCalculator"
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    // Main funciton for running the tool
    @IBAction func displayResults(_ sender: Any) {
        // Get user's user data, verify it, and write it to results
        let name = textName.stringValue
        let address = textAddress.stringValue
        let inputStr = getUserInfo(name: name, address: address)
        updateLabel(label: labelResults, value: inputStr)
        
        // Get user's energy data, verify it, and write it to results
        let energyDbl = [
            numJanEnergy.doubleValue,
            numFebEnergy.doubleValue,
            numMarEnergy.doubleValue
        ]
        updateLabel(
            label: labelEnergyArray,
            value: getUserStringArray(energyDbl, sep: "kWh, ", type: "Energy")
        )
        
        // Get user's cost data, verify it, and write it to results
        let costDbl = [
            numJanCost.doubleValue,
            numFebCost.doubleValue,
            numMarCost.doubleValue
        ]
        updateLabel(
            label: labelCostArray,
            value: getUserStringArray(costDbl, sep: ", $", type: "Cost")
        )
    }
    
    func getUserInfo(name: String, address: String) -> String {
        // Return string of the user info or a warning if inputs are invalid.
        if (name == "" || address == "") {
            return "WARNING: You did not enter Name and/or Address!"
        } else {
            return name + " lives at " + address + "."
        }
    }
    
    func getUID(name: String) -> String {
        // Generate UID for  potential AWS Lambda and DynamoDB calls.
        let timestamp = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .short
        
        return name.replacingOccurrences(of: " ", with: "") + formatter.string(from: timestamp).replacingOccurrences(of: " ", with: "")
    }
    
    func checkDoubleArray(array: Array<Double>) -> Bool {
        // Iterate through array and ensure that all values are acceptable (> 0).
        for elem in array {
            if (elem <= 0) {
                return false
            }
        }
        
        return true
    }
    
    func getUserStringArray(_ array: Array<Double>, sep: String, type: String) -> String {
        // Return results string. This will be a warning if arary has errant values or an appropriate string with values.
        let verifiedArray = checkDoubleArray(array: array)
        if !(verifiedArray) {
            return "WARNING: \(type) values need to be numerical and greater than zero!"
        }
        
        let stringArray = array.map { String($0) }
        if (type == "Cost") {
            return "$" + stringArray.joined(separator: sep)
        } else {
            return stringArray.joined(separator: sep) + "kWh"
        }
    }
    
    func updateLabel(label: NSTextField, value: String) {
        label.stringValue = value.description
    }

    
    func calculateResults(uid: String, energy: Array<Double>, cost: Array<Double>) {
        // This funciton would invoke AWS Lambda function if AWS SDK was compatible with Swift 4.
        let data: [String : Any] = [
            "uid": uid,
            "energy": energy,
            "cost": cost
            ]
        
        // let lambda = AWSLambda.defaultLambda()
        // let invocationRequest = AWSLambdaInvocationRequest()
        // invocationRequest.functionName = "sc-be"
        // invocationRequest.invocationType = AWSLambdaInvocationType.RequestResponse
        // invocationRequest.payload = data

        // let lambdaInvoker = AWSLambdaInvoker.defaultLambdaInvoker()
        // let task = lambdaInvoker.invoke(invocationRequest).continueWithSuccessBlock() { (task) -> AWSTask! in
        //      print("response: ", task.result)
        // }

        // return task

    }
}
