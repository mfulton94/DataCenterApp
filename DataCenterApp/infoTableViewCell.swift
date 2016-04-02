//
//  infoTableViewCell.swift
//  DataCenterApp
//
//  Created by Michael Fulton Jr. on 3/31/16.
//  Copyright © 2016 Michael Fulton Jr. All rights reserved.
//

import UIKit

class infoTableViewCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
