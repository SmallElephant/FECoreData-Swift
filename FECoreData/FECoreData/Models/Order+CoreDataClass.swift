//
//  Order+CoreDataClass.swift
//  FECoreData
//
//  Created by keso on 2017/4/2.
//  Copyright © 2017年 FlyElephant. All rights reserved.
//

import Foundation
import CoreData

@objc(Order)
public class Order: NSManagedObject {
    
     static func findOrderByID(id:Int) -> Order? {
        
        let context:NSManagedObjectContext = CoreDataManager.sharedManager.mainQueueContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Order")
        
        let predicate = NSPredicate.init(format: " orderNumber = %@", "\(id)")
        fetchRequest.predicate = predicate
        
        do {
            let searchResults = try context.fetch(fetchRequest)
            if searchResults.count > 0 {
                let order:Order = searchResults[0] as! Order
                return order
            } else {
                return nil
            }
        } catch  {
            print(error)
        }
        
        return nil
    }
    
    static func findAllOrders() {
        
        let context:NSManagedObjectContext = CoreDataManager.sharedManager.mainQueueContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Order")
        
        let sortDescriptor = NSSortDescriptor.init(key: "orderNumber", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let searchResults = try context.fetch(fetchRequest)
            if searchResults.count > 0 {
                
                for i in 0..<searchResults.count {
                    let order:Order = searchResults[i] as! Order
                    print("FlyElephant-订单编号:\(order.orderNumber)---订单名称:\(order.orderName!)")
                }
            } else {
                
            }
        } catch  {
            print(error)
        }
        
    }


}
