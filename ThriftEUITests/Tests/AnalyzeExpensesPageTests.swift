//
//  File.swift
//  ThriftEUITests
//
//  Created by Yavor Dimov on 3/20/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import XCTest

class AnalyzeExpensesPageTests: ThriftEUIBaseTestCase {
    let month = getCurrentMonth(dateFormat: "LLLL")
    let day = getCurrentDayOfMonth()
    let year = getCurrentYear(dateFormat: "y")
    
    func testUIWhenUserHasNoExpenseData() {
        TabBarPageObject.analyze.element.tap()
        XCTAssert(AnalyzeExpensesPage.day.element.isSelected, "User should be on the 'Day' segment")
        assertsUserHasNoData()
        AnalyzeExpensesPage.leftButton.element.tap()
        assertsUserHasNoData()
        AnalyzeExpensesPage.rightButton.element.tap()
        AnalyzeExpensesPage.rightButton.element.tap()
        assertsUserHasNoData()
        AnalyzeExpensesPage.week.element.tap()
        assertsUserHasNoData()
        AnalyzeExpensesPage.leftButton.element.tap()
        assertsUserHasNoData()
        AnalyzeExpensesPage.rightButton.element.tap()
        AnalyzeExpensesPage.rightButton.element.tap()
        assertsUserHasNoData()
        AnalyzeExpensesPage.month.element.tap()
        assertsUserHasNoData()
        AnalyzeExpensesPage.leftButton.element.tap()
        assertsUserHasNoData()
        AnalyzeExpensesPage.rightButton.element.tap()
        AnalyzeExpensesPage.rightButton.element.tap()
        assertsUserHasNoData()
        AnalyzeExpensesPage.year.element.tap()
        assertsUserHasNoData()
        AnalyzeExpensesPage.leftButton.element.tap()
        assertsUserHasNoData()
        AnalyzeExpensesPage.rightButton.element.tap()
        AnalyzeExpensesPage.rightButton.element.tap()
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
    
    func testTapPieChartSegmentAndNavigateToFilteredExpense() {
        //Setup
        let dateString = DateFormatter.localizedString(from: Date(),
                                                       dateStyle: DateFormatter.Style.short,
                                                       timeStyle: DateFormatter.Style.none)
        var cellSubTitleLabel = "$35.0 \(dateString)"
        ExpenseListPage.addExpenseButton.element.tap()
        fillExpenseDetailTestDataAndTapDone(name: "pizza", amount: "10.00", month: month, day: day, year: year, category: ExpenseCategoryPage.restaurant.element)
        
        ExpenseListPage.addExpenseButton.element.tap()
        fillExpenseDetailTestDataAndTapDone(name: "steak and wine", amount: "35.00", month: month, day: day, year: year, category: ExpenseCategoryPage.groceries.element)
        //Test 'Groceries' segment
        TabBarPageObject.analyze.element.tap()
        AnalyzeExpensesPage.groceries.element.tap()
        
        XCTAssert(FilteredExpenseListPage.navBarTitle.element.label == AnalyzeExpensesPage.groceries.rawValue, "User should be on the Filtered Expenses page for 'Groceries' category")
        XCTAssert(ExpenseListPage.cellTitle.element.label == "steak and wine", "Expense name should be 'steak and wine'")
        XCTAssert(ExpenseListPage.cellSubTitle.element.label == cellSubTitleLabel, "Expense cell subTitle should reflect test data amount and date")
        
        //Test 'Restaurant' segment
        FilteredExpenseListPage.backButton.element.tap()
        AnalyzeExpensesPage.restaurant.element.tap()
        cellSubTitleLabel = "$10.0 \(dateString)"
        XCTAssert(FilteredExpenseListPage.navBarTitle.element.label == AnalyzeExpensesPage.restaurant.rawValue, "User should be on the Filtered Expenses page for 'Groceries' category")
        XCTAssert(ExpenseListPage.cellTitle.element.label == "pizza", "Expense name should be 'steak and wine'")
        XCTAssert(ExpenseListPage.cellSubTitle.element.label == cellSubTitleLabel, "Expense cell subTitle should reflect test data amount and date")
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
