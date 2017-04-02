//
//  Account+CoreDataProperties.swift
//  FECoreData
//
//  Created by keso on 2017/4/2.
//  Copyright © 2017年 FlyElephant. All rights reserved.
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account");
    }

    @NSManaged public var accountID: String?
    @NSManaged public var accountName: String?
    @NSManaged public var age: Int32
    @NSManaged public var gender: Bool

}
