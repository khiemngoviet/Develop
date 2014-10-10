//
//  SettingViewController.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/3/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController, UIActionSheetDelegate {
    @IBOutlet var statusButtons: UIButton!
    @IBOutlet var companyId: UILabel!
    @IBOutlet var hideOfflineSwitch: UISwitch!
    
    let statusContact = [ContactStatusEnum.Online : "Online", ContactStatusEnum.Invisible:"InVisible", ContactStatusEnum.DoNotDisturb : "Do not disturb", ContactStatusEnum.Away: "Away"]
    
    var selectedStatus: ContactStatusEnum?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyId.text = "\(KeychainWrapper.load(GlobalVariable.shareInstance.companyKey))"
        var defaults = NSUserDefaults.standardUserDefaults()
        hideOfflineSwitch.on  = defaults.boolForKey(GlobalVariable.shareInstance.hideOfflineKey)
    }
    
    override func viewWillAppear(animated: Bool) {
        if selectedStatus != nil {
            statusButtons.setTitle(statusContact[selectedStatus!], forState: UIControlState.Normal)
        }
    }
    
    
    @IBAction func onHideOfflineSwitched(sender: UISwitch) {
        let bds = sender.on
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(sender.on, forKey: GlobalVariable.shareInstance.hideOfflineKey)
        defaults.synchronize()
    }
    
    
    @IBAction func onStatusTouched(sender: UIButton) {
        //        var statusView = self.storyboard?.instantiateViewControllerWithIdentifier("statusView") as StatusViewController
        //        statusView.view.userInteractionEnabled = true
        //        self.view.addSubview(statusView.view)
        
        
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Online", "Invisible","Away","Do not disturb")
        actionSheet.showInView(self.view)
    }

    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex{
            
        case 0:
            NSLog("Done");
            break;
        case 1:
            NSLog("Cancel");
            break;
        case 2:
            NSLog("Yes");
            break;
        case 3:
            NSLog("No");
            break;
        default:
            NSLog("Default");
            break;
            //Some code here..
            
        }
    }
    
    @IBAction func onLogoutTouched(sender: UIButton) {
        var refreshAlert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            self.doSignout()
        }))
        refreshAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction!) in
            //just do nothing
        }))
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    func doSignout(){
        MessageSocket.sharedInstance.disconnect()
        KeychainWrapper.delete(GlobalVariable.shareInstance.companyKey)
        KeychainWrapper.delete(GlobalVariable.shareInstance.usernameKey)
        KeychainWrapper.delete(GlobalVariable.shareInstance.passwordKey)
        let vcLogin = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as LoginViewController
        self.navigationController?.pushViewController(vcLogin, animated: true)
    }
    
    
}
