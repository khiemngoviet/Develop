//
//  ReachabilityDelegate.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/14/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import Foundation

@objc protocol ReachabilityDelegate{
    optional func reachable()
    optional func unReachable()
}