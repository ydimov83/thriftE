//
//  ViewController.swift
//  ThriftE
//
//  Created by Yavor Dimov on 1/4/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import UIKit
import CoreData

class ExpenseListViewController: BaseExpenseListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        cellIdentifier = "ThriftEItem"
        fetchedResultsController = {
            let fetchRequest = NSFetchRequest<Expense>()
            
            let entity = Expense.entity()
            fetchRequest.entity = entity
            
            let sortDate = NSSortDescriptor(key: "date", ascending: false)
            fetchRequest.sortDescriptors = [sortDate]
            
            fetchRequest.fetchBatchSize = 20
            
            let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Expenses")
            fetchedResultsController.delegate = self
            return fetchedResultsController
        }()
        performFetch()
    }
}
