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
        // 对应存储的模型FECoreData.xcdatamodeld
        let modelURL = Bundle.main.url(forResource: "FECoreData", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    // 持久化协调器
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            // 自动升级选项设置
            let options = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
            
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL as URL, options: options)
        }
        catch {
            fatalError("FlyElephant持久化存储错误: \(error).")
        }
        
        return persistentStoreCoordinator
    }()
    
    
    lazy var mainQueueContext: NSManagedObjectContext = {
        
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        // 避免多线程中出现问题，如果有属性和内存中都发生了改变，以内存中的改变为主
        moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
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
            print("文件存储路径:\(path)")
            do {
                
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories:true, attributes:nil)
            }
            catch {
                fatalError("FlyElephant文件存储目录创建失败: \(path).")
            }
        }
        
        return saveUrl
    }()
    
    
    lazy var storeURL: URL = {
        return self.applicationSupportDirectory.appendingPathComponent(mainStoreFileName)
        }()
    
    
    // 创建私有CoreData存储线程
    func newPrivateQueueContextWithNewPSC() throws -> NSManagedObjectContext {
        
        // 子线程中创建新的持久化协调器
        //
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: CoreDataManager.sharedManager.managedObjectModel)
        
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: CoreDataManager.sharedManager.storeURL as URL, options: nil)
        
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        context.performAndWait() {
            
            context.persistentStoreCoordinator = coordinator
            
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
        }
        
        return context
    }
}
