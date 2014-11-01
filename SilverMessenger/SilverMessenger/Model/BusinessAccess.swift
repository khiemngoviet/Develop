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

    
    class func createMessageEntity() -> MessageEntity {
        let context = CoreDataHelper.managedObjectContext()
        var messageEntity:MessageEntity = CoreDataHelper.insertManagedObject(NSStringFromClass(MessageEntity), managedObjectConect: context) as MessageEntity
        return messageEntity
    }
    
    class func saveMessageEntities() {
        let context = CoreDataHelper.managedObjectContext()
        CoreDataHelper.saveManagedObjectContext(context)
    }

    class func getRecentMessageByContact(contact:String) -> (latestDate:NSDate, recentMess:String)? {
        let context = CoreDataHelper.managedObjectContext()
        let sorDesc = NSSortDescriptor(key: "date", ascending: false)
        let request = NSFetchRequest(entityName: NSStringFromClass(MessageEntity))
        let company = GlobalVariable.shareInstance.loginInfo.server!
        let userName = GlobalVariable.shareInstance.loginInfo.userName!
        request.predicate = NSPredicate(format: "company == %@ AND userName == %@ AND (contactFrom == %@ OR contactTo == %@)",company, userName, contact, contact)
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [sorDesc]
        request.fetchLimit = 1
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        if results.count > 0{
            return ((results.firstObject as MessageEntity).date, (results.firstObject as MessageEntity).message)
        }
        return nil
    }
    
    class func getMessageByContact(contact:String) -> NSArray {
        let context = CoreDataHelper.managedObjectContext()
        let request = NSFetchRequest(entityName: NSStringFromClass(MessageEntity))
        let company = GlobalVariable.shareInstance.loginInfo.server!
        let userName = GlobalVariable.shareInstance.loginInfo.userName!
        request.predicate = NSPredicate(format: "company == %@ AND userName == %@ AND (contactFrom == %@ OR contactTo == %@)",company, userName, contact, contact)
        request.returnsObjectsAsFaults = false
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        return results
    }
    
    class func getDistinctContact() -> NSArray {
        let context = CoreDataHelper.managedObjectContext()
        let request = NSFetchRequest(entityName: NSStringFromClass(MessageEntity))
        let company = GlobalVariable.shareInstance.loginInfo.server!
        let userName = GlobalVariable.shareInstance.loginInfo.userName!
        request.predicate = NSPredicate(format: "company == %@ AND userName == %@",company, userName)
        request.propertiesToFetch = NSArray(object: "contactRecent")
        request.returnsObjectsAsFaults = false
        request.returnsDistinctResults = true
        request.resultType = NSFetchRequestResultType.DictionaryResultType
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        return results
    }
    
    class func deleteAllMessages(){
        let context = CoreDataHelper.managedObjectContext()
        let company = GlobalVariable.shareInstance.loginInfo.server!
        let userName = GlobalVariable.shareInstance.loginInfo.userName!
        let predicate = NSPredicate(format: "company == %@ AND userName == %@",company, userName)
        let results:NSArray = CoreDataHelper.fetchEntities(NSStringFromClass(MessageEntity), withPredicate: predicate, managedObjectContext:context)
        for message in results {
            context.deleteObject(message as NSManagedObject)
        }
        context.save(nil)
    }
    
    class func deleteMessageByContact(contact:String){
        let context = CoreDataHelper.managedObjectContext()
        let results = self.getMessageByContact(contact)
        for message in results {
            context.deleteObject(message as NSManagedObject)
        }
        context.save(nil)
    }
    
}