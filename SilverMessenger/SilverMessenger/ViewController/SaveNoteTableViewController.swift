//
//  SaveNoteTableViewController.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/30/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import UIKit

class SaveNoteTableViewController: UITableViewController, SaveNoteConnectorDelegate {
    
    var connector:SaveNoteConnector!
    var contact:Contact!
    var headerSec:UITableViewHeaderFooterView?
    var selectedCode:String = ""
    var content:String!
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var subjectTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connector = SaveNoteConnector()
        connector.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        headerSec = self.tableView.headerViewForSection(0)
    }
    

  
    
    @IBAction func onSegmentValueChanged(sender: UISegmentedControl) {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        var cell = self.tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        if sender.selectedSegmentIndex == 0{
            cell.textLabel.text = "Policy Code      "
        }
        else{
            cell.textLabel.text = "Business Code    "
        }
        cell.detailTextLabel?.text = "Select"
    }
    
    @IBAction func onSaveTouched(sender: AnyObject) {
        if !self.selectedCode.isEmpty {
            var chatDataArr = NSMutableArray()
            
            for message in self.contact.messageSource{
                var chatData: NSDictionary = [
                    "Date": "\(message.date)",
                    "From": message.contactFrom,
                    "Content": message.message,
                    "IsIncomming": message.contactFrom == GlobalVariable.shareInstance.loginInfo.userName! ? false : true
                ]
                println(message.date)
                chatDataArr.addObject(chatData)
            }
            
            var newSaveNote: NSDictionary = [
                "Username": GlobalVariable.shareInstance.loginInfo.userName!,
                "IsPolicy": self.segmentControl.selectedSegmentIndex == 0 ? true : false,
                "IsEntity": self.segmentControl.selectedSegmentIndex == 0 ? false : true,
                "PolicyCode": self.selectedCode,
                "BusinessCode": self.selectedCode,
                "Subject": self.subjectTextField.text,
                "ChatData": chatDataArr
            ]
            let jsonData = NSJSONSerialization.dataWithJSONObject(newSaveNote, options: nil, error: nil)
            let jsonString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding)
            self.connector.SaveNotes(newSaveNote)
        }
        else{
            let alert = UIAlertView(title: "", message: "Please select Policy/Business Entity Code", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
        }
    }
    
    func didPostNote(success: Bool) {
        if success{
            //clear chat data
            BusinessAccess.deleteMessageByContact(self.contact.name)
            var savedInform = UIAlertController(title: "", message: "Notes was saved \nChat session was deleted.", preferredStyle: UIAlertControllerStyle.Alert)
            savedInform.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                self.backToParent()
            }))
            presentViewController(savedInform, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertView(title: "", message: "It had problem while saving note.", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
        }
    }
    
    func backToParent(){
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let noteSelectionVC =  segue.destinationViewController as NoteSelectionViewController
        noteSelectionVC.delegate = self
        noteSelectionVC.noteType = self.segmentControl.selectedSegmentIndex == 0 ? NoteType.Policy : NoteType.BusinessEntity
    }

    
    func onSelectedCode(noteType: String, code: String, description: String) {
        self.selectedCode = code
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        var cell = self.tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        cell.textLabel.text = code
        cell.detailTextLabel?.text = description
    }
    
    
}
