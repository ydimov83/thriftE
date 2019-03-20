//
//  AnalyzeExpensesPage.swift
//  ThriftEUITests
//
//  Created by Yavor Dimov on 3/20/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import XCTest

enum AnalyzeExpensesPage: String {
    
    case pieChartView = "pieChartView"
    case navBarTitle = "ThriftE"
    case expenseTotalLabel = "expenseTotalLabel"
    case expenseTotalValueLabel = "expenseTotalValueLabel"
    case noExpensesLabel = "noExpensesLabel"
    case today = "Today"
    case week = "Week"
    case month = "Month"
    case year = "Year"
    
    var element: XCUIElement {
        switch self {
        case .expenseTotalLabel, .expenseTotalValueLabel, .noExpensesLabel :
            return XCUIApplication().staticTexts[self.rawValue]
        case .today, .week, .month, .year :
            return XCUIApplication().buttons[self.rawValue]
        case .navBarTitle :
            return XCUIApplication().navigationBars.firstMatch.otherElements.firstMatch
        case .pieChartView :
            return XCUIApplication().otherElements[self.rawValue]
        }
    }
}
