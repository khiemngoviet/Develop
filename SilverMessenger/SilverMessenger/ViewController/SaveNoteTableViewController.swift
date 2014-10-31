//
//  SaveNoteTableViewController.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/30/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import UIKit

class SaveNoteTableViewController: UITableViewController, AuthenticateDelegate, SaveToNoteDelegate {
    
    var connector:NoteConnector!
    var headerSec:UITableViewHeaderFooterView?
    var selectedCode:String = ""
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var subjectTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connector = NoteConnector()
        connector.authenticateDelegate = self
        let username = GlobalVariable.shareInstance.loginInfo.userName!
        let keychain = GlobalVariable.shareInstance.loadKeychain()!
        let pwd = keychain.pwd
        connector.authenticate(username, pwd: pwd)
    }
    
    override func viewDidAppear(animated: Bool) {
         headerSec = self.tableView.headerViewForSection(0)
    }
    

    
    func didAuthenticate(isAuthenticate: Bool) {
        if !isAuthenticate{
            let alert = UIAlertView(title: "", message: "Cannot connect to Service.", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
        }
        
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
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let noteSelectionVC =  segue.destinationViewController as NoteSelectionViewController
        noteSelectionVC.connector = self.connector
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
