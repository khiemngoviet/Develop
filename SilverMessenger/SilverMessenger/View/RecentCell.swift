//
//  RecentCell.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/8/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import UIKit

class RecentCell: UITableViewCell {

    @IBOutlet var view: UIView!
    @IBOutlet var contactLabel: UILabel!
    @IBOutlet var recentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
