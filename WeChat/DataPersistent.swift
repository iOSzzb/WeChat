//
//  DataPersistent.swift
//  WeChat
//
//  Created by Harold on 15/7/16.
//  Copyright (c) 2015年 GetStarted. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class DataPersistent {
    
    //单例模式写法
    struct singleton {
        static let singleton:DataPersistent = DataPersistent()
    }
    class func shareDataPersistent()->DataPersistent{
        return singleton.singleton
    }
    
    
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "GetStarted.Contacs" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("MessageModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("MessageModel.sqlite")
        println(url)
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
//    func queryMessage(username:String)-> [AnyObject]? {
//        var request = NSFetchRequest(entityName: "Message")
//        var predicate = NSPredicate(format: "user == \"\(username)\"")
//        request.predicate = predicate
//        let message = context?.executeFetchRequest(request, error: nil)
//        return message
//    }
//
//    
//    func insertFriend(friend:userInfo) {
//        
//        var friendInfo:Friends = NSEntityDescription.insertNewObjectForEntityForName("Friends", inManagedObjectContext: self.managedObjectContext!) as! Friends
//        friendInfo.friendInfo = friend
//        saveContext()
//    }
    
    func insertMessage(message:messageInfo)->Messages {
        
        var messages:Messages = NSEntityDescription.insertNewObjectForEntityForName("Messages", inManagedObjectContext: self.managedObjectContext!) as! Messages
        messages.message = message.messageBody
        messages.messageId = message.messageID
        messages.userName = message.user?.name
        messages.userId = message.user?.id
        messages.time = message.messageTime
        messages.targetName = message.target?.name
        messages.imageUrl = message.messageImageUrl
        self.saveContext()
        return messages

    }
    
//    func queryFriend()->[Friends] {
//        
//        var request = NSFetchRequest(entityName: "Friends")
//        var result = self.managedObjectContext?.executeFetchRequest(request, error: nil) as! [Friends]
//        return result
//    }
    

}
