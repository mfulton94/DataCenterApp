//
//  ListViewController.swift
//  
//
//  Created by Michael Fulton Jr. on 3/20/16.
//
//

import UIKit
import Lock
import SwiftyJSON
import Firebase
import Foundation
//import AirshipKit


class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBAction func logout(sender: UIBarButtonItem) {
        let url = NSURL(string: "https://manhattancollege.auth0.com/v2/logout")
        UIApplication.sharedApplication().openURL(url!)
    }

    // Outlets
    // MARK: - Outlets
    @IBOutlet weak var menuTableView: UITableView!
    
    let zipcode = "10471"
    var disabled: Bool! = false
    let dataCenter = DataCenter()
    let test: AnyObject? = ""
    var timer: NSTimer!
    var counter: Int! = 0
    var dataNowArray: [DataNow] = []
    
    // Variable
    // MARK: - Variables
    var controller: A0LockViewController = A0Lock.sharedLock().newLockViewController()
    var userName: String!
    var userSettings: dataSettingsStruct! = dataSettingsStruct()
    let menuItems: [String] = ["Chiller", "Cold Water Pump", "Chilled Water Pump", "Cooling Tower", "Settings"]
    var row: Int! = 0
    enum colors {
        case OK, Alert, Other
        func rawColor() -> UIColor {
            switch self {
            case .OK:
                return UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
            case .Alert:
                return UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
            case .Other:
                return UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1.0)
            }
        }
    }
    
    
    // General Functions
    // MARK: - General
    override func viewDidLoad() {
        super.viewDidLoad()
        if row == 0 {
            self.menuTableView.hidden = true
        }
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(self.runData), userInfo:nil , repeats: true)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = false
        print("I was called")
        controller.closable = false
        controller.disableSignUp = true
        
        controller.onAuthenticationBlock = { (profile, token) in
            let name = profile!.name.componentsSeparatedByString(".")[0]
            self.navigationItem.title = name
            self.row = self.menuItems.count
            self.menuTableView.reloadData()
            self.menuTableView.hidden = false
            self.userName = profile!.userId.componentsSeparatedByString("|")[1]
            self.timer.fire()
            self.dismissViewControllerAnimated(true, completion: nil)
       
        }
        self.presentViewController(controller, animated: true, completion: nil)
        
        //let urlString = "api.openweathermap.org/data/2.5/weather?appid=4652c4e97586b04cd55827cab31b4ec1&zip=\(zipcode),us&units=imperial"
        
       /* if let url = NSURL(string: urlString){
            let data = NSData(contentsOfURL: url)
               // let json = JSON(data: data!)
                let temp = 30
                print(temp)
                if temp > 20 {
                    print("I was here")
                    disabled = true
                } else {
                    disabled = false
                }
                
                
            }*/
        
        
        

    }
    
    func runData(){
        /*
         "CHWS (Chilled Water Supply)": 44,
         "CHWR (Chilled Water Returned)": 53,
         "CWS (Condenser Water Supply)": 79,
         "CWR (Condeser Water Returned)": 89,
 
        */
        var temps = ["Time", "CHWS (Chilled Water Supply)", "CHWR (Chilled Water Returned)", "CWS (Condenser Water Supply)", "CWR (Condeser Water Returned)"]
        var data = DataNow()
      
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        
        for val in temps {
            
            let value = dataCenter.data[counter][val]
            
            
            switch val {
                case "CHWS (Chilled Water Supply)":
                    data.CHWS = "\(value)"
                case "CHWR (Chilled Water Returned)":
                data.CHWR = "\(value)"
                
                case "CWS (Condenser Water Supply)":
                data.CWS = "\(value)"
                
                case "CWR (Condeser Water Returned)":
                data.CWR = "\(value)"
            default:
                
                data.time = (value as! String).componentsSeparatedByString(" ")[1]
                
                
            }
        }
        dataNowArray.append(data)
        
        counter = counter + 1
        if counter == dataCenter.data.count{
        timer.invalidate()
        }
        
        
        
    }

    // Table View Data Source Functions
    /* Functions Directory:
        - numberOfSectionsInTableView(UITableVIew) -> Int
            return the number of sections in table view
     
        - tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
            return the number of rows in section
            Class Objects Used: (NSArray)menuItems
     
        - tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
            return the cell to view
            gets called every time a cell is returned or removed from tableview
            Class Objects Used = (NSArray)menuItems, (enum)colors
     */
    // MARK: - TableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return row
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) as! menuTableViewCell
        
          
            
        
        cell.menuLabel.text = menuItems[indexPath.row]
        if indexPath.row == 4 {
            cell.contentView.backgroundColor = colors.Other.rawColor()
        } else {
            // TODO: Color Change
            // Perform condition for color change based on the conditions of the algorithms
            if disabled  == true {
                print("I cant")
                cell.selectionStyle = .None
            }
        }
    
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 4 {
            performSegueWithIdentifier("presentSettingsView", sender: nil)
        } else {
               performSegueWithIdentifier("presentDetailView", sender: nil)
        }
          tableView.deselectRowAtIndexPath(menuTableView.indexPathForSelectedRow!, animated: false)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
      
        if segue.identifier == "presentDetailView" {
            
            let value = menuTableView.indexPathForSelectedRow!.row
            (segue.destinationViewController as! DetailViewController).selectedComponent = menuItems[value]
            (segue.destinationViewController as! DetailViewController).dataArray = dataNowArray
      
        } else if segue.identifier == "presentSettingsView" {
            
            (segue.destinationViewController as! SettingsViewController).userName = self.userName
        }
        
        
    
        
    }
    
    
    

   
    

}
