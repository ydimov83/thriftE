//
//  AddExpenseViewController.swift
//  ThriftE
//
//  Created by Yavor Dimov on 1/5/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import UIKit
import CoreData


class ExpenseDetailViewController: UITableViewController, UITextFieldDelegate {
    
    var expenseDate = Date()
    var name = ""
    var amount = 0.00
    var date = Date()
    var category = ExpenseCategories.noCategory.rawValue
    var managedObjectContext: NSManagedObjectContext!
    var calendar = Calendar.current
    
    var expenseToEdit: Expense? {
        //When prepare(for:sender:) in ExpenseListViewController is called it is performed before viewDidLoad in this class thus putting the values in place before screen is shown
        didSet {
            if let expense = expenseToEdit {
                name = expense.name
                amount = expense.amount
                date = expense.date
                category = expense.category
            }
        }
    }
    
    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var datePickerField: UIDatePicker!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        nameTextField.becomeFirstResponder()
        // set the text field to first responder, i.e. when user opens screen it will have focus on by default and auto pull up the keyboard so they save time
        amountTextField.keyboardType = .decimalPad
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.timeZone = NSTimeZone.local
        amountTextField.delegate = self // is this necessary?
        nameTextField.delegate = self // is this necessary?
        categoryLabel.text = category
        
        if let expenseToEdit = expenseToEdit {
            title = "Edit Expense" // Switch up the title for the ViewController when editing an expense item
            amountTextField.text = String(expenseToEdit.amount) // set the name and amount to the item we're editing
            nameTextField.text = expenseToEdit.name
            datePickerField.date = expenseToEdit.date
            category = expenseToEdit.category
            categoryLabel.text = category
            doneBarButton.isEnabled = true
        }
        
    }
    
    //MARK: - Tableview delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 2 && indexPath.section == 0 {
            return indexPath
        } else {
            return nil //make sure we disable cell selection if not the category cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let selection = UIView(frame: CGRect.zero)
        selection.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        cell.selectedBackgroundView = selection
    }
    
    
    //MARK: - Actions
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done() {
        //TODO: - Add some checks here to make sure the Double cast doesn't crash app, and better enforce data requirement for it
        
        let expense: Expense

        if let temp = expenseToEdit {
            expense = temp
        } else {
            expense = Expense(context: managedObjectContext)
           
        }
        expense.name = nameTextField.text!
        expense.date = datePickerField.date
        expense.category = category
        //Since I just care about the date and not time, need to store the actual date value as the start of the day for the local time zone. This should avoid issues with filtering on dates by taking the time of day out of the equation
        let tempDate = calendar.startOfDay(for: datePickerField.date)
        expense.date = tempDate
        
        if (amountTextField.text?.isEmpty)! {
            expense.amount = 0.00
        } else {
            expense.amount = Double(amountTextField.text!)!
        }
    
        do {
            try managedObjectContext.save()
        } catch {
            fatalCoreDataError(error)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func expenseCategoryPickerDidSelectCategory(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! ExpenseCategoryPickerViewController
        category = controller.selectedCategoryName
        categoryLabel.text = category
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickExpenseCategory" {
            let controller = segue.destination as! ExpenseCategoryPickerViewController
            controller.selectedCategoryName = category
        }
    }
    
    //MARK: - TextField delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        
        if textField.tag == 1003 {
            let invalidCharacters = CharacterSet(charactersIn: ".0123456789").inverted // limit to numerical characters only with allowance for decimals
            return string.rangeOfCharacter(from: invalidCharacters) == nil
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        //Can use this to set the Done button to disabled when user utilizes the keyboard bar's Clear button to clear out the textField's value
        doneBarButton.isEnabled = false
        return true
    }
    
}

//MARK: - UIPickerViewAccessibility Delegate
extension ExpenseDetailViewController: UIPickerViewAccessibilityDelegate {
    func pickerView(_ pickerView: UIPickerView, accessibilityHintForComponent component: Int) -> String? {
        switch component {
        case 0:
            return "Month"
        case 1:
            return "Day"
        case 2:
            return "Year"
        default:
            return nil
        }
    }
}
