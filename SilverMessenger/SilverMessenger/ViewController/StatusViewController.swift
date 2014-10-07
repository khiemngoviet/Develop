//
//  ViewController.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 9/26/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    

    @IBOutlet var pickStatusView: UIPickerView!

    
    let statusContact = [ContactStatusEnum.Online, ContactStatusEnum.Invisible, ContactStatusEnum.DoNotDisturb, ContactStatusEnum.Away]
    let statusContactTitle = ["Online", "InVisible", "Do not disturb", "Away"]
    var selectedStatus: ContactStatusEnum?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickStatusView.delegate = self
        pickStatusView.dataSource = self
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return statusContact.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        return statusContactTitle[row]
    }
    
    @IBAction func saveTouched(sender: AnyObject) {
      var tabBar =  self.tabBarController
     //self.tabBarController?.selectedIndex = 2
    }
    


 
//inComponent component: Int){
//    selectedStatus =  statusContact[row]

    
//    var ssdf = self.storyboard?.instantiateViewControllerWithIdentifier("settingView") as SettingViewController
//    self.navigationController?.popToViewController(ssdf, animated: true)
   

    
}

