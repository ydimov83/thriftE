//
//  File.swift
//  ThriftEUITests
//
//  Created by Yavor Dimov on 3/20/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import XCTest

class AnalyzeExpensesPageTests: ThriftEUIBaseTestCase {
    let month = getCurrentMonth()
    let day = getCurrentDayOfMonth()
    let year = getCurrentYear()

    func testTodaySegmentIsSelectedByDefault() {
        TabBarPageObject.analyze.element.tap()
        XCTAssert(AnalyzeExpenses.today.element.isSelected, "Today segment should be selected by default")
    }
    
//    func testExpenseTotalValueLabelUpdatesAccordingToSelectedDateSegment() {
//        ExpenseListPage.addExpenseButton.element.tap()
//        fillExpenseDetailTestDataAndTapDone(name: "pizza", amount: "10.00", month: month, day: day, year: year, category: ExpenseCategoryPage.restaurant.element)
//        ExpenseListPage.addExpenseButton.element.tap()
//
//        fillExpenseDetailTestDataAndTapDone(name: "pizza", amount: "10.00", month: month, day: day, year: year, category: ExpenseCategoryPage.restaurant.element)
//
//    }
    
}
