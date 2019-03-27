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
    case leftButton = "leftButton"
    case rightButton = "rightButton"
    case expenseTotalLabel = "expenseTotalLabel"
    case expenseTotalValueLabel = "expenseTotalValueLabel"
    case noExpensesLabel = "noExpensesLabel"
    case day = "Day"
    case week = "Week"
    case month = "Month"
    case year = "Year"
    case miscellaneous = "Misc"
    case car = "Car"
    case groceries = "Groceries"
    case health = "Health"
    case house = "House"
    case relaxation = "Relaxation"
    case restaurant = "Restaurant"
    case services = "Services"
    case travel = "Travel"
    
    var element: XCUIElement {
        switch self {
        case .expenseTotalLabel, .expenseTotalValueLabel, .noExpensesLabel :
            return XCUIApplication().staticTexts[self.rawValue]
        case .day, .week, .month, .year, .leftButton, .rightButton :
            return XCUIApplication().buttons[self.rawValue]
        case .navBarTitle :
            return XCUIApplication().navigationBars.firstMatch.otherElements.firstMatch
        case .pieChartView :
            return XCUIApplication().otherElements[self.rawValue]
        case .miscellaneous, .car, .groceries, .health, .house, .relaxation,
             .restaurant, .services, .travel :
            //The pie chart labels are a grouped as an "other" element under the piechart element, so query below looks a bit messy but it does only search labels in the piechart which is the desired result
            return XCUIApplication().otherElements["pieChartView"].otherElements.containing(NSPredicate(format: "label BEGINSWITH %@", self.rawValue as CVarArg)).element
        }
    }
}
