//
//  ExpenseCategoryPage.swift
//  ThriftEUITests
//
//  Created by Yavor Dimov on 3/12/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import XCTest

enum  ExpenseCategoryPage: String, CaseIterable {
    case noCategory = "No Category"
    case car = "Car"
    case groceries = "Groceries"
    case health = "Health"
    case house = "House"
    case relaxation = "Relaxation"
    case restaurant = "Restaurant"
    case services = "Services"
    case travel = "Travel"
    case addExpenseButton = "Add Expense"
    
    var element: XCUIElement {
        switch self {
        case .noCategory, .car, .groceries, .health, .house, .relaxation,
             .restaurant, .services, .travel :
                return XCUIApplication().cells[self.rawValue]
        case .addExpenseButton :
            return XCUIApplication().navigationBars.buttons[self.rawValue]
        }
    }
}

