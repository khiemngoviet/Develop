
import UIKit
import CoreData

class SwiftCoreDataHelper: NSObject {
    
    class func directoryForDatabaseFilename()->NSString{
        return NSHomeDirectory().stringByAppendingString("/Library/Private Documents")
    }
    
    
    class func databaseFilename()->NSString{
        return "database.sqlite";
    }
    
    
    class func managedObjectContext()->NSManagedObjectContext{
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext!
        return context
    }
    
    class func insertManagedObject(className:NSString, managedObjectConect:NSManagedObjectContext)->AnyObject{
        
        let managedObject:NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName(className, inManagedObjectContext: managedObjectConect) as NSManagedObject
        return managedObject
        
    }
    
    class func saveManagedObjectContext(managedObjectContext:NSManagedObjectContext)->Bool{
        if managedObjectContext.save(nil){
            return true
        }else{
            return false
        }
    }
    
    
    class func fetchEntities(className:NSString, withPredicate predicate:NSPredicate?, managedObjectContext:NSManagedObjectContext)->NSArray{
        let fetchRequest:NSFetchRequest = NSFetchRequest()
        let entetyDescription:NSEntityDescription = NSEntityDescription.entityForName(className, inManagedObjectContext: managedObjectContext)!
        
        fetchRequest.entity = entetyDescription
        if (predicate != nil){
            fetchRequest.predicate = predicate!
        }
        
        fetchRequest.returnsObjectsAsFaults = false
        let items:NSArray = managedObjectContext .executeFetchRequest(fetchRequest, error: nil)!
        
        return items
    }
    
    
}
