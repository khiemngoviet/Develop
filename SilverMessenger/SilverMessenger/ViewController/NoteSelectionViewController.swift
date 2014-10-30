//
//  NoteSelectionViewController.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/30/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import UIKit

class NoteSelectionViewController: UITableViewController, NoteConnectorProtocol {
    
    var connector:NoteConnector!
    var tableData:NSArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Select Policy Code"
        connector.delegate = self
        connector.getPolicies()
    }
    
    
    func didReceiveBusinessEntities(businessEntities: NSArray) {
        self.tableData = businessEntities
    }
    
    func didReceivePolicies(policies: NSArray) {

            self.tableData = policies
            self.tableView.reloadData()

    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tableData == nil{
            return 0
        }
       return self.tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CodeSelectionCell", forIndexPath: indexPath) as UITableViewCell
        var policy = self.tableData[indexPath.row] as NSDictionary
        var code = policy["PolicyCode"] as NSString
        cell.textLabel.text = code
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
    }
    
}
