//
//  ViewControllerResults.swift
//  SolarCalculator-Swift
//
//  Created by Ryan Wright-Zinniger on 4/4/23.
//  Copyright © 2023 Ryan Zinniger. All rights reserved.
//

import Cocoa
import ViewCon

class ViewControllerResults: NSViewController {
    
    @IBOutlet var viewResults: NSView!
    @IBOutlet var labelTitle: NSTextField!
    
    @IBOutlet var labelResults: NSTextField!
    @IBOutlet var labelEnergyArray: NSTextField!
    @IBOutlet var labelCostArray: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        let image = NSImage(named: "bg-output")
        self.view.layer!.contents = image
        
        labelTitle.stringValue = "Results"
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func displayResults(_ sender: Any) {
        let userInput = getUserInfo()
        updateLabel(label: labelResults, value: userInput)
        
        let energy = [numJanEnergy.doubleValue, numFebEnergy.doubleValue, numMarEnergy.doubleValue]
        let userEnergy = getUserStringArray(energy, sep: "kWh, ") + "kWh"
        updateLabel(label: labelEnergyArray, value: userEnergy)
        
        let cost = [numJanCost.doubleValue, numFebCost.doubleValue, numMarCost.doubleValue]
        let userCost = "$" + getUserStringArray(cost, sep: ", $")
        updateLabel(label: labelCostArray, value: userCost)
        
        
    }
    
    func getUserInfo() -> String{
        let timestamp = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .short
        
        
        let name = textName.stringValue
        let address = textAddress.stringValue
        
        let uid = name + formatter.string(from: timestamp)
        
        return uid + " lives at " + address + "."
    }
    
    func getUserStringArray(_ array: Array<Double>, sep: String) -> String {
        
        let stringArray = array.map { String($0) }
        
        return stringArray.joined(separator: sep)
    }
    
    
    func updateLabel(label: NSTextField, value: String) {
        label.stringValue = value.description
    }
}
