//
//  ExpenseDetailPage.swift
//  ThriftEUITests
//
//  Created by Yavor Dimov on 3/10/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import XCTest

enum ExpenseDetailPage: String {
    case navBarTitleAddMode = "Add Expense"
    case navBarTitleEditMode = "Edit Expense"
    case cancelButton = "Cancel"
    case doneButton = "Done"
    case nameTextField = "nameTextField"
    case amountTextField = "amountTextField"
    case categoryLabel = "categoryLabel"
    case categoryValueLabel = "categoryValueLabel"
    case monthPickerWheel = "m"
    case dayPickerWheel = "d"
    case yearPickerWheel = "y"
    
    var element: XCUIElement {
        switch self {
        case .navBarTitleAddMode, .navBarTitleEditMode :
            return XCUIApplication().navigationBars.firstMatch.otherElements.firstMatch
        case .doneButton, .cancelButton :
            return XCUIApplication().navigationBars.buttons[self.rawValue]
        case .amountTextField :
            return XCUIApplication().textFields[self.rawValue]
        case .nameTextField :
            return XCUIApplication().textViews[self.rawValue]
        case .categoryLabel, .categoryValueLabel :
            return XCUIApplication().staticTexts[self.rawValue]
        case .monthPickerWheel :
            return XCUIApplication().pickerWheels.element(boundBy: 0)
        case .dayPickerWheel :
            return XCUIApplication().pickerWheels.element(boundBy: 1)
        case .yearPickerWheel :
            return XCUIApplication().pickerWheels.element(boundBy: 2)
        }
    }
}

/**
 Test helper to populate expense detail page, taps the page's 'Done' button when finished.
 - Parameter name: Enter the expense name
 - Parameter amount: Enter the expense amount
 - Parameter month: Enter the month value for this expense
 - Parameter day: Enter the day value for this expense
 - Parameter year: Enter the year value for this expense
 - Parameter category: Enter the category value for this expense
*/
func fillExpenseDetailTestDataAndTapDone(name: String, amount: String, month: String, day: String, year: String, category: XCUIElement) {
    //Set name
    ExpenseDetailPage.nameTextField.element.typeText(name)
    //Set amount
    ExpenseDetailPage.amountTextField.element.tap()
    ExpenseDetailPage.amountTextField.element.typeText(amount)
    //Set date
    ExpenseDetailPage.monthPickerWheel.element.adjust(toPickerWheelValue: month)
    ExpenseDetailPage.dayPickerWheel.element.adjust(toPickerWheelValue: day)
    ExpenseDetailPage.yearPickerWheel.element.adjust(toPickerWheelValue: year)
    //Pick category
    ExpenseDetailPage.categoryValueLabel.element.tap()
    category.tap()
    //All done
    ExpenseDetailPage.doneButton.element.tap()
}
