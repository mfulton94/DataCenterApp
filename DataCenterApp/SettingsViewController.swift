//
//  SettingsViewController.swift
//  DataCenterApp
//
//  Created by Michael Fulton Jr. on 3/31/16.
//  Copyright © 2016 Michael Fulton Jr. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var settingsTableView: UITableView!
    @IBAction func startCalculations(sender: UISwitch) {
        if startCalc == true {
            startCalc = false
        }
        else {
            startCalc = true
        }
        
        
    }
    let options = ["Start Calculations", "Building Size (sqft)", "Number of Computers", "Number of People", "Computer Power Usage", "Battery System Rating", "Tons"]
    var userName: String!
    var startCalc: Bool! = false
    var buildingSize: Int! = 38000
    var computerCount: Int! = 180
    var peopleCount: Int! = 160
    var wattspc: Int! = 85
    var rating: Int! = 65
    var tons: Int! = 31
    var CHWR: Int!
    var CHWS: Int!
    // if user exists, pull data from db
    // if new user, create new db entry using userName
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("startCell", forIndexPath: indexPath) as! startTableViewCell
            
            
            return cell
        } else if indexPath.row < 4 {
            let cell = tableView.dequeueReusableCellWithIdentifier("fieldCell", forIndexPath: indexPath) as! fieldsTableViewCell
            
            cell.fieldLabel.text = options[indexPath.row]
            cell.field.tag = indexPath.row
            cell.field.delegate = self
            
            
            return cell
            
        } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as! infoTableViewCell
            // Condition statement, check indexpath.row
             cell.infoLabel.text = options[indexPath.row]
            switch indexPath.row {
                case 4:
                  cell.valueLabel.text = "\(wattspc)"
                case 5:
                  cell.valueLabel.text = "\(rating)"
                default:
                  cell.valueLabel.text = "\(tons)"
            }
            return cell
        }
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        print("I made it")
        // Create an `NSCharacterSet` set which includes everything *but* the digits
        let inverseSet = NSCharacterSet(charactersInString:"0123456789").invertedSet
        
        // At every character in this "inverseSet" contained in the string,
        // split the string up into components which exclude the characters
        // in this inverse set
        let components = string.componentsSeparatedByCharactersInSet(inverseSet)
        
        // Rejoin these components
        let filtered = components.joinWithSeparator("")  // use join("", components) if you are using Swift 1.2
        
        // If the original string is equal to the filtered string, i.e. if no
        // inverse characters were present to be eliminated, the input is valid
        // and the statement returns true; else it returns false
        return string == filtered
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("I made it part 2")
        self.settingsTableView.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        print(textField.tag)
        switch textField.tag{
            case 1:
                if let text = textField.text {
                    buildingSize = Int(text)
                    // save to database
                }
       
           
            case 2:
            if let text = textField.text {
                computerCount = Int(text)
            }
            default:
            if let text = textField.text {
                peopleCount = Int(text)
            }
        }
        return true
    }
    
    func calculateTons() {
        
        
        let itEquipment = wattspc * computerCount
        let ups = (0.04 * Double(rating)) + (0.05 * Double(itEquipment))
        let powerDist = (0.01 * Double(rating)) + (0.02 * Double(itEquipment))
        let sqFootLighting = buildingSize * 2
        let peopleWattage = peopleCount * 100
        var total = Double(itEquipment) + ups
            total += powerDist + Double(sqFootLighting)
            total += Double(peopleWattage)
        let btuhr = Double(total) * 3.41
        let gpm = btuhr / (Double(CHWR - CHWS) * 500.0)
        tons = Int(gpm * Double(CHWR - CHWS) / 24)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
