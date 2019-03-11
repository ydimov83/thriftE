//
//  ExpenseDetailPageTests.swift
//  ThriftEUITests
//
//  Created by Yavor Dimov on 3/10/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import XCTest

class ExpenseDetailPageTests: ThriftEUIBaseTestCase {

    func testEmptyState() {
        ExpenseListPage.addExpenseButton.element.tap()
        
        XCTAssert(ExpenseDetailPage.nameTextField.element.isEnabled, "Name field should be present")
        XCTAssert(ExpenseDetailPage.amountTextField.element.isEnabled, "Amount field should be present")
        XCTAssert(ExpenseDetailPage.categoryLabel.element.isEnabled, "Category label should be present")
        XCTAssert(ExpenseDetailPage.categoryValueLabel.element.label as! String == "No Category", "Category value default should be 'No Category'")
        XCTAssert(ExpenseDetailPage.cancelButton.element.isEnabled, "Cancel button should be tappable")
        XCTAssert(!ExpenseDetailPage.doneButton.element.isEnabled, "Done button should NOT be tappable since required input data is missing")
    }
    
    func testDoneButtonEnableLogic() {
        ExpenseListPage.addExpenseButton.element.tap()
        
        ExpenseDetailPage.nameTextField.element.typeText("pizza")
        XCTAssert(ExpenseDetailPage.doneButton.element.isEnabled, "Done button should be tappable since required input data is present")
        ExpenseDetailPage.nameTextField.element.clearText()
        XCTAssert(!ExpenseDetailPage.doneButton.element.isEnabled, "Done button should NOT be tappable since required input data is missing")
    }
}
