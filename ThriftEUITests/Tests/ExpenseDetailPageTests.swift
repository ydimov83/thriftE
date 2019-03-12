//
//  ExpenseDetailPageTests.swift
//  ThriftEUITests
//
//  Created by Yavor Dimov on 3/10/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import XCTest

class ExpenseDetailPageTests: ThriftEUIBaseTestCase {

    func testEmptyStateUI() {
        ExpenseListPage.addExpenseButton.element.tap()
        
        XCTAssert(ExpenseDetailPage.nameTextField.element.isEnabled, "Name field should be present")
        XCTAssert(ExpenseDetailPage.amountTextField.element.isEnabled, "Amount field should be present")
        XCTAssert(ExpenseDetailPage.categoryLabel.element.isEnabled, "Category label should be present")
        XCTAssert(ExpenseDetailPage.categoryValueLabel.element.label as! String == ExpenseCategoryPage.noCategory.rawValue, "Category value default should be 'No Category'")
        XCTAssert(ExpenseDetailPage.cancelButton.element.isEnabled, "Cancel button should be tappable")
        XCTAssert(!ExpenseDetailPage.doneButton.element.isEnabled, "Done button should NOT be tappable since required input data is missing")
    }
    
    func testDoneButtonEnableLogic() {
        ExpenseListPage.addExpenseButton.element.tap()
        XCTAssert(!ExpenseDetailPage.doneButton.element.isEnabled, "Done button should NOT be tappable since required input data is missing")
        
        ExpenseDetailPage.nameTextField.element.typeText("pizza")
        XCTAssert(ExpenseDetailPage.doneButton.element.isEnabled, "Done button should be tappable since required input data is present")
        
        ExpenseDetailPage.nameTextField.element.clearText()
        XCTAssert(!ExpenseDetailPage.doneButton.element.isEnabled, "Done button should NOT be tappable since required input data is missing")
    }
    
    func testUserPicksCategory() {
        ExpenseListPage.addExpenseButton.element.tap()
        ExpenseDetailPage.categoryValueLabel.element.tap()
        XCTAssert(ExpenseCategoryPage.addExpenseButton.element.isEnabled, "Tapping on the category value field should launch the category page")
        
        ExpenseCategoryPage.restaurant.element.tap()
        XCTAssert(ExpenseDetailPage.categoryValueLabel.element.label == ExpenseCategoryPage.restaurant.rawValue, "Category Value label should match the picked category")
    }
    
}
