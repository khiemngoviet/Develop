//
//  MessageSocket.swift
//  SilverMessenger
//
//  Created by Tran Ngoc Hieu on 10/4/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//
import AVFoundation
import Foundation


private let _shareInstance = MessageSocket()

class MessageSocket: NSObject, SRWebSocketDelegate, JsonAuthenticateDelegate {
    
    var socket: SRWebSocket!
    var observers = [String: MessageDelegate]()
    
    var delegateAuthen: AuthenticateDelegate?
    var delegateNotification: NotificationDelegate?
    
    var audioPlayer:AVAudioPlayer?
    var timer:NSTimer!
    var isReconnect:Bool = false
    
    
    class var sharedInstance: MessageSocket {
        return _shareInstance
    }
    
    func authenticateUser(companyId: String, userName: String, pwd: String) {
        GlobalVariable.shareInstance.loginInfo.server = companyId
        GlobalVariable.shareInstance.loginInfo.userName = userName
        
        let status = ContactStatusEnum(rawValue: (GlobalVariable.shareInstance.getDefaultValue(GlobalVariable.shareInstance.statusKey) as String))!
        let urlString = NSURL(string: "ws://\(companyId).azurewebsites.net/Chat?username=\(userName)&pass=\(pwd)&status=\(status.rawValue)")
        socket = SRWebSocket(URL: urlString)
        socket.delegate = self
        socket.open()
        
        //Conect to Json service
        let jsonConnector = JsonConnector()
        jsonConnector.authenticateDelegate = self
        jsonConnector.authenticate(userName, pwd: pwd)
    }
    
    func didJsonAuthenticate(success: Bool) {
        if !success{
            let alert = UIAlertView(title: "", message: "Cannot connect to Json Service.", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
        }
    }
    
    func reconnect(){
        let keychain = GlobalVariable.shareInstance.loadKeychain()
        self.isReconnect = true
        self.authenticateUser(keychain!.companyId, userName: keychain!.username, pwd: keychain!.pwd)
    }
    
    
    func disconnect(){
        let currentUserName = GlobalVariable.shareInstance.loginInfo.userName
        self.sendMessage("Disconnect~\(currentUserName)")
        self.socket.closeWithCode(10000, reason: "Signed out")
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        let mess = message as String
        let indicator = mess.componentsSeparatedByString("~")[0]
        let value = mess.componentsSeparatedByString("~")[1]
        
        if !self.isReconnect{
            if indicator == MessageIndicator.IsAuthenticate.rawValue {
                if value == "True" {
                    delegateAuthen?.didAuthenticate(true)
                } else {
                    delegateAuthen?.didAuthenticate(false)
                }
            } else if indicator == MessageIndicator.ContactList.rawValue {
                for observer in MessageSocket.sharedInstance.observers.values {
                    observer.didReceiveContact!(mess)
                }
            } else if indicator == MessageIndicator.StatusChange.rawValue {
                let contact = value.componentsSeparatedByString("#")[0]
                let status = value.componentsSeparatedByString("#")[1]
                self.changeContactStatus(contact, status: status)
                for observer in MessageSocket.sharedInstance.observers.values{
                    observer.didChangeStatus!(contact, status: status)
                }
            } else if indicator == MessageIndicator.Message.rawValue {
                let fromContact = value.componentsSeparatedByString("#")[0]
                let toContact = value.componentsSeparatedByString("#")[1]
                let contentMess = value.componentsSeparatedByString("#")[2]
                
                self.updateBubbleMessage(fromContact, toContact: toContact, contentMess: contentMess)
                for observer in MessageSocket.sharedInstance.observers.values{
                    observer.didReceiveMessage!(fromContact, toContact: toContact, contentMess: contentMess)
                }
            }
        }
        else{ //reconnect -> Do nothing
            if indicator == MessageIndicator.IsAuthenticate.rawValue {
                if value == "False" {
                    let alert = UIAlertView(title: "", message: "Login failed.", delegate: nil, cancelButtonTitle: "Ok")
                    alert.show()
                }
            }
            self.isReconnect = false
        }
    }
    
    func changeContactStatus(contactKey:String,status:String){
        var contact = GlobalVariable.shareInstance.contactSource.getContactByKey(GlobalVariable.shareInstance.contactSource, key: contactKey)
        if contact != nil {
            contact?.status = ContactStatusEnum(rawValue: status)!
        }
    }
    
    func getContact() {
        let currentUserName = GlobalVariable.shareInstance.loginInfo.userName
        socket.send("ContactList~\(currentUserName)")
    }
    
    func sendMessage(message:String){
        socket.send(message)
    }
    
    func changeStatus(status:ContactStatusEnum){
        let currentUserName = GlobalVariable.shareInstance.loginInfo.userName
        socket.send("StatusChange~\(currentUserName)#\(status.rawValue)")
    }
    
    func updateBubbleMessage(fromContact: String, toContact:String, contentMess: String){
        var contact: Contact = GlobalVariable.shareInstance.contactSource.getContactByKey(GlobalVariable.shareInstance.contactSource, key: fromContact)!
        contact.recentMessage = contentMess
        
        var uuid = NSUUID().UUIDString
        var messageEntity =  BusinessAccess.createMessageEntity()
        messageEntity.company = GlobalVariable.shareInstance.loginInfo.server!
        messageEntity.userName = GlobalVariable.shareInstance.loginInfo.userName!
        messageEntity.contactFrom = fromContact
        messageEntity.contactTo = toContact
        messageEntity.message = contentMess
        messageEntity.date = NSDate()
        messageEntity.contactRecent = fromContact
        BusinessAccess.saveMessageEntities()
        contact.messageSource.append(messageEntity)
        
        if !contact.showIndicator && !contact.isInConversation{
            contact.showIndicator = true
            self.notifyBagle()
            self.playNotificationSound(SoundNotificationType.NewMessage)
        }
        else{
            self.playNotificationSound(SoundNotificationType.InSessionIncoming)
        }
    }
    
    func notifyBagle(){
        self.delegateNotification?.notify()
    }
    
    func clearNotificationBagle(){
        self.delegateNotification?.clearNotification()
    }
    
    func playNotificationSound(type: SoundNotificationType) {
        let enabledSound = GlobalVariable.shareInstance.getDefaultValue(GlobalVariable.shareInstance.enabledSoundKey) as Bool
        if enabledSound{
            var resourcePath = NSBundle.mainBundle().resourcePath
            var path:NSString!
            switch type{
            case .NewMessage:
                path = NSString(string: "\(resourcePath!)/soundsNewMessage.mp3")
            case .InSessionIncoming:
                path = NSString(string: "\(resourcePath!)/soundInSessionIncoming.mp3")
            case .InSessionOutgoing:
                path = NSString(string: "\(resourcePath!)/soundInSessionOutgoing.mp3")
            }
            var alertSound = NSURL(fileURLWithPath: path)
            var error:NSError?
            audioPlayer = AVAudioPlayer(contentsOfURL: alertSound, error: &error)
            audioPlayer!.play()
        }
    }
    
    func update() {
        self.sendMessage("KeepAlive")
    }
    
    
    
    func webSocketDidOpen(webSocket: SRWebSocket!) {
        timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    
    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError!) {
        if timer != nil{
            timer.invalidate()
            timer = nil
        }
        //54: login fail (connection closed by server)
        //57: network connection unplugged
        if error.code != 54 && error.code != 57{
            let alert = UIAlertView(title: "", message: "\(error)", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
        }
        println(error.code)
    }
    
    func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        if timer != nil{
            timer.invalidate()
            timer = nil
        }
        if code != 1000 && code != 1001{
            let alert = UIAlertView(title: "", message: "\(reason)", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
        }
    }
    
    func register(viewName:String, observer: MessageDelegate) {
        let counts = MessageSocket.sharedInstance.observers.count
        observers[viewName] = observer
    }
    
    func unRegister(viewName:String ,observer: MessageDelegate){
        let counts = MessageSocket.sharedInstance.observers.count
        observers.removeValueForKey(viewName)
        let count = observers.count
    }
    
    func clearObServer(){
        observers.removeAll(keepCapacity: false)
        
    }
    
    func containObServer(obServer:String) -> Bool{
        return observers[obServer] != nil
    }
}
