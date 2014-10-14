//
//  ContactViewController.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 9/28/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MessageDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var isActive: Bool = false
    var isHideOffline = false
    var contactSourceFilterd = [String: Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.isActive = true
    }
    
    override func viewDidAppear(animated: Bool) {
        MessageSocket.sharedInstance.register(NSStringFromClass(ContactViewController), observer: self)
        
        var defaults = NSUserDefaults.standardUserDefaults()
        if GlobalVariable.shareInstance.getDefaultValue(GlobalVariable.shareInstance.hideOfflineKey) != nil {
            self.isHideOffline = GlobalVariable.shareInstance.getDefaultValue(GlobalVariable.shareInstance.hideOfflineKey) as Bool
        }
        else{
            GlobalVariable.shareInstance.setDefaultValue(GlobalVariable.shareInstance.hideOfflineKey, value: self.isHideOffline)
        }
        self.reloadTableView()
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.isActive = false
        MessageSocket.sharedInstance.unRegister(NSStringFromClass(ContactViewController), observer: self)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.reloadTableView()
    }
    
    func reloadTableView(){
        self.contactSourceFilterd.removeAll(keepCapacity: false)
        if self.isHideOffline{
            for (key, contact) in GlobalVariable.shareInstance.contactSource{
                if contact.status != ContactStatusEnum.Offline{
                    if searchBar.text != ""{
                        let searchText = self.searchBar.text.lowercaseString
                        let contactKey = key.lowercaseString as NSString
                        if contactKey.containsString(searchText){
                            self.contactSourceFilterd[key] = contact
                        }
                    }
                    else{
                        self.contactSourceFilterd[key] = contact
                    }
                }
            }
        }
        else{
            for (key, contact) in GlobalVariable.shareInstance.contactSource{
                if searchBar.text != ""{
                    let searchText = self.searchBar.text.lowercaseString
                    let contactKey = key.lowercaseString as NSString
                    if contactKey.containsString(searchText){
                        self.contactSourceFilterd[key] = contact
                    }
                }
                else{
                    self.contactSourceFilterd[key] = contact
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func didReceiveContact(message: String) {
        if self.isActive {
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
    
    //Message Delegate function
    func didChangeStatus(contactKey: String, status: String) {
        // find index from dictionary based on key
        var contact = GlobalVariable.shareInstance.contactSource[contactKey]
        if contact != nil {
            var index:Int = GlobalVariable.shareInstance.findIndexFromKey(contactKey)
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            if cell != nil{
                (cell as ContactCell).status = ContactStatusEnum(rawValue: status)!
            }
        }
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.contactSourceFilterd.isEmpty {
            return 0
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactSourceFilterd.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = self.tableView.indexPathForCell(sender as ContactCell)!
        var conversationView: ConversationViewController = segue.destinationViewController as ConversationViewController
        let key:String = Array(self.contactSourceFilterd.keys)[indexPath.row]
        let contacs =  self.contactSourceFilterd[key]!
        conversationView.contact = self.contactSourceFilterd[key]! as Contact
        if conversationView.contact.showIndicator {
            conversationView.contact.showIndicator = false
            MessageSocket.sharedInstance.clearNotificationBagle()
        }
        conversationView.contact.isInConversation = true
        conversationView.isFromRecent = false
    }
    
    
    
    
    
    
}
