//
//  MessageEntity.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/8/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import Foundation
import CoreData

@objc(MessageEntity)
class MessageEntity: NSManagedObject {

    @NSManaged var company: String
    @NSManaged var contactFrom: String
    @NSManaged var contactTo: String
    @NSManaged var contactRecent: String
    @NSManaged var message: String
    @NSManaged var date: NSDate
    @NSManaged var userName: String

}
