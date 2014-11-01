//
//  NoteSelectionConnectorDelegate.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 11/1/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import Foundation

@objc protocol NoteSelectionConnectorDelegate: JsonConnectorDelegate{
    optional func didReceivePolicies(policies: NSArray);
    optional func didReceiveBusinessEntities(businessEntities: NSArray);
}