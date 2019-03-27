//
//  ThriftETests.swift
//  ThriftETests
//
//  Created by Yavor Dimov on 1/4/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import XCTest
@testable import ThriftE

class ThriftETests: XCTestCase {

    var viewController: AnalyzeExpensesViewController?
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let tabBarController = storyboard.instantiateInitialViewController() as! MyTabBarController
        let tabBarViewControllers = tabBarController.viewControllers
        let navigationController = tabBarViewControllers![1] as! UINavigationController
     
        viewController = navigationController.viewControllers[0] as! AnalyzeExpensesViewController
        
        let _ = navigationController.view
        let _ = viewController!.view
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNoExpenseLabelIsHiddenOnLoad() {
        XCTAssert(!viewController!.noExpensesLabel.isHidden, "no expenses label should be shown when screen is rendered with no data")
    }
}
