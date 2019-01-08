//
//  AddExpenseViewController.swift
//  ThriftE
//
//  Created by Yavor Dimov on 1/5/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import UIKit

protocol AddExpenseViewControllerDelegate: class {
    func addExpenseViewControllerDidCancel(_ controller: AddExpenseViewController)
    func addExpenseViewController(_ controller: AddExpenseViewController, didFinishAdding item: ExpenseListItem)
}

class AddExpenseViewController: UITableViewController, UITextFieldDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        nameTextField.becomeFirstResponder()
        // set the text field to first responder, i.e. when user opens screen it will have focus on by default and auto pull up the keyboard so they save time
        amountTextField.keyboardType = .decimalPad
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        amountTextField.delegate = self
        nameTextField.delegate = self

    }
    
    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var amountTextField: UITextField!
    
    weak var delegate: AddExpenseViewControllerDelegate?
    
    //MARK: - Tableview delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil //make sure we disable cell selection, only text field is selectable
    }
    
    
    //MARK: - Actions
    @IBAction func cancel() {
        delegate?.addExpenseViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        let item = ExpenseListItem()
        item.name = nameTextField.text!
        item.amount = amountTextField.text!
        print("i was this expensive: \(item.amount)")
        
        delegate?.addExpenseViewController(self, didFinishAdding: item)
    }
    
    //MARK: - TextField delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        
        if textField.tag == 1003 {
            let invalidCharacters = CharacterSet(charactersIn: ".0123456789").inverted
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
