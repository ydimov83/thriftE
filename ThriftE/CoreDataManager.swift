//
//  CoreDataManager.swift
//  ThriftE
//
//  Created by Yavor Dimov on 3/27/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import Foundation
import CoreData


class CoreDataManager {
    
    static let sharedManager = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: {
            storeDescription, error in
            if let error = error {
                fatalError("Could not load data store: \(error)")
            }
        })
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = persistentContainer.viewContext
 
    
    //MARK: - Helper functions for use with unit tests, actual insert/delete operations are handled by the NSFetchedResultsControllerDelegate implementation in BaseExpenseListViewController
    
    func flushData() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
        let objs = try! CoreDataManager.sharedManager.persistentContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            CoreDataManager.sharedManager.persistentContainer.viewContext.delete(obj)
        }
        
        try! CoreDataManager.sharedManager.persistentContainer.viewContext.save()
    }
    
    func insertExpense(name: String, amount: Double, category: String, date: Date) -> Expense? {
        let entity = NSEntityDescription.entity(forEntityName: "Expense",
                                                in: managedObjectContext)!
        let expense = NSManagedObject(entity: entity,
                                      insertInto: managedObjectContext)

        expense.setValue(name, forKeyPath: "name")
        expense.setValue(amount, forKeyPath: "amount")
        expense.setValue(category, forKeyPath: "category")
        expense.setValue(date, forKeyPath: "date")
  
        do {
            try managedObjectContext.save()
            return expense as? Expense
        } catch let error as NSError { //Catch error from save() call
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func isObjectInDataStore(name: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Expense")
        fetchRequest.predicate = NSPredicate(format: "name == %@" ,name)
        
        do {
            let item = try managedObjectContext.fetch(fetchRequest)
            if item.isEmpty {
                return false
            } else {
                return true
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return false
    }

    func delete(name: String) -> [Expense]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Expense")
        fetchRequest.predicate = NSPredicate(format: "name == %@" ,name)
        do {
            let item = try managedObjectContext.fetch(fetchRequest)
            var arrRemovedExpenses = [Expense]()
            for i in item {
                /*call delete method(aManagedObjectInstance)*/
                /*here i is managed object instance*/
                managedObjectContext.delete(i)
                
                /*finally save the contexts*/
                try managedObjectContext.save()
                
                /*update your array also*/
                arrRemovedExpenses.append(i as! Expense)
            }
            return arrRemovedExpenses
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
}

