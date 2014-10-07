//
//  ContactCell.swift
//  SilverMessenger
//
//  Created by Tran Ngoc Hieu on 10/4/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

class ContactCell: UITableViewCell {
    
    @IBOutlet var newMessageIndicator: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet var contactLabel: UILabel!
    @IBOutlet var recentLabel: UILabel!
    
    var status: ContactStatusEnum {
        didSet {
            switch status{
            case .Online:
                statusImageView.image = UIImage(named:"Online.png")
            case .Away:
                statusImageView.image = UIImage(named:"Away.png")
            case .DoNotDisturb:
                statusImageView.image = UIImage(named:"DonotDisturb.png")
            default:
                statusImageView.image = nil
            }
        }
    }
    
    override init() {
        status = ContactStatusEnum.Offline
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        status = ContactStatusEnum.Offline
        super.init(coder: aDecoder)
    }
}
