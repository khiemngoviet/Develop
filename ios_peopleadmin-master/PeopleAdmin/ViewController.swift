//
//  ViewController.swift
//  PeopleAdmin
//
//  Created by Santiago Hurtado on 8/5/14.
//  Copyright (c) 2014 Advance Teknologies. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,PeopleConnectorProtocol {

    @IBOutlet var appsTableView:UITableView?
    let kCellIdentifier: String = "SearchResultCell"
    var tableData:NSArray!
    var api:PeopleConnector!
    var personSelected:NSDictionary!
    var refreshControl:UIRefreshControl!

                            
    override func viewDidLoad() {
        super.viewDidLoad()
        api = PeopleConnector()
        tableData = []
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        refreshControl.addTarget(self, action: Selector("loadData"), forControlEvents: UIControlEvents.ValueChanged)
        appsTableView?.addSubview(refreshControl)
        

        self.api.delegate = self
        api.authenticate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadData()
    {
        api.list()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        
        var person = tableData[indexPath.row]as NSDictionary
        
        var name = person["NAME"] as NSString
        var lastname = person["LASTNAME"] as NSString
        var city = person["CITY"] as NSString
        var country = person["COUNTRY"] as NSString
        
        cell.textLabel.text = "\(name) \(lastname)"
        cell.detailTextLabel?.text = "\(country), \(city)"
        
        return cell
    }
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        personSelected = tableData[indexPath.row]as NSDictionary
        performSegueWithIdentifier("person_detail", sender: self)
    }
    func didReceiveList(results: NSDictionary) {
//        dispatch_async(dispatch_get_main_queue(), {
//            self.tableData = results
//            self.appsTableView!.reloadData()
//            self.refreshControl.endRefreshing()
//        })
        api.list()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {

        if segue.identifier=="person_detail"{
            
            var detail = segue.destinationViewController as PersonViewController
            detail.person = personSelected
        }
    }
}