//
//  RecentViewController.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 9/28/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import UIKit


class RecentViewController: UITableViewController{

    
    var recentContactSource = [String:Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //BusinessAccess.deleteAllMessages(GlobalVariable.shareInstance.objectContext!)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.getAllMessages()
        self.tableView.reloadData()
    }
    
    func saveRecentMessages(){
        BusinessAccess.saveMessageEntities()
    }
    
    func getAllMessages() {
        //get distinct by contactTo
        let results = BusinessAccess.getDistinctContact()
        
        for dict in results as Array<NSDictionary> {
          let contactKey =  dict.valueForKey("contactRecent") as String
          let contactKeySource = Array(GlobalVariable.shareInstance.contactSource.keys)
            if contains(contactKeySource, contactKey) {
                //Add contactSource to recentContactSource
                var contact = GlobalVariable.shareInstance.contactSource[contactKey]
                contact?.recentMessage = BusinessAccess.getRecentMessageByContact(contactKey)
                recentContactSource[contactKey] = contact
            }
            else{
                var contact = Contact(name: contactKey, status: ContactStatusEnum.Offline, recentMessage: "")
                contact.recentMessage = BusinessAccess.getRecentMessageByContact(contactKey)
                recentContactSource[contactKey] = contact
            }
          //Filter messages by current contact
//            let filteredByContact = messages.filter{
//                let s = $0
//                return s.contactTo == contact || s.contactFrom == contact
//            }
//            messageSource[contact] = filteredByContact
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("RecentCell") as RecentCell
        let contactName = Array(recentContactSource.keys)[indexPath.row] as String
        let contact = recentContactSource[contactName]
        cell.contactLabel.text = contactName
        cell.recentLabel.text = contact?.shortMessage
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor(red: 0.976, green:0.976, blue:0.976, alpha:1)
        }
        else{
            cell.contentView.backgroundColor = UIColor.whiteColor()
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentContactSource.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if recentContactSource.isEmpty {
            return 0
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let nav = self.navigationController
        var conversationView: ConversationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ConversationViewController") as ConversationViewController
        let key:String = Array(recentContactSource.keys)[indexPath.row]
        let contacs =  recentContactSource[key]!
        conversationView.contact = recentContactSource[key]! as Contact
        conversationView.contact.showIndicator = false
        conversationView.contact.isInConversation = true
        conversationView.isFromRecent = true
        nav?.pushViewController(conversationView, animated: true)
    }
    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
