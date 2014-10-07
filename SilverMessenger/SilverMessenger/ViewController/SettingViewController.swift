//
//  SettingViewController.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/3/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {
    @IBOutlet var statusButtons: UIButton!
    
    let statusContact = [ContactStatusEnum.Online : "Online", ContactStatusEnum.Invisible:"InVisible", ContactStatusEnum.DoNotDisturb : "Do not disturb", ContactStatusEnum.Away: "Away"]
    
    var selectedStatus: ContactStatusEnum?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if selectedStatus != nil {
            statusButtons.setTitle(statusContact[selectedStatus!], forState: UIControlState.Normal)
        }
        self.tabBarController?.tabBar.hidden = false
    }
    
    
    @IBAction func onAboutTouched(sender: AnyObject) {
    }
    
    @IBAction func onHideOfflineSwitched(sender: UISwitch) {
        let bds = sender.on
        GlobalVariable.shareInstance.hideOffline = sender.on
    }
    
    @IBAction func onStatusTouched(sender: UIButton) {
        var statusView = self.storyboard?.instantiateViewControllerWithIdentifier("statusView") as StatusViewController
        statusView.view.userInteractionEnabled = true
        self.view.addSubview(statusView.view)
        
    }
    
}
