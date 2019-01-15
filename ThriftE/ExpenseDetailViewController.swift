//
//  AddExpenseViewController.swift
//  ThriftE
//
//  Created by Yavor Dimov on 1/5/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import UIKit

protocol ExpenseDetailViewControllerDelegate: class {
    func expenseDetailViewControllerDidCancel(_ controller: ExpenseDetailViewController)
    func expenseDetailViewController(_ controller: ExpenseDetailViewController, didFinishAdding item: ExpenseListItem)
    func expenseDetailViewController(_ controller: ExpenseDetailViewController, didFinishEditing item: ExpenseListItem)
}

class ExpenseDetailViewController: UITableViewController, UITextFieldDelegate {
    
    var itemToEdit: ExpenseListItem?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        nameTextField.becomeFirstResponder()
        // set the text field to first responder, i.e. when user opens screen it will have focus on by default and auto pull up the keyboard so they save time
        amountTextField.keyboardType = .decimalPad
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        amountTextField.delegate = self // is this necessary?
        nameTextField.delegate = self // is this necessary?
        
        if let itemToEdit = itemToEdit {
            title = "Edit Expense" // Switch up the title for the ViewController when editing an expense item
            amountTextField.text = itemToEdit.amount // set the name and amount to the item we're editing
            nameTextField.text = itemToEdit.name
            datePickerField.date = itemToEdit.date!
            doneBarButton.isEnabled = true
        }

    }
    
    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var amountTextField: UITextField!
    
   
    @IBOutlet weak var datePickerField: UIDatePicker!
    
    weak var delegate: ExpenseDetailViewControllerDelegate?
    
    //MARK: - Tableview delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil //make sure we disable cell selection, only text field is selectable
    }
    
    
    //MARK: - Actions
    @IBAction func cancel() {
        delegate?.expenseDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        
        if let item = itemToEdit {
            item.name = nameTextField.text!
            item.amount = amountTextField.text!
            item.date = datePickerField.date
            delegate?.expenseDetailViewController(self, didFinishEditing: item)
            
        } else {
            let item = ExpenseListItem()
            item.name = nameTextField.text!
            item.amount = amountTextField.text!
            item.date = datePickerField.date
            delegate?.expenseDetailViewController(self, didFinishAdding: item)
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
