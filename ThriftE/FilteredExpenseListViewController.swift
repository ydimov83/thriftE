//
//  FilteredExpenseListController.swift
//  ThriftE
//
//  Created by Yavor Dimov on 3/17/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import UIKit
import CoreData

class FilteredExpenseListViewController: BaseExpenseListViewController {
    
    //Actual values will be set via the segue from AnalyzeExpensesViewController
    
    var categoryFilter = ""
    var fromDate =  Date()
    var toDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellIdentifier =  "FilteredExpenseListItem"
        self.title = categoryFilter
        fetchedResultsController = setFetchedResultsController(fromDate: fromDate, toDate: toDate, categoryFilter: categoryFilter)
        performFetch()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditExpenseItem" {
            let controller = segue.destination as! ExpenseDetailViewController
            controller.managedObjectContext = managedObjectContext
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                let expense = fetchedResultsController.object(at: indexPath)
                controller.expenseToEdit = expense
            }
        }
    }
    
    //MARK: - Helpers
    func setFetchedResultsController(fromDate: Date, toDate: Date, categoryFilter: String) -> NSFetchedResultsController<Expense> {
        
        let fetchRequest = NSFetchRequest<Expense>()
        
        let entity = Expense.entity()
        fetchRequest.entity = entity
        
        let predicate =  NSPredicate(format: "date >= %@ && date < %@ && category == %@", fromDate as CVarArg, toDate as CVarArg, categoryFilter)
        fetchRequest.predicate = predicate
        
        let sortDate = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDate]
        fetchRequest.fetchBatchSize = 20
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Expenses")
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }
    
}
