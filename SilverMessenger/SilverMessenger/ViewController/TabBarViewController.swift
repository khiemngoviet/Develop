//
//  TabBarViewController.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/6/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, NotificationDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MessageSocket.sharedInstance.delegateNotification = self
        self.tabBar.translucent = false
        
    }
    
    func notify() {
        //update Bagle value
        var tabBarItem:UITabBarItem =  self.tabBar.items?[0] as UITabBarItem
        var indicatorCount: Int
        if tabBarItem.badgeValue == nil {
            indicatorCount =  1
        }
        else {
            indicatorCount = (tabBarItem.badgeValue! as NSString).integerValue + 1
        }
        tabBarItem.badgeValue = "\(indicatorCount)"
    }
    
    func clearNotification() {
        var tabBarItem:UITabBarItem =  self.tabBar.items?[0] as UITabBarItem
        var indicatorCount: Int
        if tabBarItem.badgeValue != nil {
            indicatorCount = (tabBarItem.badgeValue! as NSString).integerValue
            if indicatorCount > 1 {
                tabBarItem.badgeValue = "\(indicatorCount - 1)"
            }
            else if indicatorCount == 1{
                tabBarItem.badgeValue = nil
            }
        }
    }
    
//    func initReachabilityHost(hostName:String){
//       var hostReachability = Reachability(hostName: hostName)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("reachabilityChanged"), name: kReachabilityChangedNotification, object: nil)
//        hostReachability?.startNotifier()
//    }
//    
//    func reachabilityChanged(noti:NSNotification){
//        let reachability = noti.object as Reachability
//        let status = reachability.currentReachabilityStatus()
//        
//    }

    
}
