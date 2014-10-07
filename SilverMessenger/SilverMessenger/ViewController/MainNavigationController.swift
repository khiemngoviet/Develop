//
//  MainNavigationController.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 9/27/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController,SRWebSocketDelegate {
    
    var socket: SRWebSocket!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initWebSocket(companyId: String, userName: String, pass: String, status: String){
        GlobalVariable.shareInstance.loginInfo.server = companyId
        GlobalVariable.shareInstance.loginInfo.userName = userName
        let urlString = NSURL(string: "ws://\(companyId).azurewebsites.net/Chat?username=\(userName)&pass=\(pass)&status=Online")
        socket = SRWebSocket(URL: urlString)
        socket.open()
        socket.delegate = self
    }
    
    
    func webSocketDidOpen(webSocket: SRWebSocket!) {
        
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
//        let mess: String = "\(message)"
//        let indicator:String = mess.componentsSeparatedByString("~")[0]
//        let value:String = mess.componentsSeparatedByString("~")[1]
//        var webSocketHandler: WebSocketHandler!
//        
//        if self.topViewController is TabBarController{
//            let tabBar = self.topViewController as TabBarController
//            if tabBar.selectedViewController is UINavigationController{ //Conversation View
//                webSocketHandler = (tabBar.selectedViewController as UINavigationController).topViewController as WebSocketHandler
//            }
//            else{ //Contact View
//                webSocketHandler =  tabBar.selectedViewController as WebSocketHandler
//            }
//            if indicator == MessageIndicator.Message.rawValue {
//                self.updateMessageIndicator(message)
//                webSocketHandler.messageReceived!(message)
//            }
//            if indicator == MessageIndicator.ContactList.rawValue{
//                webSocketHandler.contactReceived!("\(message)")
//            }
//            if indicator == MessageIndicator.StatusChange.rawValue{
//                self.updateStatus("\(message)")
//                webSocketHandler.statusChanged!("\(message)")
//            }
//        }
//        else{
//            webSocketHandler = self.topViewController as WebSocketHandler
//            if indicator == MessageIndicator.IsAuthenticate.rawValue && value == "True" {
//                let tabBar: TabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarView") as TabBarController
//                self.pushViewController(tabBar, animated: true)
//            }
//            if indicator == MessageIndicator.IsAuthenticate.rawValue && value == "False"{
//                webSocketHandler.animateActivityIndicator!(false)
//                let alertView = UIAlertView(title: "", message: "Login failed.", delegate: nil?, cancelButtonTitle: "Ok")
//                alertView.show()
//            }
//        }
    }
    
    func updateMessageIndicator(message: AnyObject){
        let mess:String = "\(message)"
        let fromContact:String = (mess.componentsSeparatedByString("~")[1] as String).componentsSeparatedByString("#")[0]
        let toContact:String = (mess.componentsSeparatedByString("~")[1] as String).componentsSeparatedByString("#")[1]
        let content:String = (mess.componentsSeparatedByString("~")[1] as String).componentsSeparatedByString("#")[2]
        var contact: Contact = GlobalVariable.shareInstance.contactSource[fromContact]!
        
        var bubbleData:NSBubbleData = NSBubbleData(text: content, date: NSDate(), type: BubbleTypeSomeoneElse)
        contact.bubbleData.append(bubbleData)
        
        if countElements(content) > 50{
            contact.shortMessage = (content as NSString).substringWithRange(NSRange(location: 0, length: 50)) + "..."
        }
        else{
            contact.shortMessage = content
        }
        if !contact.showIndicator && !contact.isInConversation{
            let tabBarControllers = self.topViewController as UITabBarController
            var tabBarItem:UITabBarItem =  tabBarControllers.tabBar.items?[0] as UITabBarItem
            contact.showIndicator = true
            
            var indicatorCount: Int
            if tabBarItem.badgeValue == nil {
                indicatorCount =  1
            }
            else {
                indicatorCount = (tabBarItem.badgeValue! as NSString).integerValue + 1
            }
            tabBarItem.badgeValue = "\(indicatorCount)"
        }
    }
    
    func updateStatus(status: String){
        //get contact
        let user:String = (status.componentsSeparatedByString("~")[1] as String).componentsSeparatedByString("#")[0]
        let status:ContactStatusEnum = ContactStatusEnum(rawValue: (status.componentsSeparatedByString("~")[1] as String).componentsSeparatedByString("#")[1])!
        if contains(GlobalVariable.shareInstance.contactSource.keys.array, user) {
            var contact: Contact = GlobalVariable.shareInstance.contactSource[user]!
            //updates contact status
            contact.status = status
        }
    }
    
    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError!) {
        if self.topViewController is WebSocketHandler{
            let webSocketHandler: WebSocketHandler = self.topViewController as WebSocketHandler
            webSocketHandler.animateActivityIndicator!(false)
        }
        let alertview = UIAlertView(title: "", message: "\(error)", delegate: nil, cancelButtonTitle: "Ok")
        alertview.show()
    }
    
    func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        if self.topViewController is WebSocketHandler{
            let webSocketHandler: WebSocketHandler = self.topViewController as WebSocketHandler
            webSocketHandler.animateActivityIndicator!(false)
        }
    }
    
    
}
