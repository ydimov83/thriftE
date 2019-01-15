//
//  ViewController.swift
//  ThriftE
//
//  Created by Yavor Dimov on 1/4/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import UIKit

class ExpenseListViewController: UITableViewController, ExpenseDetailViewControllerDelegate {
    
    var items = [ExpenseListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath())
        loadExpenseItems()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    //MARK: - Protocol delegate implementation for AddExpenseViewController
    func expenseDetailViewControllerDidCancel(_ controller: ExpenseDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func expenseDetailViewController(_ controller: ExpenseDetailViewController, didFinishAdding item: ExpenseListItem) {
        let newRowIndex = items.count
        
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
        saveExpenseItems()
    }
    
    func expenseDetailViewController(_ controller: ExpenseDetailViewController, didFinishEditing item: ExpenseListItem) {
        
        if let index = items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell  = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        saveExpenseItems()
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Allows us to delete a row by swiping to delete
        items.remove(at: indexPath.row) //removes the current row from data model
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic) //removes the current row from the view
        saveExpenseItems()
    }
    
    func configureText(for cell: UITableViewCell, with item: ExpenseListItem) {
        let nameLabel = cell.viewWithTag(1000) as! UILabel //this is the tag I gave to the label via storyboard
        let amountLabel = cell.viewWithTag(1001) as! UILabel
        
        nameLabel.text = item.name
        if item.amount.isEmpty {
            amountLabel.text = item.amount
        } else {
            amountLabel.text = "$" + item.amount
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
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    //MARK: - Data management methods
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //Return the app document directory path
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("ThriftE.plist")
    }
    
    func saveExpenseItems() {
        //Allows us to save expense items to a local .plist file
        let encoder = PropertyListEncoder()
        // the do statement here is used since we know that the code after it can throw an error, thus we must be able to catch it if it occurs
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            //If we do encounter an error we want to catch it an log it (in console)
            print("Error encoding item in an array: \(error.localizedDescription)")
        }
    }
    
    func loadExpenseItems() {
        //Allows us to load expense items from the locally saved .plist file
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            // need the try statement since we could fail to read the file or file is not preent
            let decoder = PropertyListDecoder()

            do {
                items = try decoder.decode([ExpenseListItem].self, from: data)
                //need the try statement since we could fail to parse the data into the provided object type, i.e. data is not valid ExpenseListItem(s)
            }
            catch {
                print("Encountered an error loading data from file: \(error.localizedDescription)")
            }
        }
    }
}

