//
//  ContactViewController.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 9/28/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import UIKit

class ContactViewController: UITableViewController, MessageDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MessageSocket.sharedInstance.register(self)
        MessageSocket.sharedInstance.getContact()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func didReceiveContact(message: String) {
        if self.tabBarController?.selectedIndex == 0 {
            let contactPart: String = message.componentsSeparatedByString("~")[1]
            let arrContact = contactPart.componentsSeparatedByString(",") //[Contact:Status]
            for value: String in arrContact {
                let name = value.componentsSeparatedByString(":")[0]
                let status: ContactStatusEnum = ContactStatusEnum(rawValue: value.componentsSeparatedByString(":")[1])!
                let contact = Contact(name: name, status: status, shortMessage: "")
                GlobalVariable.shareInstance.contactSource[name] = contact
            }
            tableView.reloadData()
        }
    }
    
    func didChangeStatus(contact: String, status: ContactStatusEnum) {
        // find index from dictionary based on key
        var index:Int = GlobalVariable.shareInstance.findIndexFromKey(contact)
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as ContactCell
        cell.status = status
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
            cell.recentLabel?.text = contact.shortMessage
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if GlobalVariable.shareInstance.contactSource.isEmpty {
            return 0
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalVariable.shareInstance.contactSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ContactCell") as ContactCell
        let key = Array(GlobalVariable.shareInstance.contactSource.keys)[indexPath.row]
        let contact = GlobalVariable.shareInstance.contactSource[key]!
        cell.contactLabel.text = contact.name
        cell.status = contact.status
        cell.recentLabel.text = contact.shortMessage
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
        let key:String = Array(GlobalVariable.shareInstance.contactSource.keys)[indexPath.row]
        conversationView.contact = GlobalVariable.shareInstance.contactSource[key]! as Contact
        conversationView.contact.showIndicator = false
        conversationView.contact.isInConversation = true
        //self.updateBadgeTabValue()
        nav?.pushViewController(conversationView, animated: true)
    }
    
    func updateBadgeTabValue(){
        let tabBar = self.navigationController?.tabBarController?.tabBar.items?[0] as UITabBarItem
        if tabBar.badgeValue != nil {
            var intCountNotification: Int = (tabBar.badgeValue! as NSString).integerValue
            intCountNotification -= 1
            if  intCountNotification == 0 {
                tabBar.badgeValue = nil
            }
            else {
                tabBar.badgeValue = "\(intCountNotification)"
            }
        }
    }
    
}