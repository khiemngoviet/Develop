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
    @IBOutlet var enabledSound: UISwitch!
    
    
    let statusContact = [ContactStatusEnum.Online : "Online", ContactStatusEnum.Invisible:"InVisible", ContactStatusEnum.DoNotDisturb : "Do not disturb", ContactStatusEnum.Away: "Away"]
    
    var selectedStatus: ContactStatusEnum?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyId.text = "\(KeychainWrapper.load(GlobalVariable.shareInstance.companyKey))"
        hideOfflineSwitch.on  = GlobalVariable.shareInstance.getDefaultValue(GlobalVariable.shareInstance.hideOfflineKey) as Bool
        enabledSound.on = GlobalVariable.shareInstance.getDefaultValue(GlobalVariable.shareInstance.enabledSoundKey) as Bool
        let status = ContactStatusEnum(rawValue: GlobalVariable.shareInstance.getDefaultValue(GlobalVariable.shareInstance.statusKey) as String)
        statusButtons.setTitle(statusContact[status!], forState: UIControlState.Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
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
