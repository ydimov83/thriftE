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
    
    var categoryFilter = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = categoryFilter
        cellIdentifier = "FilteredExpenseListItem"
        fetchedResultsController = {
            let fetchRequest = NSFetchRequest<Expense>()
            
            let entity = Expense.entity()
            fetchRequest.entity = entity
            
            if categoryFilter != "" {
                fetchRequest.predicate = NSPredicate(format: "category == %@", categoryFilter)
            }
            
            let sortDate = NSSortDescriptor(key: "date", ascending: false)
            fetchRequest.sortDescriptors = [sortDate]
            
            
            fetchRequest.fetchBatchSize = 20
            
            let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Expenses")
            fetchedResultsController.delegate = self
            return fetchedResultsController
        }()
        performFetch()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let expense = fetchedResultsController.object(at: indexPath)
        configureText(for: cell, with: expense)
        
        let selection = UIView(frame: CGRect.zero)
        selection.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        cell.selectedBackgroundView = selection
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.lightGray
        
        return cell
    }
    
}
