//
//  NoteConnectorProtocol.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/29/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import Foundation

@objc protocol JsonConnectorProtocol{
    func didAuthenticate(isAuthenticate:Bool);
}

@objc protocol NoteConnectorProtocol: JsonConnectorProtocol{
    func didReceivePolicies(policies: NSDictionary);
    func didReceiveBusinessEntities(businessEntities: NSDictionary);
}

