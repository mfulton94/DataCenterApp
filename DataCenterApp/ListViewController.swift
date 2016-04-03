//
//  ListViewController.swift
//  
//
//  Created by Michael Fulton Jr. on 3/20/16.
//
//

import UIKit
import Lock


class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBAction func logout(sender: UIBarButtonItem) {
        let url = NSURL(string: "https://manhattancollege.auth0.com/v2/logout")
        UIApplication.sharedApplication().openURL(url!)
    }

    // Outlets
    // MARK: - Outlets
    @IBOutlet weak var menuTableView: UITableView!
    
    // Variables
    // MARK: - Variables
    var controller: A0LockViewController = A0Lock.sharedLock().newLockViewController()
    var userName: String!
    let menuItems: [String] = ["Compressor", "Cold Water Pump", "Chilled Water Pump", "Cooling Tower", "Settings"]
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
            

            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        self.presentViewController(controller, animated: true, completion: nil)

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
        return menuItems.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) as! menuTableViewCell
        
        cell.menuLabel.text = menuItems[indexPath.row]
        if indexPath.row == 4 {
            cell.contentView.backgroundColor = colors.Other.rawColor()
        } else {
            // TODO: Color Change
            // Perform condition for color change based on the conditions of the algorithms
            
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
      
        } else if segue.identifier == "presentSettingsView" {
            
            (segue.destinationViewController as! SettingsViewController).userName = self.userName
        }
        
        
    
        
    }
    
    

   
    

}
