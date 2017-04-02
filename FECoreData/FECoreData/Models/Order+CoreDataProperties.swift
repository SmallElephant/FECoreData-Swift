//
//  Order+CoreDataProperties.swift
//  FECoreData
//
//  Created by keso on 2017/4/2.
//  Copyright © 2017年 FlyElephant. All rights reserved.
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order");
    }

    @NSManaged public var orderName: String?
    @NSManaged public var orderNumber: Int32

}
