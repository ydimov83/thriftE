//
//  ThriftEUITests.swift
//  ThriftEUITests
//
//  Created by Yavor Dimov on 1/4/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import XCTest

class ThriftEUIBaseTestCase: XCTestCase {
    
    let app = XCUIApplication()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        app.terminate()
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}

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
