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
        XCTAssert(ExpenseDetailPage.categoryValueLabel.element.label == ExpenseCategoryPage.miscalleneous.rawValue, "Category value default should be 'No Category'")
        XCTAssert(ExpenseDetailPage.cancelButton.element.isEnabled, "Cancel button should be tappable")
        XCTAssert(!ExpenseDetailPage.doneButton.element.isEnabled, "Done button should NOT be tappable since required input data is missing")
    }
    
    func testDoneButtonEnableLogic() {
        ExpenseListPage.addExpenseButton.element.tap()
        XCTAssert(!ExpenseDetailPage.doneButton.element.isEnabled, "Done button should NOT be tappable since required input data is missing")
        
        ExpenseDetailPage.nameTextField.element.typeText("pizza")
        XCTAssert(!ExpenseDetailPage.doneButton.element.isEnabled, "Done button should NOT be tappable since required input data is NOT present")
        
        ExpenseDetailPage.amountTextField.element.tap()
        ExpenseDetailPage.amountTextField.element.typeText("30")
        XCTAssert(ExpenseDetailPage.doneButton.element.isEnabled, "Done button should be tappable since required input data is present")
     
        //This seems a bit buggy if the software keyboard doesn't launch on the sim, then it can't find the delete key
        ExpenseDetailPage.amountTextField.element.clearText(deleteKeyIdentifier: "Delete")
        XCTAssert(!ExpenseDetailPage.doneButton.element.isEnabled, "Done button should NOT be tappable since required input data is NOT present")
        
        ExpenseDetailPage.amountTextField.element.typeText("30")
        XCTAssert(ExpenseDetailPage.doneButton.element.isEnabled, "Done button should be tappable since required input data is present")
        //For some reason tapping into the nameTextField here puts the focus at the end of the line, haven't found a good way to put the focus where it should be for clearText call to work here, so instead using the menu item to cut the value out
        ExpenseDetailPage.nameTextField.element.doubleTap()
        app.menuItems["Select All"].tap()
        ExpenseDetailPage.nameTextField.element.clearText()
        XCTAssert(!ExpenseDetailPage.doneButton.element.isEnabled, "Done button should NOT be tappable since required input data is NOT present")
    }
    
    func testUserPicksCategory() {
        ExpenseListPage.addExpenseButton.element.tap()
        ExpenseDetailPage.categoryValueLabel.element.tap()
        XCTAssert(ExpenseCategoryPage.addExpenseButton.element.isEnabled, "Tapping on the category value field should launch the category page")
        
        ExpenseCategoryPage.restaurant.element.tap()
        XCTAssert(ExpenseDetailPage.categoryValueLabel.element.label == ExpenseCategoryPage.restaurant.rawValue, "Category Value label should match the picked category")
    }
    
}
