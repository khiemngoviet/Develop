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
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var companyId: UILabel!
    @IBOutlet var hideOfflineSwitch: UISwitch!
    @IBOutlet var enabledSound: UISwitch!
    
    
    let statusContact = [ContactStatusEnum.Online : "Online", ContactStatusEnum.Invisible:"InVisible", ContactStatusEnum.DoNotDisturb : "Do Not Disturb", ContactStatusEnum.Away: "Away"]
    
    var selectedStatus: ContactStatusEnum?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(red:0.973, green:0.957, blue:0.859, alpha:1)
        self.hideOfflineSwitch.tintColor = UIColor.orangeColor()
        self.enabledSound.tintColor = UIColor.orangeColor()
        companyId.text = GlobalVariable.shareInstance.loginInfo.server
        usernameLabel.text = GlobalVariable.shareInstance.loginInfo.userName
        
        enabledSound.on = GlobalVariable.shareInstance.getDefaultValue(GlobalVariable.shareInstance.enabledSoundKey) as Bool
        let status = ContactStatusEnum(rawValue: GlobalVariable.shareInstance.getDefaultValue(GlobalVariable.shareInstance.statusKey) as String)
        statusButtons.setTitle(statusContact[status!], forState: UIControlState.Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        hideOfflineSwitch.on  = GlobalVariable.shareInstance.getDefaultValue(GlobalVariable.shareInstance.hideOfflineKey) as Bool
        if selectedStatus != nil {
            statusButtons.setTitle(statusContact[selectedStatus!], forState: UIControlState.Normal)
        }
    }
    
    
    @IBAction func onHideOfflineSwitched(sender: UISwitch) {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(sender.on, forKey: GlobalVariable.shareInstance.hideOfflineKey)
        defaults.synchronize()
    }
    
    @IBAction func onStatusTouched(sender: UIButton) {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Online", "Invisible","Away","Do not disturb")
        actionSheet.showInView(self.view)
    }
    
    @IBAction func onSoundSwitched(sender: UISwitch) {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(sender.on, forKey: GlobalVariable.shareInstance.enabledSoundKey)
        defaults.synchronize()
    }
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex{
        case 1:
            self.changeStatus(ContactStatusEnum.Online)
            break;
        case 2:
            self.changeStatus(ContactStatusEnum.Invisible)
            break;
        case 3:
            self.changeStatus(ContactStatusEnum.Away)
            break;
        case 4:
            self.changeStatus(ContactStatusEnum.DoNotDisturb)
            break;
        default:
            break;
        }
    }
    
    func changeStatus(status:ContactStatusEnum){
        GlobalVariable.shareInstance.setDefaultValue(GlobalVariable.shareInstance.statusKey, value: status.rawValue)
        MessageSocket.sharedInstance.changeStatus(status)
        statusButtons.setTitle(statusContact[status], forState: UIControlState.Normal)
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
        MessageSocket.sharedInstance.clearObServer()
        GlobalVariable.shareInstance.loginInfo.clearInfo()
        MessageSocket.sharedInstance.disconnect()
        KeychainWrapper.delete(GlobalVariable.shareInstance.companyKey)
        KeychainWrapper.delete(GlobalVariable.shareInstance.usernameKey)
        KeychainWrapper.delete(GlobalVariable.shareInstance.passwordKey)
        let vcLogin = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as LoginViewController
        self.navigationController?.pushViewController(vcLogin, animated: true)
    }
    
    
}
