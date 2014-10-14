//
//  MessageDelegate.swift
//  SilverMessenger
//
//  Created by Tran Ngoc Hieu on 10/4/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

@objc protocol MessageDelegate {
    
     var isActive:Bool {get set}
    optional func didReceiveMessage(fromContact: String, toContact:String, contentMess: String)
    optional func didChangeStatus(contactKey:String, status: String)
    optional func didReceiveContact(message: String)
    
    
}
