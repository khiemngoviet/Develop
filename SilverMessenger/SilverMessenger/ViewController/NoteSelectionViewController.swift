//
//  NoteSelectionViewController.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/30/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import UIKit

class NoteSelectionViewController: UITableViewController, UISearchBarDelegate, NoteSelectionConnectorDelegate {
    
    
    @IBOutlet var searchBar: UISearchBar!
    
    var connector:NoteSelectionConnector!
    var tableData:NSArray!
    var tabeDataFiltered:NSArray!
    var noteType: NoteType = NoteType.Policy
    var lastSelectedIndexPath:NSIndexPath!
    var delegate: SaveNoteConnectorDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connector = NoteSelectionConnector()
        searchBar.delegate = self
        self.navigationItem.title = self.noteType == NoteType.Policy ? "Select Policy" : "Select Business Entity"
        connector.delegate = self
        if self.noteType == NoteType.Policy{
            self.getPolicies()
        }
        else{
            self.getBusinessEntities()
        }
    }
    
    func getPolicies(){
        connector.getPolicies()
    }
    
    func getBusinessEntities(){
        connector.getBusinessEntities()
    }
    
    
    func didReceiveBusinessEntities(businessEntities: NSArray) {
        self.tableData = businessEntities
        self.reloadTableData()
    }
    
    func didReceivePolicies(policies: NSArray) {
        self.tableData = policies
        self.reloadTableData()
    }
    
    func reloadTableData(){
        let code = self.noteType == NoteType.Policy ? "PolicyCode" : "BusinessCode"
        let description = self.noteType == NoteType.Policy ? "PolicyDescription" : "BusinessName"
        
        //sort data
        let sortDescriptorArr = [NSSortDescriptor(key: "code", ascending: true)]
        self.tableData = self.tableData.sortedArrayUsingDescriptors(sortDescriptorArr)
        self.tabeDataFiltered = NSArray()
        if searchBar.text != ""{
            let searchText = self.searchBar.text
            self.tabeDataFiltered = self.tableData.filteredArrayUsingPredicate(NSPredicate( format: "\(code) CONTAINS[cd] %@ OR \(description) CONTAINS[cd] %@",  searchText, searchText)!)
        }
        else{
            self.tabeDataFiltered = self.tableData
        }
        self.tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.reloadTableData()
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.tableData == nil{
            return 0
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tabeDataFiltered == nil{
            return 0
        }
        return self.tabeDataFiltered.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CodeSelectionCell", forIndexPath: indexPath) as UITableViewCell
        var item = self.tabeDataFiltered[indexPath.row] as NSDictionary
        var code = self.noteType == NoteType.Policy ? item["PolicyCode"] as NSString : item["BusinessCode"] as NSString
        let description = self.noteType == NoteType.Policy ? item["PolicyDescription"] as NSString : item["BusinessName"] as NSString
        cell.textLabel.text = code
        cell.detailTextLabel?.text = description
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:UITableViewCell = self.tableView.cellForRowAtIndexPath(indexPath)!
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:UITableViewCell = self.tableView.cellForRowAtIndexPath(indexPath)!
        cell.accessoryType = UITableViewCellAccessoryType.None
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        if parent == nil{ //Back to root view
            let indexPath: NSIndexPath? = self.tableView.indexPathForSelectedRow()
            if indexPath != nil{
                var item = self.tabeDataFiltered[indexPath!.row] as NSDictionary
                var code = self.noteType == NoteType.Policy ? item["PolicyCode"] as NSString : item["BusinessCode"] as NSString
                let description = self.noteType == NoteType.Policy ? item["PolicyDescription"] as NSString : item["BusinessName"] as NSString
                self.delegate.onSelectedCode!(self.noteType.rawValue, code: code, description: description)
            }
        }
    }
    
    
    
}
