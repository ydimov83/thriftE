//
//  TabBarPageObect.swift
//  ThriftEUITests
//
//  Created by Yavor Dimov on 3/20/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import XCTest

enum TabBarPageObject: String {
    case addExpenses = "Add Expenses"
    case analyze = "Analyze"
    
    var element: XCUIElement {
        switch self {
        case .addExpenses, .analyze :
            return XCUIApplication().tabBars.buttons[self.rawValue]
        }
    }
}
