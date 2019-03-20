//
//  ExpenseCategoryViewController.swift
//  ThriftE
//
//  Created by Yavor Dimov on 2/26/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import UIKit

class ExpenseCategoryPickerViewController: UITableViewController {
    
    var selectedCategoryName = ""
    var selectedIndexPath = IndexPath()
    var categories: ExpenseCategories!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for category in ExpenseCategories.allCases {
            if category.rawValue == selectedCategoryName {
                selectedIndexPath = IndexPath(row: category.hashValue, section: 0)
                break
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ExpenseCategories.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCategoryCell", for: indexPath)
        let categoryName = getCategoryNameFromHashValue(hashValue: indexPath.row).rawValue
        
        cell.textLabel?.text = categoryName
        cell.textLabel?.textColor = UIColor.white
        cell.accessibilityIdentifier = categoryName
        cell.imageView?.image = UIImage(named: categoryName)
        cell.imageView?.backgroundColor = UIColor.black
        
        let selection = UIView(frame: CGRect.zero)
        selection.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        cell.selectedBackgroundView = selection
        
        if categoryName == selectedCategoryName {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != selectedIndexPath.row {
            if let newCell = tableView.cellForRow(at: indexPath) {
                newCell.accessoryType = .checkmark
            }
            if let oldCell = tableView.cellForRow(at: selectedIndexPath) {
                oldCell.accessoryType = .none
            }
            selectedIndexPath = indexPath
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Used as part of the unwind segue to send the picked cateogry back to LocationDetailsViewController
        
        if segue.identifier == "PickedExpenseCategory" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                selectedCategoryName = getCategoryNameFromHashValue(hashValue: indexPath.row).rawValue
            }
        }
    }

}
