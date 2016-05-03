//
//  saveTableViewCell.swift
//  
//
//  Created by Michael Fulton Jr. on 4/14/16.
//
//

import UIKit
import Firebase

class saveTableViewCell: UITableViewCell {
    @IBOutlet weak var saveButton: UIButton!
    var VC: SettingsViewController!
    @IBAction func saveData(sender: UIButton) {
        
      
        
        if self.contentView.backgroundColor == UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0) {
               let ref =  Firebase(url: "https://data-center.firebaseio.com/users/\(data.userName)")
                ref.childByAppendingPath("start").setValue(data.start)
            ref.childByAppendingPath("peopleCount").setValue(data.peopleCount)
                    ref.childByAppendingPath("buildingSize").setValue(data.buildingSize)
                ref.childByAppendingPath("computerCount").setValue(data.computerCount)
            ref.childByAppendingPath("load").setValue(data.load)
        ref.childByAppendingPath("cta").setValue(data.CTA)
              let alert = UIAlertController(title: "Saved", message: nil, preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Cool, Thanks!", style: .Default, handler: nil)
            alert.addAction(ok)
           VC.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "You Forgot Something!", message: nil , preferredStyle: .Alert)
            let ok = UIAlertAction(title: "I'll fix it!", style: .Default, handler: nil)
            alert.addAction(ok)
            VC.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    var data: dataSettingsStruct!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
