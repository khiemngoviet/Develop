//
//  RecentViewController.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 9/28/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import UIKit


class RecentViewController: UITableViewController{

    
    var recentContactSource = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor =  UIColor(red:0.973, green:0.957, blue:0.859, alpha:1)
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
        self.recentContactSource.removeAll(keepCapacity: true)
        //get distinct by contactTo
        let results = BusinessAccess.getDistinctContact()
        
        for dict in results as Array<NSDictionary> {
          let contactKey =  dict.valueForKey("contactRecent") as String
          let isContainContact = GlobalVariable.shareInstance.contactSource.containContact(GlobalVariable.shareInstance.contactSource, key: contactKey)
            if isContainContact {
                //Add contactSource to recentContactSource
                var contact = GlobalVariable.shareInstance.contactSource.getContactByKey(GlobalVariable.shareInstance.contactSource, key: contactKey)
                let (latestDate, recentMess) = BusinessAccess.getRecentMessageByContact(contactKey)!
                contact?.recentMessage = recentMess
                contact?.latestDate = latestDate
                recentContactSource.append(contact!)
            }
            else{
                var contact = Contact(name: contactKey, status: ContactStatusEnum.Offline, recentMessage: "")
                let (latestDate, recentMess) = BusinessAccess.getRecentMessageByContact(contactKey)!
                contact.recentMessage = recentMess
                contact.latestDate = latestDate
                recentContactSource.append(contact)
            }
        }
        self.recentContactSource.sort {$0 ! $1}
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("RecentCell") as RecentCell
        let contact = recentContactSource[indexPath.row]
        cell.contactLabel.text = contact.name
        cell.recentLabel.text = contact.shortMessage
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

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = self.tableView.indexPathForCell(sender as RecentCell)!
        var conversationView: ConversationViewController = segue.destinationViewController as ConversationViewController
        conversationView.contact = recentContactSource[indexPath.row]
        conversationView.contact.showIndicator = false
        conversationView.contact.isInConversation = true
        conversationView.isFromRecent = true

    }
    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
