//
//  fieldsTableViewCell.swift
//  DataCenterApp
//
//  Created by Michael Fulton Jr. on 3/31/16.
//  Copyright © 2016 Michael Fulton Jr. All rights reserved.
//

import UIKit

class fieldsTableViewCell: UITableViewCell, UITextFieldDelegate{

   
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var field: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
