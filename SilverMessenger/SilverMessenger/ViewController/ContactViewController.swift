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
    @IBOutlet var segmentFilter: UISegmentedControl!
    
    
    var isActive: Bool = false
    var isHideOffline = false
    var contactSourceFilterd = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor =  UIColor(red:0.973, green:0.957, blue:0.859, alpha:1)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.delegate = self
        
        MessageSocket.sharedInstance.register("ContactViewController", observer: self)
        MessageSocket.sharedInstance.getContact()
    }
    
    override func viewWillAppear(animated: Bool) {
        if !MessageSocket.sharedInstance.containObServer("ContactViewController"){
            MessageSocket.sharedInstance.register("ContactViewController", observer: self)
        }
        self.isActive = true
    }
    
    override func viewDidAppear(animated: Bool) {
        var defaults = NSUserDefaults.standardUserDefaults()
        self.isHideOffline = GlobalVariable.shareInstance.getDefaultValue(GlobalVariable.shareInstance.hideOfflineKey) as Bool
        segmentFilter.selectedSegmentIndex = self.isHideOffline == true ? 1 : 0
        self.reloadTableView()
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.isActive = false
        MessageSocket.sharedInstance.unRegister("ContactViewController", observer: self)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.reloadTableView()
    }
    
    func reloadTableView(){
        self.contactSourceFilterd.removeAll(keepCapacity: false)
        if self.isHideOffline{
            for contact in GlobalVariable.shareInstance.contactSource{
                if contact.status != ContactStatusEnum.Offline{
                    if searchBar.text != ""{
                        let searchText = self.searchBar.text.lowercaseString
                        let contactKey = contact.name.lowercaseString as NSString
                        if contactKey.containsString(searchText){
                            self.contactSourceFilterd.append(contact)
                        }
                    }
                    else{
                        self.contactSourceFilterd.append(contact)
                    }
                }
            }
        }
        else{
            for  contact in GlobalVariable.shareInstance.contactSource{
                if searchBar.text != ""{
                    let searchText = self.searchBar.text.lowercaseString
                    let contactKey = contact.name.lowercaseString as NSString
                    if contactKey.containsString(searchText){
                        self.contactSourceFilterd.append(contact)
                    }
                }
                else{
                    self.contactSourceFilterd.append(contact)
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    func didReceiveContact(message: String) {
        if self.isActive {
            GlobalVariable.shareInstance.contactSource.removeAll(keepCapacity: true)
            let contactPart: String = message.componentsSeparatedByString("~")[1]
            let arrContact = contactPart.componentsSeparatedByString(",") //[Contact:Status]
            for value: String in arrContact {
                let name = value.componentsSeparatedByString(":")[0]
                let status: ContactStatusEnum = ContactStatusEnum(rawValue: value.componentsSeparatedByString(":")[1])!
                let contact = Contact(name: name, status: status, recentMessage: "")
                GlobalVariable.shareInstance.contactSource.append(contact)
            }
            self.sortContact()
            self.reloadTableView()
        }
    }
    
    //Message Delegate function
    func didChangeStatus(contactKey: String, status: String) {
        self.sortContact()
        self.reloadTableView()
    }
    
    func didReceiveMessage(fromContact: String, toContact: String, contentMess: String) {
        let selectedIndex = self.tabBarController?.selectedIndex
        if self.isActive {
            // find index from dictionary based on key
            var index:Int = GlobalVariable.shareInstance.contactSource.indexOfContact(GlobalVariable.shareInstance.contactSource, key: fromContact)
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            if cell != nil{
                let contact = GlobalVariable.shareInstance.contactSource[index]
                (cell as ContactCell).newMessageIndicator.hidden = !contact.showIndicator
            }
        }
    }
    
    
    func sortContact(){
        GlobalVariable.shareInstance.contactSource.sort {$0 < $1}
        GlobalVariable.shareInstance.contactSource.sort {$0 ~ $1}
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
        let contact = self.contactSourceFilterd[indexPath.row]
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
        let contact =  self.contactSourceFilterd[indexPath.row]
        conversationView.contact = contact
        if conversationView.contact.showIndicator {
            conversationView.contact.showIndicator = false
            MessageSocket.sharedInstance.clearNotificationBagle()
        }
        conversationView.contact.isInConversation = true
        conversationView.isFromRecent = false
    }
    
    
    @IBAction func searchButtonTapped(sender: UIBarButtonItem) {
        let constr: NSLayoutConstraint = searchBar.constraints()[0] as NSLayoutConstraint
        if searchBar.hidden{
            constr.constant = 44
        }
        else{
            constr.constant = 0
        }
        searchBar.hidden = !searchBar.hidden
    }
    
    @IBAction func onSegmentValueChanged(sender: UISegmentedControl) {
        var defaults = NSUserDefaults.standardUserDefaults()
        self.isHideOffline = segmentFilter.selectedSegmentIndex == 0 ? false : true
        defaults.setBool(self.isHideOffline, forKey: GlobalVariable.shareInstance.hideOfflineKey)
        defaults.synchronize()
        self.reloadTableView()
    }
    
    
    
}
