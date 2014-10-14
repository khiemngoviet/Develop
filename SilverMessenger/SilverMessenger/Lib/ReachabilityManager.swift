//
//  ReachabilityManager.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/14/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import Foundation

private let _shareInstance = ReachabilityManager()

class ReachabilityManager: NSObject{
    
    class var sharedInstance: ReachabilityManager {
        return _shareInstance
    }
    
    var hostReachability: Reachability?
    
    func initReachabilityHost(hostName:String){
        hostReachability = Reachability(hostName: hostName)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("reachabilityChanged"), name: kReachabilityChangedNotification, object: self.hostReachability)
        hostReachability?.startNotifier()
    }
    
    func reachabilityChanged(noti:NSNotification){
        let reachability = noti.object as Reachability
        let status = reachability.currentReachabilityStatus()
        
    }
    
    func registerObServer(obServer: ReachabilityDelegate){
        
    }
    
    func unRegisterObServer(obServer: ReachabilityDelegate){
        
    }
    
}