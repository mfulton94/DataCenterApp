//
//  SettingsViewController.swift
//  DataCenterApp
//
//  Created by Michael Fulton Jr. on 3/31/16.
//  Copyright © 2016 Michael Fulton Jr. All rights reserved.
//
import UIKit
import Firebase

class SettingsViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate, UITableViewDelegate{
    
    @IBOutlet weak var settingsTableView: UITableView!
    @IBAction func startCalculations(sender: UISwitch) {
        if startCalc == true {
            startCalc = false
            
        }
        else {
            startCalc = true
        }
        
        
    }
    let options = ["Building Size (sqft)", "Number of Computers", "Number of People", "Computer Power Usage", "Battery System Rating"]
    let sections = ["Start", "Free Cooling", "Load", "Calculate Load", "Save Data"]

    var userName: String! = ""
    var ref: Firebase!
    var startCalc: Bool!
    var buildingSize: String!
    var computerCount: String!
    var peopleCount: String!
    var wattspc: Int! = 85
    var rating: Int! = 65
    var load: Int!
    var CHWR: Int! = 54
    var CHWS: Int! = 55
    var CTA: String!
    var saveIndexPath: NSIndexPath!
    var fieldsArray: [String!] = []
    var setArray: [String!] = []
    var rowsArray: [NSIndexPath] = []
    var rows: Bool! = false
    var missingFields: String! = ""
    var calcLoadCells: [NSIndexPath] = []
    // if user exists, pull data from db
    // if new user, create new db entry using userName
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
        ref =  Firebase(url: "https://data-center.firebaseio.com/users/\(userName)")
        ref.observeSingleEventOfType(.Value, withBlock: {
            snapShot in
            
            print("I made it")
            
            if snapShot.value is NSNull {
                self.startCalc = false
                self.buildingSize = "38000"
                self.computerCount = "180"
                self.peopleCount = "160"
                self.CTA = ""
                self.load = 30
                
            } else {
                self.startCalc = snapShot.value.objectForKey("start") as! Bool
                self.buildingSize = snapShot.value.objectForKey("buildingSize") as! String
                self.computerCount = snapShot.value.objectForKey("computerCount") as! String
                self.peopleCount = snapShot.value.objectForKey("peopleCount") as! String
                self.CTA = snapShot.value.objectForKey("cta") as! String
                self.load = snapShot.value.objectForKey("load") as! Int
                
            }
            self.rows = true
            self.settingsTableView.reloadData()
            }, withCancelBlock: {
                error in
                print(error.description)
        })
 
       
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if rows! {

        switch section {
        case 0, 1, 2, 4:
            return 1
        case 3:
            return 5
        default:
            return 0
        }
            
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
   fieldsArray = [buildingSize, computerCount, peopleCount]
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("startCell", forIndexPath: indexPath) as! startTableViewCell
            
            
            return cell
        } else if indexPath.section < 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier("fieldCell", forIndexPath: indexPath) as! fieldsTableViewCell
            
            switch indexPath.section {
                case 1:
                    cell.fieldLabel.text = "Cooling Tower Approach"
                    cell.field.delegate = self
                    cell.field.tag = indexPath.section + indexPath.row
                    cell.field.text = CTA
                case 2:
                    cell.fieldLabel.text = "Load (tons)"
                    cell.field.delegate = self
                    cell.field.tag = indexPath.section + indexPath.row
                    cell.field.text = "\(load)"
                default:
                    print("Error")
            }
            
            return cell
        
            
        } else if indexPath.section == 3 {
            if indexPath.row < 3 {
                let cell = tableView.dequeueReusableCellWithIdentifier("fieldCell", forIndexPath: indexPath) as! fieldsTableViewCell
                
                cell.fieldLabel.text = options[indexPath.row]
                cell.field.tag = indexPath.section + indexPath.row
                cell.field.delegate = self
                cell.field.text = fieldsArray[indexPath.row]
                
                
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as! infoTableViewCell
                cell.infoLabel.text = options[indexPath.row]
                switch indexPath.row {
                case 3:
                    cell.valueLabel.text = "\(wattspc)w"
                case 4:
                    cell.valueLabel.text = "\(rating)w"
                default:
                    print("error")
                }
                return cell
            }
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("saveCell", forIndexPath: indexPath) as! saveTableViewCell
            cell.VC = self
            self.saveIndexPath = indexPath
            if buildingSize == "" || peopleCount == "" || computerCount == "" || CTA == "" {
                
               // cell.saveButton.enabled = false
                
                
            } else {
                var data = dataSettingsStruct()
                calculateTons()
                data.userName = userName
                data.buildingSize = buildingSize
                data.computerCount = computerCount
                data.peopleCount = peopleCount
                data.load = load
                data.CTA = CTA
                data.start = self.startCalc
                // cell.saveButton.enabled = false
                cell.data = data
                
                
            }
            
            return cell

            
        }
     
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let save = saveIndexPath {
        if indexPath == save {
            let ncell = cell as! saveTableViewCell
            
            if buildingSize == "" || peopleCount == "" || computerCount == "" || CTA == "" {
             
                
                 //ncell.saveButton.tintColor =
                ncell.contentView.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
                //ncell.saveButton.enabled = false
            } else {
                   ncell.contentView.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
                //ncell.saveButton.enabled = true
            }
            
            }
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
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
      /*  let cell = self.settingsTableView.cellForRowAtIndexPath(self.saveIndexPath) as! saveTableViewCell
        if buildingSize == "" || peopleCount == "" || computerCount == "" {
            cell.saveButton.tintColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
            cell.saveButton.enabled = false
            
        } else {
            var data = dataSettingsStruct()
            calculateTons()
            data.userName = userName
            data.buildingSize = buildingSize
            data.computerCount = computerCount
            data.peopleCount = peopleCount
            data.load = load
            cell.saveButton.tintColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
             cell.saveButton.enabled = false
            cell.data = data
        }*/
        switch textField.tag{
            
        case 1:
            if let text = textField.text {
                if CTA != text {
                    CTA = text
                    calculateTons()
                    self.settingsTableView.reloadData()
                }
                
                // save to database
            }
        case 2:
            if let text = textField.text {
                if "\(load)" != text {
                    load = Int(text)
                    
                    self.settingsTableView.reloadData()
                }
                
                // save to database
            }
            
        case 3:
            if let text = textField.text {
                if buildingSize != text {
                    buildingSize = text
                    calculateTons()
                     self.settingsTableView.reloadData()
                }
                
        // save to database
            }
            
            
        case 4:
            
            if let text = textField.text {
                if computerCount != text {
                    
                computerCount = text
                    calculateTons()
                    self.settingsTableView.reloadData()
                }
            }
        case 5:
            if let text = textField.text {
                if peopleCount != text {

                peopleCount = text
                    calculateTons()
                    self.settingsTableView.reloadData()
                }
            }
            
        default:
            print("There is an Error")
        }
        
       
      
    }
    
    func calculateTons() {
        
        
        let itEquipment = Int(wattspc) * Int(computerCount)!
        let ups = (0.04 * Double(rating)) + (0.05 * Double(itEquipment))
        let powerDist = (0.01 * Double(rating)) + (0.02 * Double(itEquipment))
        let sqFootLighting = Int(buildingSize)! * 2
        let peopleWattage = Int(peopleCount)! * 100
        var total = Double(itEquipment) + ups
            total += powerDist + Double(sqFootLighting)
            total += Double(peopleWattage)
        let btuhr = Double(total) * 3.41
        let gpm = btuhr / (Double(CHWR - CHWS) * 500.0)
        load = Int(gpm * Double(CHWR - CHWS) / 24)
        
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
