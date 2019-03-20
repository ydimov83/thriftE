//
//  FilteredExpenseListPage.swift
//  ThriftEUITests
//
//  Created by Yavor Dimov on 3/20/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import XCTest

enum FilteredExpenseListPage: String {
    
    case cellTitle = "expenseCellTitle"
    case cellSubTitle = "expenseCellSubtitle"
    case navBarTitle = "categoryValue"
    var element: XCUIElement {
        switch self {
        case .cellTitle, .cellSubTitle :
            return XCUIApplication().staticTexts[self.rawValue]
        case .navBarTitle :
            return XCUIApplication().navigationBars.firstMatch.otherElements.firstMatch
        }
    }
}
