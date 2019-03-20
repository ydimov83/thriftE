//
//  BaseExpenseListViewController.swift
//  ThriftE
//
//  Created by Yavor Dimov on 3/17/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//
import UIKit
import CoreData

class BaseExpenseListViewController: UITableViewController {
    
    var cellIdentifier = ""
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
        return sectionInfo.name.uppercased()    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let labelRect = CGRect(x: 15, y: tableView.sectionHeaderHeight - 14, width: 300, height: 14)
        let label = UILabel(frame: labelRect)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = tableView.dataSource!.tableView!(tableView, titleForHeaderInSection: section)
        label.textColor = UIColor(white: 1.0, alpha: 0.65)
        label.backgroundColor = UIColor.clear
        
        let separatorRect = CGRect(x: 15, y: tableView.sectionHeaderHeight - 0.5 , width: tableView.bounds.size.width - 15 , height: 0.5)
        let separator = UIView(frame: separatorRect)
        separator.backgroundColor = tableView.separatorColor
        
        let viewRect = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.sectionHeaderHeight)
        let view = UIView(frame: viewRect)
        view.backgroundColor = UIColor(white: 0, alpha: 0.85)
        view.addSubview(label)
        view.addSubview(separator)
        
        return view
    }
    
    //MARK: - Helper Methods
    func configureText(for cell: UITableViewCell, with expense: Expense) -> UITableViewCell {
        cell.textLabel?.text = expense.name
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        let dateLabel = formatter.string(from: expense.date)
        if expense.amount > 0 {
            cell.detailTextLabel?.text = "$\(expense.amount) \(dateLabel)"
        } else {
            cell.detailTextLabel?.text = dateLabel
        }
        return cell
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
    
}

//MARK: - NSFetchedResultsControllerDelegate implementation
extension BaseExpenseListViewController: NSFetchedResultsControllerDelegate {
    
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
