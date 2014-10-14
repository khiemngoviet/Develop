//
//  GlobalVariable.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/1/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import Foundation
import CoreData

class GlobalVariable: NSObject {
    
    let companyKey = "company"
    let usernameKey = "username"
    let passwordKey = "password"
    let hideOfflineKey = "hideOffline"
    let statusKey = "status"
    
    var loginInfo: LoginInfo = LoginInfo()
    var contactSource: Dictionary<String, Contact> = [String: Contact]()
    
    class var shareInstance: GlobalVariable {
        get {
            struct Static {
                static var instance: GlobalVariable? = nil
                static var token: dispatch_once_t = 0
            }
            dispatch_once(&Static.token, {
                Static.instance = GlobalVariable()
            })
            return Static.instance!
        }
    }
    
    func findIndexFromKey(key:String) -> Int{
        var index:Int = 0
        for keyDict in GlobalVariable.shareInstance.contactSource.keys {
            if keyDict == key{
                break
            }
            index++
        }
        return index
    }
    
    func getDefaultValue(key:String) -> AnyObject?{
        var defaults = NSUserDefaults.standardUserDefaults()
        return defaults.valueForKey(key)
    }
    
    func setDefaultValue(key:String, value:AnyObject){
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(value, forKey: key)
        defaults.synchronize()
    }
    
    func loadKeychain() -> (companyId:String, username:String, pwd:String)?{
        let companyId = KeychainWrapper.load(GlobalVariable.shareInstance.companyKey)
        let username = KeychainWrapper.load(GlobalVariable.shareInstance.usernameKey)
        let pwd = KeychainWrapper.load(GlobalVariable.shareInstance.passwordKey)
        if companyId == nil{
            return nil
        }
        else{
            return ("\(companyId)", "\(username)", "\(pwd)")
        }
    }
    
}

