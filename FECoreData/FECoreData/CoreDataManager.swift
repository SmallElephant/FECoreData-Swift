//
//  CoreDataManager.swift
//  FECoreData
//
//  Created by keso on 2017/3/26.
//  Copyright © 2017年 FlyElephant. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    // MARK: 初始化
    
    static let sharedManager = CoreDataManager()
    static let applicationDocumentsDirectoryName = "com.coredata.www"
    static let mainStoreFileName = "FECoreData.sqlite"
    static let errorDomain = "CoreDataManager"
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "FECoreData", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    // Primary persistent store coordinator for the application.
    //
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        // This implementation creates and return a coordinator, having added the
        // store for the application to it. (The directory for the store is created, if necessary.)
        //
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
            
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL as URL, options: options)
        }
        catch {
            fatalError("持久化存储错误: \(error).")
        }
        
        return persistentStoreCoordinator
    }()
    
    
    lazy var mainQueueContext: NSManagedObjectContext = {
        
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        // Avoid using default merge policy in multi-threading environment:
        // when we delete (and save) a record in one context,
        // and try to save edits on the same record in the other context before merging the changes,
        // an exception will be thrown because Core Data by default uses NSErrorMergePolicy.
        // Setting a reasonable mergePolicy is a good practice to avoid that kind of exception.
        
        moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        // In macOS, a context provides an undo manager by default
        // Disable it for performance benefit
        //
        moc.undoManager = nil
        
        return moc
    }()
    
    
    /// CoreData 文件存储目录
    //
    lazy var applicationSupportDirectory: URL = {
        
        let fileManager = FileManager.default
        var supportDirectory:URL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).last!
        
        var saveUrl:URL = supportDirectory.appendingPathComponent(applicationDocumentsDirectoryName)
        
        if fileManager.fileExists(atPath: saveUrl.path) == false {
            let path = saveUrl.path
            
            do {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories:true, attributes:nil)
            }
            catch {
                fatalError("文件存储目录创建失败: \(path).")
            }
        }
        
        return saveUrl
    }()
    
    
    lazy var storeURL: URL = {
        return self.applicationSupportDirectory.appendingPathComponent(mainStoreFileName)
        }()
    
    
    // 创建私有CoreData存储线程
    func newPrivateQueueContextWithNewPSC() throws -> NSManagedObjectContext {
        
        // Stack uses the same store and model, but a new persistent store coordinator and context.
        //
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: CoreDataManager.sharedManager.managedObjectModel)
        
        // Attempting to add a persistent store may yield an error--pass it out of
        // the function for the caller to deal with.
        //
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: CoreDataManager.sharedManager.storeURL as URL, options: nil)
        
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        context.performAndWait() {
            
            context.persistentStoreCoordinator = coordinator
            
            // Avoid using default merge policy in multi-threading environment:
            // when we delete (and save) a record in one context,
            // and try to save edits on the same record in the other context before merging the changes,
            // an exception will be thrown because Core Data by default uses NSErrorMergePolicy.
            // Setting a reasonable mergePolicy is a good practice to avoid that kind of exception.
            //
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            // In macOS, a context provides an undo manager by default
            // Disable it for performance benefit
            //
            context.undoManager = nil
        }
        
        return context
    }
}
