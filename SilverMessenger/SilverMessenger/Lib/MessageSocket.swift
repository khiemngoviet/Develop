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

class MessageSocket: NSObject, SRWebSocketDelegate {
    
    var socket: SRWebSocket!
    
    var delegateAuthen: AuthenticateDelegate?
    var delegateNotification: NotificationDelegate?
    
    var observers = [String: MessageDelegate]()
    
    class var sharedInstance: MessageSocket {
        return _shareInstance
    }
    
    func authenticateUser(companyId: String, userName: String, pwd: String) {
        GlobalVariable.shareInstance.loginInfo.server = companyId
        GlobalVariable.shareInstance.loginInfo.userName = userName
        let urlString = NSURL(string: "ws://\(companyId).azurewebsites.net/Chat?username=\(userName)&pass=\(pwd)&status=Online")
        socket = SRWebSocket(URL: urlString)
        socket.delegate = self
        socket.open()
    }
    
    func register(viewName:String, observer: MessageDelegate) {
        observers[viewName] = observer
    }
    
    func unRegister(viewName:String ,observer: MessageDelegate){
       observers.removeValueForKey(viewName)
        let count = observers.count
    }
    
    func disconnect(){
        let currentUserName = GlobalVariable.shareInstance.loginInfo.userName
        self.sendMessage("Disconnect~\(currentUserName)")
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        let mess = message as String
        let indicator = mess.componentsSeparatedByString("~")[0]
        let value = mess.componentsSeparatedByString("~")[1]
        if indicator == MessageIndicator.IsAuthenticate.rawValue {
            if value == "True" {
                delegateAuthen?.didAuthenticate(true)
                self.getContact() //getContact
            } else {
                delegateAuthen?.didAuthenticate(false)
            }
        } else if indicator == MessageIndicator.ContactList.rawValue {
            for observer in observers.values {
                observer.didReceiveContact!(mess)
            }
        } else if indicator == MessageIndicator.StatusChange.rawValue {
            let contact = value.componentsSeparatedByString("#")[0]
            let status = value.componentsSeparatedByString("#")[1]
            for observer in observers.values{
                observer.didChangeStatus!(contact, status: status)
            }
        } else if indicator == MessageIndicator.Message.rawValue {
            let fromContact = value.componentsSeparatedByString("#")[0]
            let toContact = value.componentsSeparatedByString("#")[1]
            let contentMess = value.componentsSeparatedByString("#")[2]
            
            self.updateBubbleMessage(fromContact, toContact: toContact, contentMess: contentMess)
            for observer in observers.values{
                observer.didReceiveMessage!(fromContact, toContact: toContact, contentMess: contentMess)
            }
        }
        
    }
    
    func getContact() {
        let currentUserName = GlobalVariable.shareInstance.loginInfo.userName
        socket.send("ContactList~\(currentUserName)")
    }
    
    func sendMessage(message:String){
        socket.send(message)
    }
    
    func updateBubbleMessage(fromContact: String, toContact:String, contentMess: String){
        var contact: Contact = GlobalVariable.shareInstance.contactSource[fromContact]!
        contact.recentMessage = contentMess
        createChaChingSound()
       
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
            self.delegateNotification?.notify()
        }
    }
    
    func createChaChingSound() {
        var audioPlayer = AVAudioPlayer()
        
        var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("NewMessage", ofType: "wav")!)
        println(alertSound)
        
        // Removed deprecated use of AVAudioSessionDelegate protocol
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: alertSound, error: &error)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func webSocketDidOpen(webSocket: SRWebSocket!) {
        
    }
    
    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError!) {
        
    }
    
    func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        
    }
}
