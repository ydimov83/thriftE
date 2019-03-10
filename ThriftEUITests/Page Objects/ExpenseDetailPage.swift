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
    var element: XCUIElement {
        switch self {
        case .navBarTitleAddMode, .navBarTitleEditMode :
            return XCUIApplication().navigationBars.firstMatch.otherElements.firstMatch
        case .doneButton, .cancelButton :
            return XCUIApplication().navigationBars.buttons[self.rawValue]
        case .nameTextField, .amountTextField :
            return XCUIApplication().textFields[self.rawValue]
        case .categoryLabel, .categoryValueLabel :
            return XCUIApplication().staticTexts[self.rawValue]
        }
    }
}
