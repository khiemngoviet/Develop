//
//  ConversationViewController.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 9/29/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import UIKit


class ConversationViewController: UIViewController, CSGrowingTextViewDelegate, UIBubbleTableViewDataSource, MessageDelegate {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var viewInputContainer: UIView!
    @IBOutlet var tableView: UIBubbleTableView!
    @IBOutlet var imageStatus: UIBarButtonItem!
    
    @IBOutlet var textInputGrowing: CSGrowingTextView!
    @IBOutlet var growingTextInputConstraint: NSLayoutConstraint!


    @IBOutlet var heightInputViewConstraint: NSLayoutConstraint!

    
    var isActive:Bool = false
    var contact: Contact!
    var isFromRecent = false
    
    var status:ContactStatusEnum = ContactStatusEnum.Offline{
        didSet{
            switch status{
            case .Online:
                imageStatus.image = UIImage(named: "Online.png")
                imageStatus.tintColor = UIColor(red:0, green:0.765, blue:0.275, alpha:1)
            case .Away:
                imageStatus.image = UIImage(named: "Online.png")
                imageStatus.tintColor = UIColor(red:1, green:0.8, blue:0.247, alpha:1)
            case .DoNotDisturb:
                imageStatus.image = UIImage(named: "Online.png")
                imageStatus.tintColor = UIColor(red:0.965, green:0, blue:0.157, alpha:1)
            case .Offline:
                imageStatus.image = UIImage(named: "Online.png")
                imageStatus.tintColor = UIColor(red:0.8, green:0.8, blue:0.8, alpha:1)
            default:
                imageStatus.image = nil
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        MessageSocket.sharedInstance.register("ConversationViewController",observer: self)
        self.isActive = true
        self.status = contact.status
        navigationItem.title = contact.name
        //Load all message from core data for current contact
        contact.messageSource.removeAll(keepCapacity: false)
        let currentLoggedInContact = GlobalVariable.shareInstance.loginInfo.userName!
        let messages = BusinessAccess.getMessageByContact(contact.name)
        for message in messages as Array<MessageEntity> {
            contact.messageSource.append(message)
        }
        tableView.reloadData()
        tableView.scrollBubbleViewToBottomAnimated(false)
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        self.isActive = false
        contact.isInConversation = false
        MessageSocket.sharedInstance.unRegister("ConversationViewController", observer: self)
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewInputContainer.backgroundColor = UIColor(red:0.973, green:0.957, blue:0.859, alpha:1)
        textInputGrowing.delegate = self
        textInputGrowing.placeholderLabel.text = "Message"
        textInputGrowing.minimumNumberOfLines = 1
        textInputGrowing.maximumNumberOfLines = 5
        textInputGrowing.enablesNewlineCharacter = true
        textInputGrowing.growDirection = CSGrowDirection.Down
        tableView.bubbleDataSource = self
        tableView.snapInterval = 15

        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillbeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    //Message Delegate function begin
    func didChangeStatus(contactKey: String, status: String) {
        //if contactKey equal to current contact then update its status
        if contactKey == self.contact.name{
            self.status = ContactStatusEnum(rawValue: status)!
        }
    }
    //Message Delegate function end
    
    func didReceiveMessage(fromContact: String, toContact:String, contentMess: String){
        if self.isActive{
            tableView.reloadData()
            tableView.scrollBubbleViewToBottomAnimated(false)
        }
    }
    
    func growingTextView(growingTextView: CSGrowingTextView!, willChangeHeight height: CGFloat) {
        heightInputViewConstraint.constant = height + 6
        growingTextInputConstraint.constant = height
    }
    
    
    @IBAction func sendMessageTouched(sender: UIButton) {
        if !textInputGrowing.internalTextView.text.isEmpty {
            MessageSocket.sharedInstance.playNotificationSound(SoundNotificationType.InSessionOutgoing)
            let fromContact:String = GlobalVariable.shareInstance.loginInfo.userName!
            let toContact:String = contact.name
            let messageRequest = "Message~\(fromContact)#\(toContact)#\(textInputGrowing.internalTextView.text)"
            let messageEntity = BusinessAccess.createMessageEntity()
            messageEntity.company = GlobalVariable.shareInstance.loginInfo.server!
            messageEntity.userName = GlobalVariable.shareInstance.loginInfo.userName!
            messageEntity.contactFrom = fromContact
            messageEntity.contactTo = toContact
            messageEntity.contactRecent = toContact
            messageEntity.message = textInputGrowing.internalTextView.text
            messageEntity.date = NSDate()
            BusinessAccess.saveMessageEntities()
            contact.messageSource.append(messageEntity)
            MessageSocket.sharedInstance.sendMessage(messageRequest)
            textInputGrowing.internalTextView.text = ""
            tableView.reloadData()
            //self.insertData()
            tableView.scrollBubbleViewToBottomAnimated(false)
        }
    }
    
    func insertData() {
        let numSec = tableView.numberOfSections() - 1
        let row = tableView.numberOfRowsInSection(numSec) + 1
        
        var indxesPath:[NSIndexPath] = [NSIndexPath]()
        indxesPath.append(NSIndexPath(forRow:row,inSection:numSec));
        self.tableView.beginUpdates()
        self.tableView.insertRowsAtIndexPaths(indxesPath, withRowAnimation: UITableViewRowAnimation.Bottom)
        self.tableView.endUpdates()
    }
    
    
    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        textInputGrowing.resignFirstResponder()
    }
    
    
    func keyboardWasShown(notification: NSNotification) {
        let userInfo = notification.userInfo!
        var kbSize: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        let tabBarHeight =  self.tabBarController?.tabBar.frame.size.height
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        tableView.setContentOffset(CGPointMake(0, tableView.contentSize.height -  tableView.frame.size.height), animated: false)
        
        var frame = mainView.frame
        frame.size.height -= kbSize.height
        frame.size.height += tabBarHeight!
        mainView.frame = frame
        
        UIView.commitAnimations()
        tableView.scrollBubbleViewToBottomAnimated(false)
    }
    
    func keyboardWillbeHidden(notification: NSNotification) {
        let userInfo = notification.userInfo!
        var kbSize: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        let tabBarHeight =  self.tabBarController?.tabBar.frame.size.height
        
        var frame = mainView.frame
        frame.size.height += kbSize.height
        frame.size.height -= tabBarHeight!
        mainView.frame = frame
    }
    
    
    
    func rowsForBubbleTable(tableView: UIBubbleTableView!) -> Int {
        if contact == nil{
            return 0
        }
        return contact.messageSource.count
    }
    
    func bubbleTableView(tableView: UIBubbleTableView!, dataForRow row: Int) -> NSBubbleData! {
        let message = contact.messageSource[row]
        let currentLoggedInContact = GlobalVariable.shareInstance.loginInfo.userName!
        let bubbleType = message.contactFrom == currentLoggedInContact ? BubbleTypeMine : BubbleTypeSomeoneElse
        var bubbleData:NSBubbleData = NSBubbleData(text: message.message, date: message.date, type: bubbleType)
        return bubbleData
    }
    
    
}
