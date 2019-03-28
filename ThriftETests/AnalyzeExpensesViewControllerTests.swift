//
//  ThriftETests.swift
//  ThriftETests
//
//  Created by Yavor Dimov on 1/4/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import XCTest
@testable import ThriftE

class AnalyzeExpensesViewControllerTests: BaseUnitTest {

    func testNoExpenseLabelIsHiddenOnLoad() {
        XCTAssert(!analyzeExpensesViewController!.noExpensesLabel.isHidden, "no expenses label should be shown when screen is rendered with no data")
    }
}
