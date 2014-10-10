//
//  ContactViewController.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 9/28/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import UIKit

class ContactViewController: UITableViewController, MessageDelegate {
    
    var isHideOffline = false
    var contactSourceFilterd = [String: Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MessageSocket.sharedInstance.register("ContactViewController", observer: self)
    }
    
    override func viewDidAppear(animated: Bool) {
        var defaults = NSUserDefaults.standardUserDefaults()
        self.isHideOffline = defaults.boolForKey(GlobalVariable.shareInstance.hideOfflineKey)
        self.reloadTableView()
    }
    
    override func viewDidDisappear(animated: Bool) {
        MessageSocket.sharedInstance.unRegister("ContactViewController", observer: self)
    }
    
    func reloadTableView(){
        self.contactSourceFilterd.removeAll(keepCapacity: false)
        if self.isHideOffline{
            for (key, contact) in GlobalVariable.shareInstance.contactSource{
                if contact.status != ContactStatusEnum.Offline{
                    self.contactSourceFilterd[key] = contact
                }
            }
        }
        else{
            self.contactSourceFilterd = GlobalVariable.shareInstance.contactSource
        }
        self.tableView.reloadData()
    }
    
    func didReceiveContact(message: String) {
        if self.tabBarController?.selectedIndex == 0 {
            let contactPart: String = message.componentsSeparatedByString("~")[1]
            let arrContact = contactPart.componentsSeparatedByString(",") //[Contact:Status]
            for value: String in arrContact {
                let name = value.componentsSeparatedByString(":")[0]
                let status: ContactStatusEnum = ContactStatusEnum(rawValue: value.componentsSeparatedByString(":")[1])!
                let contact = Contact(name: name, status: status, recentMessage: "")
                GlobalVariable.shareInstance.contactSource[name] = contact
            }
            self.reloadTableView()
        }
    }
    
    func didChangeStatus(contact: String, status: String) {
        // find index from dictionary based on key
        var index:Int = GlobalVariable.shareInstance.findIndexFromKey(contact)
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as ContactCell
        cell.status = ContactStatusEnum(rawValue: status)!
    }
    
    func didReceiveMessage(fromContact: String, toContact: String, contentMess: String) {
        let selectedIndex = self.tabBarController?.selectedIndex
        if self.tabBarController?.selectedIndex == 0 {
            // find index from dictionary based on key
            var index:Int = GlobalVariable.shareInstance.findIndexFromKey(fromContact)
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as ContactCell
            let contact = GlobalVariable.shareInstance.contactSource[fromContact]!
            cell.newMessageIndicator.hidden = !contact.showIndicator
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.contactSourceFilterd.isEmpty {
            return 0
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactSourceFilterd.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ContactCell") as ContactCell
        let key = Array(self.contactSourceFilterd.keys)[indexPath.row]
        let contact = self.contactSourceFilterd[key]!
        cell.contactLabel.text = contact.name
        cell.status = contact.status
        cell.newMessageIndicator.hidden = !contact.showIndicator
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor(red: 0.976, green:0.976, blue:0.976, alpha:1)
        }
        else{
            cell.contentView.backgroundColor = UIColor.whiteColor()
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        //
        let nav = self.navigationController
        var conversationView: ConversationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ConversationViewController") as ConversationViewController
        let key:String = Array(self.contactSourceFilterd.keys)[indexPath.row]
        let contacs =  self.contactSourceFilterd[key]!
        conversationView.contact = self.contactSourceFilterd[key]! as Contact
        conversationView.contact.showIndicator = false
        conversationView.contact.isInConversation = true
        conversationView.isFromRecent = false
        nav?.pushViewController(conversationView, animated: true)
    }
    
    
    
}
