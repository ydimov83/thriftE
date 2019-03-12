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
    
    let category = ExpenseCategories.allCases[hashValue]
    return category
}

func getHashValueFromCategoryName(category: ExpenseCategories) -> Int {
    
    var hashValue = 0
    for aCategory in ExpenseCategories.allCases {
        if aCategory == category {
            break //we've found the matching category quit loop
        } else {
            hashValue += 1
        }
    }
        return hashValue
}

