//
//  ViewController.swift
//  FECoreData
//
//  Created by keso on 2017/3/26.
//  Copyright © 2017年 FlyElephant. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var searchOrder:Order?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let corepath:String = CoreDataManager.sharedManager.applicationSupportDirectory.absoluteString
        print("本地路径:\(corepath)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func addAction(_ sender: UIButton) {
        
        for i in 1...100 {
            let context:NSManagedObjectContext = CoreDataManager.sharedManager.mainQueueContext
            let order:Order = NSEntityDescription.insertNewObject(forEntityName: "Order", into: context) as! Order
            order.orderName = "台湾小零食--\(i)"
            order.orderNumber = Int32(i)
            if context.hasChanges {
                do {
                    print("保存成功")
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }

    }
    
    func test() {
        let context:NSManagedObjectContext = CoreDataManager.sharedManager.mainQueueContext
        let account:Account = NSEntityDescription.insertNewObject(forEntityName: "Account", into: context) as! Account
        account.accountName = "FlyElephant"
        account.accountID = "abc-123"
        account.age = 27
        account.gender = true
        if context.hasChanges {
            do {
                print("保存成功")
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    @IBAction func updateAction(_ sender: UIButton) {
        let number:Int = 30
        
        let order:Order? = Order.findOrderByID(id: number)
        
        if order != nil {
            print("订单号:\(number)的订单名称:\(order?.orderName)")
            
            order?.orderName = "FlyElephant\(number)_update"
            let context:NSManagedObjectContext = CoreDataManager.sharedManager.mainQueueContext
            
            if context.hasChanges {
                do {
                    print("更新成功")
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
            
        }
        
    }
    
    
    @IBAction func deleteAction(_ sender: UIButton) {
        
        let number:Int = 96
        
        let order:Order? = Order.findOrderByID(id: number)
        
        if order != nil {
            print("订单号:\(number)的订单名称:\(order?.orderName)")
            
            let context:NSManagedObjectContext = CoreDataManager.sharedManager.mainQueueContext
            
            self.searchOrder = order!
            
            context.delete(order!)
            
            if context.hasChanges {
                do {
                    
                    print("\(number)删除成功")
                   // try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        
        Order.findAllOrders()
    }
    
    
    @IBAction func relationAction(_ sender: UIButton) {
        do {

            let account:Account = Account.findAccountByName(name: "FlyElephant")!
            
            let privateContext:NSManagedObjectContext = try CoreDataManager.sharedManager.newPrivateQueueContextWithNewPSC()
            
            let order:Order = NSEntityDescription.insertNewObject(forEntityName: "Order", into: privateContext) as! Order
            order.orderName = "FlyElephant-台湾小零食--\(1)"
            order.orderNumber = Int32(100)
        
            let accountInContext:Account = privateContext.object(with: account.objectID) as! Account
            order.account = accountInContext
            
            if privateContext.hasChanges {
                do {
                    print("保存成功")
                    try privateContext.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }  catch {
            print(error)
        }
    }
    
    @IBAction func fillAction(_ sender: UIButton) {
        let context:NSManagedObjectContext = CoreDataManager.sharedManager.mainQueueContext
        
        self.searchOrder?.account?.accountName = "FlyElephant"
        
        do {
            print("fill成功")
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
    }
    
    
    func setUp() {
        
    }

}

