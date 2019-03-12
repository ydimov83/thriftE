//
//  ExpenseListPageTests.swift
//  ThriftEUITests
//
//  Created by Yavor Dimov on 3/10/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//


import XCTest

class ExpenseListPageTests: ThriftEUIBaseTestCase {
    
    func testEmptyStateUI() {
        XCTAssert(ExpenseListPage.navBarTitle.element.label == "ThriftE", "Navigation bar title should be 'ThriftE'")
        XCTAssert(ExpenseListPage.addExpenseButton.element.isHittable, "Add expense button should be present")
    }
    
    func testTappingAddExpenseButtonLaunchesAddExpenseScreen() {
        ExpenseListPage.addExpenseButton.element.tap()
        
        XCTAssert(ExpenseDetailPage.navBarTitleAddMode.element.label == ExpenseDetailPage.navBarTitleAddMode.rawValue, "Tapping on the Add button should take user to Add Expense page")
    }
    
    func testAddedExpenseItemShowsCorrectMetaData() {
        ExpenseListPage.addExpenseButton.element.tap()
        fillExpenseDetailTestDataAndTapDone(name: "pizza", amount: "10.00", month: "January", day: "1", year: "2019", category: ExpenseCategoryPage.restaurant.element)
        
        XCTAssert(ExpenseListPage.navBarTitle.element.label == ExpenseListPage.navBarTitle.rawValue, "After filling test data and tapping Done user should be back on Expense List Page")
        XCTAssert(ExpenseListPage.cellTitle.element.label == "pizza", "Expense name should be 'pizza'")
        XCTAssert(ExpenseListPage.cellSubTitle.element.label == "$10.0 1/1/19", "Expense cell subTitle should reflect test data amount and date")
    }
    
    //MARK: - Helper methods
    
    /**
     Takes a Date object and formats it into a String with format MM/DD/YY
     - Parameter date: The Date object to format
     - Returns: String with format MM/DD/YY
 */
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        let dateLabel = formatter.string(from: date)
        return dateLabel
    }
}
