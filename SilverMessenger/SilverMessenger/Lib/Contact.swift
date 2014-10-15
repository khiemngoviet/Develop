//
//  Contact.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/15/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import Foundation
class Contact{
    
    var name:String
    var status: ContactStatusEnum
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
    
    init(name: String, status: ContactStatusEnum, recentMessage: String){
        self.name = name
        self.status = status
        self.recentMessage = recentMessage
    }
    
    
}
