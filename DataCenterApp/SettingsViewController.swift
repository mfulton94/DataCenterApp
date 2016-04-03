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
        
    }
    let options = ["Start Calculations", "Building Size (sqft)", "Number of Computers", "Number of People", "Computer Power Usage", "Battery System Rating"]
    var userName: String!
    var startCalc: Bool!
    var buildingSize: Int!
    var computerCount: Int!
    var peopleCount: Int!
    
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
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("startCell", forIndexPath: indexPath) as! startTableViewCell
            
            
            return cell
        } else if indexPath.row < 4 {
            let cell = tableView.dequeueReusableCellWithIdentifier("fieldCell", forIndexPath: indexPath) as! fieldsTableViewCell
            
            cell.fieldLabel.text = options[indexPath.row]
            cell.field.delegate = self
            
            
            return cell
            
        } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as! infoTableViewCell
             cell.infoLabel.text = options[indexPath.row]
             cell.valueLabel.text = "65 W"
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
        return true
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
