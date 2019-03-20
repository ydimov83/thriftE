//
//  DateFormattingFunctions.swift
//  ThriftEUITests
//
//  Created by Yavor Dimov on 3/12/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import XCTest

// Use "LLLL" for full month name i.e. "January"
func getCurrentMonth(dateFormat: String) -> String {
    let now = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    let nameOfMonth = dateFormatter.string(from: now)
    return nameOfMonth
}

//Use "y" to get 4 digit year
func getCurrentYear(dateFormat: String) -> String {
    let now = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    let currentYear = dateFormatter.string(from: now)
    return currentYear
}

func getCurrentDayOfMonth() -> String {
    let now = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d"
    let dayOfMonth = dateFormatter.string(from: now)
    return dayOfMonth
}
