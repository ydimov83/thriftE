//
//  ExpenseListPage.swift
//  ThriftEUITests
//
//  Created by Yavor Dimov on 3/10/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import XCTest

enum ExpenseListPage: String {
    
    case addExpenseButton =  "Add"
    case cellTitle = "expenseCellTitle"
    case cellSubTitle = "expenseCellSubtitle"
    case navBarTitle = "ThriftE"
    var element: XCUIElement {
        switch self {
        case .addExpenseButton :
            return XCUIApplication().buttons[self.rawValue]
        case .cellTitle, .cellSubTitle :
            return XCUIApplication().staticTexts[self.rawValue]
        case .navBarTitle :
            return XCUIApplication().navigationBars.firstMatch.otherElements.firstMatch
        }
    }
}
