//
//  DateFormattingFunctions.swift
//  ThriftEUITests
//
//  Created by Yavor Dimov on 3/12/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import XCTest

func getCurrentMonth() -> String {
    let now = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "LLLL"
    let nameOfMonth = dateFormatter.string(from: now)
    return nameOfMonth
}

func getCurrentYear() -> String {
    let now = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "y"
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
