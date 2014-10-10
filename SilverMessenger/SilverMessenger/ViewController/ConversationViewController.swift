//
//  ConversationViewController.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 9/29/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITextFieldDelegate, UIBubbleTableViewDataSource, MessageDelegate {
    
    @IBOutlet var navigationItems: UINavigationItem!
    @IBOutlet var mainView: UIView!
    @IBOutlet var viewInputContainer: UIView!
    @IBOutlet var textInput: UITextField!
    
    
    
    @IBOutlet var views: UIView!
    @IBOutlet var tableView: UIBubbleTableView!
    
    
    var contact: Contact!
    var isActive = false
    var isFromRecent = false
    
    
    override func viewWillAppear(animated: Bool) {
        self.isActive = true
        navigationItem.title = contact.name
        //Load all message from core data for current contact
        contact.messageSource.removeAll(keepCapacity: false)
        let currentLoggedInContact = GlobalVariable.shareInstance.loginInfo.userName!
        let messages = BusinessAccess.getMessageByContact(contact.name)
        for message in messages as Array<MessageEntity> {
            contact.messageSource.append(message)
        }
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.isActive = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MessageSocket.sharedInstance.register("ConversationViewController",observer: self)
        
        textInput.delegate = self
        self.navigationItem.title = contact.name
        tableView.bubbleDataSource = self
        tableView.snapInterval = 30
        //tableView.reloadData()
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillbeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        contact.isInConversation = false
        MessageSocket.sharedInstance.unRegister("ConversationViewController", observer: self)
    }
    
    
    func didReceiveMessage(fromContact: String, toContact:String, contentMess: String){
        if self.isActive{
            tableView.reloadData()
        }
    }
    
    
    @IBAction func sendMessageTouched(sender: UIButton) {
        if !textInput.text.isEmpty {
            let fromContact:String = GlobalVariable.shareInstance.loginInfo.userName!
            let toContact:String = contact.name
            let messageRequest = "Message~\(fromContact)#\(toContact)#\(textInput.text)"
            let messageEntity = BusinessAccess.createMessageEntity()
            messageEntity.company = GlobalVariable.shareInstance.loginInfo.server!
            messageEntity.userName = GlobalVariable.shareInstance.loginInfo.userName!
            messageEntity.contactFrom = fromContact
            messageEntity.contactTo = toContact
            messageEntity.contactRecent = toContact
            messageEntity.message = textInput.text
            messageEntity.date = NSDate()
            BusinessAccess.saveMessageEntities()
            contact.messageSource.append(messageEntity)
            MessageSocket.sharedInstance.sendMessage(messageRequest)
            textInput.text = ""
            tableView.reloadData()
        }
    }
    
    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        textInput.resignFirstResponder()
    }
    
    @IBAction func onBackTouched(sender: AnyObject) {
        //TabBarController
        var tabBar = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as TabBarViewController
        if self.isFromRecent{
            tabBar.selectedIndex = 1
        }
        self.navigationController?.pushViewController(tabBar, animated: true)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        let userInfo = notification.userInfo!
        var kbSize: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        
        //        viewInputContainer.frame = CGRectMake(viewInputContainer.frame.origin.x, (viewInputContainer.frame.origin.y - kbSize.height - 20), viewInputContainer.frame.size.width, viewInputContainer.frame.size.height)
        tableView.setContentOffset(CGPointMake(0, tableView.contentSize.height -  tableView.frame.size.height), animated: false)
        var frame = mainView.frame
        frame.size.height -= kbSize.height
        mainView.frame = frame
        
        UIView.commitAnimations()
        
    }
    
    func keyboardWillbeHidden(notification: NSNotification) {
        let userInfo = notification.userInfo!
        var kbSize: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        //        UIView.beginAnimations(nil, context: nil)
        //        UIView.setAnimationDuration(0.7)
        
        //        tableView.frame = CGRectMake(tableView.frame.origin.x, (tableView.frame.origin.y ), tableView.frame.size.width, tableView.frame.size.height + kbSize.height - 49)
        //        viewInputContainer.frame = CGRectMake(viewInputContainer.frame.origin.x, (viewInputContainer.frame.origin.y + kbSize.height - 49), viewInputContainer.frame.size.width, viewInputContainer.frame.size.height)
        var frame = mainView.frame
        frame.size.height += kbSize.height
        mainView.frame = frame
        //UIView.commitAnimations()
    }
    
    
    
    func rowsForBubbleTable(tableView: UIBubbleTableView!) -> Int {
        if contact == nil{
            return 0
        }
        return contact.messageSource.count
    }
    
    func bubbleTableView(tableView: UIBubbleTableView!, dataForRow row: Int) -> NSBubbleData! {
        let message = contact.messageSource[row]
        println(message.message)
        let currentLoggedInContact = GlobalVariable.shareInstance.loginInfo.userName!
        let bubbleType = message.contactFrom == currentLoggedInContact ? BubbleTypeMine : BubbleTypeSomeoneElse
        var bubbleData:NSBubbleData = NSBubbleData(text: message.message, date: message.date, type: bubbleType)
        return bubbleData
    }

    
}
