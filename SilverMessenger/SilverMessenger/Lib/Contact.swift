//
//  Contact.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/15/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import Foundation
infix operator ~ {} //sort by status
infix operator ! {} //sort by latest Date

//Use to sort by name
func < (s1: Contact, s2: Contact) -> Bool {
    if (s1.name.lowercaseString < s2.name.lowercaseString) {
        return true
    } else {
        return false
    }
}
//Use to sort by status
func ~ (s1: Contact, s2: Contact) -> Bool {
    if (s1.statusIndex < s2.statusIndex) {
        return true
    } else {
        return false
    }
}

//Use to sort by latest date
func ! (s1: Contact, s2: Contact) -> Bool {
    let interval = s1.latestDate?.timeIntervalSinceDate(s2.latestDate!)
    if (interval > 0) {
        return true
    } else {
        return false
    }
}
class Contact{
    
    var name:String
    var status: ContactStatusEnum
    
    var statusIndex:Int{
        get{
            switch self.status{
            case .Online:
                return 1
            case .Away:
                return 2
            case .DoNotDisturb:
                return 3
            case .Invisible, .Offline:
                return 4
            }
            
        }
    }
    
    var recentMessage:String{
        didSet{
            if countElements(recentMessage) > 50{
                self.shortMessage = (recentMessage as NSString).substringWithRange(NSRange(location: 0, length: 50)) + "..."
            }
            else{
                self.shortMessage = recentMessage
            }
            
        }
    }
    var shortMessage: String = ""
    var messageSource = [MessageEntity]()
    var showIndicator:Bool = false
    var isInConversation:Bool = false
    var latestDate:NSDate?
    init(name: String, status: ContactStatusEnum, recentMessage: String){
        self.name = name
        self.status = status
        self.recentMessage = recentMessage
    }
    
    
}
