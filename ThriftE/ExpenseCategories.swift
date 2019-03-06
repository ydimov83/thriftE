//
//  ExpenseCategories.swift
//  ThriftE
//
//  Created by Yavor Dimov on 2/27/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import Foundation

enum ExpenseCategories: String, CaseIterable {
    case noCategory = "No Category"
    case car = "Car"
    case groceries = "Groceries"
    case health = "Health"
    case house = "House"
    case relaxation = "Relaxation"
    case restaurant = "Restaurant"
    case services = "Services"
    case travel = "Travel"
}

func getCategoryNameFromHashValue(hashValue: Int) -> ExpenseCategories {
    
    switch hashValue {
        
    case 0 :
        return .noCategory
    case 1 :
        return .car
    case 2 :
        return .groceries
    case 3 :
        return .health
    case 4 :
        return .house
    case 5 :
        return .relaxation
    case 6 :
        return .restaurant
    case 7 :
        return .services
    case 8:
        return .travel
    default :
        return .noCategory
    }
}

func getHashValueFromCategoryName(category: ExpenseCategories) -> Int {
    
    switch category {
        
    case .noCategory :
        return 0
    case .car :
        return 1
    case .groceries :
        return 2
    case .health :
        return 3
    case .house :
        return 4
    case .relaxation :
        return 5
    case .restaurant :
        return 6
    case .services :
        return 7
    case .travel :
        return 8
    }
}

