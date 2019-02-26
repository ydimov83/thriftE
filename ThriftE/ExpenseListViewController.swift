//
//  ViewController.swift
//  ThriftE
//
//  Created by Yavor Dimov on 1/4/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import UIKit

class ExpenseListViewController: UITableViewController, ExpenseDetailViewControllerDelegate {
    
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataModel.updateTotal()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - Protocol delegate implementation for AddExpenseViewController
    func expenseDetailViewControllerDidCancel(_ controller: ExpenseDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func expenseDetailViewController(_ controller: ExpenseDetailViewController, didFinishAdding item: ExpenseListItem) {
        let newRowIndex = dataModel.items.count
        
        dataModel.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        dataModel.updateTotal()
        navigationController?.popViewController(animated: true)
    }
    
    func expenseDetailViewController(_ controller: ExpenseDetailViewController, didFinishEditing item: ExpenseListItem) {
        
        if let index = dataModel.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell  = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        dataModel.updateTotal()
        navigationController?.popViewController(animated: true)
    }
    
   
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //start with 1 cell
        return dataModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThriftEItem", for: indexPath) //identifier specified in storyboard for that table view
        let item = dataModel.items[indexPath.row]
        configureText(for: cell, with: item)
 
        return cell //returns the cell for the current row
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //will deselect the tapped on row and animate
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Allows us to delete a row by swiping to delete
        dataModel.items.remove(at: indexPath.row) //removes the current row from data model
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic) //removes the current row from the view
        dataModel.updateTotal()
    }
    
    func configureText(for cell: UITableViewCell, with item: ExpenseListItem) {
        cell.textLabel?.text = item.name
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        let dateLabel = formatter.string(from: item.date)
        if item.amount > 0 {
            cell.detailTextLabel?.text = "$ \(item.amount) \(dateLabel)"
        } else {
            cell.detailTextLabel?.text = dateLabel
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExpenseItem" {
            let controller = segue.destination as! ExpenseDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditExpenseItem" {
            let controller = segue.destination as! ExpenseDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = dataModel.items[indexPath.row]
            }
        }
    }
 
}
