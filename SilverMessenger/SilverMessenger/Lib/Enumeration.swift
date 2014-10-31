//
//  Enumeration.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/15/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import Foundation

enum MessageIndicator: String{
    case IsAuthenticate = "IsAuthenticate"
    case ContactList = "ContactList"
    case StatusChange = "StatusChange"
    case Message = "Message"
    case MessageOffline = "MessageOffline"
}

enum ContactStatusEnum: String {
    case Online = "Online"
    case Offline = "Offline"
    case Invisible = "InVisible"
    case Away = "Away"
    case DoNotDisturb = "DoNotDisturb"
}

enum SoundNotificationType{
    case NewMessage
    case InSessionIncoming
    case InSessionOutgoing
}

enum NoteType:String{
    case Policy = "Policy"
    case BusinessEntity = "BusinessEntity"
}



