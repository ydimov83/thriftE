//
//  ExpenseListPageTests.swift
//  ThriftEUITests
//
//  Created by Yavor Dimov on 3/10/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//


import XCTest

class ExpenseListPageTests: ThriftEUIBaseTestCase {
    
    func testEmptyState() {
        
        XCTAssert(ExpenseListPage.navBarTitle.element.label == "ThriftE", "Navigation bar title should be 'ThriftE'")
        XCTAssert(ExpenseListPage.addExpenseButton.element.isHittable, "Add expense button should be present")
    }
    
    func testUserTapsAddToLaunchAddExpensePage() {
        ExpenseListPage.addExpenseButton.element.tap()
        XCTAssert(ExpenseDetailPage.navBarTitleAddMode.element.label == ExpenseDetailPage.navBarTitleAddMode.rawValue, "Tapping on the Add button should take user to Add Expense page")
    }
    
}
