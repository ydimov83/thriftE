//
//  ExpenseCategoryPageTests.swift
//  ThriftEUITests
//
//  Created by Yavor Dimov on 3/12/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import XCTest

class ExpenseCategoryPageTests: ThriftEUIBaseTestCase {
    
    func testCategoryCellShowsSelectedState() {
        //Test setting category for first time
        ExpenseListPage.addExpenseButton.element.tap()
        ExpenseDetailPage.categoryValueLabel.element.tap()
        ExpenseCategoryPage.restaurant.element.tap()
        XCTAssert(ExpenseCategoryPage.restaurant.element.isSelected, "Tapping on the Restaurant category cell should show selected state")
        //Test returning to category picker screen with a previously selected category value for the current expense
        ExpenseDetailPage.categoryValueLabel.element.tap()
        
        for category in ExpenseCategoryPage.allCases {
            if category.rawValue == ExpenseCategoryPage.restaurant.rawValue {
                XCTAssert(category.element.isSelected, "Previously selected category cell for 'Restaurant' should show selected state")
            } else {
                XCTAssert(!category.element.isSelected, "Only selected category should show selected state")
            }
        }
    }
    
}
