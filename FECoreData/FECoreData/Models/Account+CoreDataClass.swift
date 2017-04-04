//
//  Account+CoreDataClass.swift
//  FECoreData
//
//  Created by keso on 2017/4/2.
//  Copyright © 2017年 FlyElephant. All rights reserved.
//

import Foundation
import CoreData

@objc(Account)
public class Account: NSManagedObject {

    static func findAccountByName(name:String) -> Account? {
        
        let context:NSManagedObjectContext = CoreDataManager.sharedManager.mainQueueContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Account")
        
        let predicate = NSPredicate.init(format: " accountName = %@", name)
        fetchRequest.predicate = predicate
        
        do {
            let searchResults = try context.fetch(fetchRequest)
            if searchResults.count > 0 {
                let account:Account = searchResults[0] as! Account
                return account
            } else {
                return nil
            }
        } catch  {
            print(error)
        }
        
        return nil
    }
    
    static func findAccountByObjectID(objectID:NSManagedObjectID) -> Account? {
        
        let context:NSManagedObjectContext = CoreDataManager.sharedManager.mainQueueContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Account")
        
        let predicate = NSPredicate.init(format: " objectID = %@", objectID)
        fetchRequest.predicate = predicate
        
        do {
            let searchResults = try context.fetch(fetchRequest)
            if searchResults.count > 0 {
                let account:Account = searchResults[0] as! Account
                return account
            } else {
                return nil
            }
        } catch  {
            print(error)
        }
        
        return nil
    }
}
