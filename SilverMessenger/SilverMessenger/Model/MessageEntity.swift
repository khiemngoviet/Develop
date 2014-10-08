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

    @NSManaged var contactFrom: String
    @NSManaged var content: String
    @NSManaged var date: NSDate
    @NSManaged var contactTo: String
    @NSManaged var contact: String
    @NSManaged var company: String
}
