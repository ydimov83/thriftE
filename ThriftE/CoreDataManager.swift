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
    
    //TODO: - Probably need to take out the fetchedResultsController property from this class
    
    lazy var fetchedResultsController: NSFetchedResultsController<Expense> = {
        let fetchRequest = NSFetchRequest<Expense>()
        
        let entity = Expense.entity()
        fetchRequest.entity = entity
        
        let sortCategory = NSSortDescriptor(key: "category", ascending: true)
        let sortDate = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortCategory, sortDate]
        
        fetchRequest.fetchBatchSize = 20
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "category", cacheName: "Expenses")
        fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate
        return fetchedResultsController
    }()
}
