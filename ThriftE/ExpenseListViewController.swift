//
//  ViewController.swift
//  ThriftE
//
//  Created by Yavor Dimov on 1/4/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import UIKit

class ExpenseListViewController: UITableViewController, AddExpenseViewControllerDelegate {
    
    //MARK: - Protocol delegate implementation
    func addExpenseViewControllerDidCancel(_ controller: AddExpenseViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addExpenseViewController(_ controller: AddExpenseViewController, didFinishAdding item: ExpenseListItem) {
        let newRowIndex = items.count
        
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    
    var items = [ExpenseListItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
    
 
        // Do any additional setup after loading the view, typically from a nib.
        let item1 = ExpenseListItem()
        item1.name = "first row text"
        items.append(item1)
        let item2 = ExpenseListItem()
        item2.name = "yoyoyoitem2here"
        items.append(item2)
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //start with 1 cell
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThriftEItem", for: indexPath) //identifier specified in storyboard for that table view
        let item = items[indexPath.row]
        configureText(for: cell, with: item)
 
        return cell //returns the cell for the current row
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //will deselect the tapped on row and animate
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configureText(for cell: UITableViewCell, with item: ExpenseListItem) {
        let nameLabel = cell.viewWithTag(1000) as! UILabel //this is the tag I gave to the label via storyboard
        let amountLabel = cell.viewWithTag(1001) as! UILabel
        
        nameLabel.text = item.name
        amountLabel.text = item.amount
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExpenseItem" {
            let controller = segue.destination as! AddExpenseViewController
            controller.delegate = self
        }
    }


}

