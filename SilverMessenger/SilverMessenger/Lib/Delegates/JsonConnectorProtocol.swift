//
//  NoteConnectorProtocol.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/29/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import Foundation

@objc protocol JsonConnectorProtocol{
   
}

@objc protocol NoteConnectorProtocol: JsonConnectorProtocol{
   optional func didReceivePolicies(policies: NSArray);
   optional func didReceiveBusinessEntities(businessEntities: NSArray);
}

