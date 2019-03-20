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

    func testUIWhenUserHasNoExpenseData() {
        TabBarPageObject.analyze.element.tap()
        XCTAssert(AnalyzeExpensesPage.today.element.isSelected, "User should be on the 'Today' segment")
        assertsUserHasNoData()
        AnalyzeExpensesPage.week.element.tap()
        assertsUserHasNoData()
        AnalyzeExpensesPage.month.element.tap()
        assertsUserHasNoData()
        AnalyzeExpensesPage.year.element.tap()
        assertsUserHasNoData()
    }
    
    func testUIWhenUserHasExpenseData() {
        ExpenseListPage.addExpenseButton.element.tap()
        fillExpenseDetailTestDataAndTapDone(name: "pizza", amount: "10.00", month: month, day: day, year: year, category: ExpenseCategoryPage.restaurant.element)
        TabBarPageObject.analyze.element.tap()
        let expenseTotal = "10.0"
        assertsUserHasData(expenseTotal: expenseTotal)
        AnalyzeExpensesPage.week.element.tap()
        assertsUserHasData(expenseTotal: expenseTotal)
        AnalyzeExpensesPage.month.element.tap()
        assertsUserHasData(expenseTotal: expenseTotal)
        AnalyzeExpensesPage.year.element.tap()
        assertsUserHasData(expenseTotal: expenseTotal)
    }
    
    //MARK: - Helper functions
    func assertsUserHasNoData() {
        XCTAssert(!AnalyzeExpensesPage.expenseTotalLabel.element.exists, "Expense total label should be hidden when there are no expenses")
        XCTAssert(!AnalyzeExpensesPage.expenseTotalValueLabel.element.exists, "Expense total value label should be hidden when there are no expenses")
        XCTAssert(AnalyzeExpensesPage.noExpensesLabel.element.exists, "No Expense label should be displayed when there are no expenses")
        XCTAssert(AnalyzeExpensesPage.noExpensesLabel.element.label == "No expenses for the selected date range", "No expense label should show the proper message text")
        XCTAssert(!AnalyzeExpensesPage.pieChartView.element.exists, "Pie chart view should be hidden when there are no expenses")
    }
    
    func assertsUserHasData(expenseTotal: String) {
        XCTAssert(AnalyzeExpensesPage.expenseTotalLabel.element.exists, "Expense total label should be shown when there are expenses")
        XCTAssert(AnalyzeExpensesPage.expenseTotalValueLabel.element.exists, "Expense total value label should be shown when there are expenses")
        XCTAssert(AnalyzeExpensesPage.expenseTotalValueLabel.element.label == expenseTotal, "Expense total value label should display the expected total value")
        XCTAssert(!AnalyzeExpensesPage.noExpensesLabel.element.exists, "No Expense label should be hidden when there are expenses")
        XCTAssert(AnalyzeExpensesPage.pieChartView.element.exists, "Pie chart view should be shown when there are expenses")
    }
    
}
