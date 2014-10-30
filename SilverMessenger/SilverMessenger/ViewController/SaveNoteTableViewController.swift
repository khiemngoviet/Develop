//
//  SaveNoteTableViewController.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/30/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import UIKit

class SaveNoteTableViewController: UITableViewController, AuthenticateDelegate {
    
    var connector:NoteConnector!
    var footerSection:UITableViewHeaderFooterView!
    
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
        footerSection = self.tableView.footerViewForSection(0)
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
    }
    
    @IBAction func onSaveTouched(sender: AnyObject) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let noteSelectionVC =  segue.destinationViewController as NoteSelectionViewController
        noteSelectionVC.connector = self.connector
    }

 
    
    
}
