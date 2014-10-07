//
//  MessageDelegate.swift
//  SilverMessenger
//
//  Created by Tran Ngoc Hieu on 10/4/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

protocol MessageDelegate {
    func didReceiveMessage(fromContact: String, toContact:String, contentMess: String)
    func didChangeStatus(contact:String, status: ContactStatusEnum)
    func didReceiveContact(message: String)
}
