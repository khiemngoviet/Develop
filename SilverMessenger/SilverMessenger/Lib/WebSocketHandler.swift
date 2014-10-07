//
//  WebSocketHandler.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 9/27/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import Foundation

@objc protocol WebSocketHandler{
    
    optional func messageReceived(message: AnyObject)
    
    optional func messageOfflineReceived(message: AnyObject)
    
    optional func statusChanged(status: String)
    
    optional func contactReceived(message: String)
    
    optional func animateActivityIndicator(state: Bool)
    
}
