//
//  MainNavigationController.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 9/27/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    var socket: SRWebSocket!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GlobalVariable.shareInstance.objectContext = SwiftCoreDataHelper.managedObjectContext()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
