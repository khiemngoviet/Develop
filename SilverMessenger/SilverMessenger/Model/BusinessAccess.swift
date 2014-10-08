//
//  BusinessAccess.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/8/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import Foundation
import CoreData

class BusinessAccess{
    
    class func createMessageEntity(context: NSManagedObjectContext) -> MessageEntity {
        var messageEntity:MessageEntity = SwiftCoreDataHelper.insertManagedObject(NSStringFromClass(MessageEntity), managedObjectConect: context) as MessageEntity
        return messageEntity
    }
    
    class func saveMessageEntities(context: NSManagedObjectContext) {
        SwiftCoreDataHelper.saveManagedObjectContext(context)
    }
    
    class func getMessages(context: NSManagedObjectContext) -> NSArray {
        let results:NSArray = SwiftCoreDataHelper.fetchEntities(NSStringFromClass(MessageEntity), withPredicate: nil, managedObjectContext: context)
        return results
    }
    
    class func getMessageByContact(contact:String, context: NSManagedObjectContext) -> NSArray {
        let request = NSFetchRequest(entityName: NSStringFromClass(MessageEntity))
        request.predicate = NSPredicate(format: "contact == %@", contact)
        request.returnsObjectsAsFaults = false
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        return results
    }
    
    class func getDistinctContact(context: NSManagedObjectContext) -> NSArray {
        let request = NSFetchRequest(entityName: NSStringFromClass(MessageEntity))
        request.propertiesToFetch = NSArray(object: "contact")
        request.returnsObjectsAsFaults = false
        request.returnsDistinctResults = true
        request.resultType = NSFetchRequestResultType.DictionaryResultType
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        return results
    }
    
    class func deleteAllMessages(context: NSManagedObjectContext){
        let results:NSArray = SwiftCoreDataHelper.fetchEntities(NSStringFromClass(MessageEntity), withPredicate: nil, managedObjectContext: context)
        for message in results {
            context.deleteObject(message as NSManagedObject)
        }
        context.save(nil)
    }
    
}