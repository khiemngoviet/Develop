//
//  User.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/10/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import Foundation
import CoreData

@objc(User)
class User: NSManagedObject {

    @NSManaged var company: String
    @NSManaged var userName: String
    @NSManaged var password: String
    @NSManaged var userId: String

}
