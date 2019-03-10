//
//  ViewController.swift
//  ThriftE
//
//  Created by Yavor Dimov on 1/4/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import UIKit
import CoreData

class ExpenseListViewController: UITableViewController {
    
    var filteredExpenses = [Expense]()
    var managedObjectContext: NSManagedObjectContext!
    lazy var fetchedResultsController: NSFetchedResultsController<Expense> = {
        let fetchRequest = NSFetchRequest<Expense>()
        
        let entity = Expense.entity()
        fetchRequest.entity = entity
        
        let sortCategory = NSSortDescriptor(key: "category", ascending: true)
        let sortDate = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortCategory, sortDate]
        
        fetchRequest.fetchBatchSize = 20
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "category", cacheName: "Expenses")
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performFetch()
    }
    
    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThriftEItem", for: indexPath)
        let expense = fetchedResultsController.object(at: indexPath)
        configureText(for: cell, with: expense)
 
        return cell
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Allows us to delete a row by swiping to delete
        if editingStyle == .delete {
            let expense = fetchedResultsController.object(at: indexPath)
            managedObjectContext.delete(expense)
            do {
                try managedObjectContext.save()
            } catch {
                fatalCoreDataError(error)
            }
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExpenseItem" {
            let controller = segue.destination as! ExpenseDetailViewController
            controller.managedObjectContext = managedObjectContext
        } else if segue.identifier == "EditExpenseItem" {
            let controller = segue.destination as! ExpenseDetailViewController
            controller.managedObjectContext = managedObjectContext
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                let expense = fetchedResultsController.object(at: indexPath)
                controller.expenseToEdit = expense
            }
        }
    }
    
    //MARK: - Helper Methods
    func configureText(for cell: UITableViewCell, with expense: Expense) {
        cell.textLabel?.text = expense.name
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        let dateLabel = formatter.string(from: expense.date)
        if expense.amount > 0 {
            cell.detailTextLabel?.text = "$ \(expense.amount) \(dateLabel)"
        } else {
            cell.detailTextLabel?.text = dateLabel
        }
    }
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    deinit {
        //Method invoked when view controller is destroyed, this way we ensure we stop getting any further notifications that may have been pending
        fetchedResultsController.delegate = nil
    }
    
//    func filterExperiment(filter: String) {
//        let indexPath = IndexPath(
//        fetchedResultsController.indexPath(forObject: <#T##Expense#>)
//        tableView.reloadSections(<#T##sections: IndexSet##IndexSet#>, with: <#T##UITableView.RowAnimation#>)
//        fetchedResultsController.object(at: <#T##IndexPath#>)

//        for section in fetchedResultsController.sections! {
//            print(section.name)
//
//        }
//        let indexSet = IndexSet(integer: 1)
//        tableView.deleteSections(indexSet, with: .fade)
//        tableView.reloadData()
//
//    }
 
}

//MARK: - NSFetchedResultsControllerDelegate implementation
extension ExpenseListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("*** controllerWillChangeContent")
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            print("*** NSFetchResultsChangeInsert (object)")
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            print("*** NSFetchResultsChangeDelete (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            print("*** NSFetchResultsChangeUpdate (object)")
            if let cell = tableView.cellForRow(at: indexPath!) {
                let expense = controller.object(at: indexPath!) as! Expense
                configureText(for: cell, with: expense)
            }
        case .move:
            print("*** NSFetchResultsChangeMove (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            print("*** NSFetchResultsChangeInsert (section)")
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            print("*** NSFetchResultsChangeDelete (section)")
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .update:
            print("*** NSFetchResultsChangeUpdate (section)")
        case .move:
            print("*** NSFetchResultsChangeMove (section)")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("*** controllerDidChangeContent")
        tableView.endUpdates()
    }
}
