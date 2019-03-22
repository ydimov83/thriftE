//
//  XCUIElement+Helpers.swift
//  ThriftEUITests
//
//  Created by Yavor Dimov on 3/22/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//
import XCTest

extension XCUIElement {
    func clearAndTypeText(text: String) {
        if let charCount = (self.value as? String)?.count {
            for i in 0..<charCount {
                XCUIApplication().keys["delete"].tap()
            }
        }
    }
    
    func clearText() {
        if let charCount = (self.value as? String)?.count {
            for i in 0..<charCount {
                XCUIApplication().keys["delete"].tap()
            }
        }
    }
}
