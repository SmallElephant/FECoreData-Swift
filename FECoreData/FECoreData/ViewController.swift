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
        
        let number:Int = 80
        
        let order:Order? = Order.findOrderByID(id: number)
        
        if order != nil {
            print("订单号:\(number)的订单名称:\(order?.orderName)")
            
            let context:NSManagedObjectContext = CoreDataManager.sharedManager.mainQueueContext
            
            context.delete(order!)
            
            if context.hasChanges {
                do {
                    print("\(number)删除成功")
                    try context.save()
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
    
    
    func setUp() {
        
    }

}

