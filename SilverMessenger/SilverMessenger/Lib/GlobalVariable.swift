//
//  GlobalVariable.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/1/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import Foundation

class GlobalVariable: NSObject {
    
    var loginInfo: LoginInfo = LoginInfo()
    var contactSource: Dictionary<String, Contact> = [String: Contact]()
    var contactSourceFiltered: Dictionary<String, Contact> = [String: Contact]()
    var hideOffline:Bool = false
    var contactStatus:ContactStatusEnum = ContactStatusEnum.Online
    
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
    
}
