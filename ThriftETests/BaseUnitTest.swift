//
//  BaseUnitTest.swift
//  ThriftETests
//
//  Created by Yavor Dimov on 3/28/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import XCTest
import CoreData
@testable import ThriftE

class BaseUnitTest: XCTestCase {
    var analyzeExpensesViewController: AnalyzeExpensesViewController?
    var expenseListViewController: ExpenseListViewController?
    var filteredExpenseListViewController: FilteredExpenseListViewController?
    let coreDataManager = CoreDataManager.sharedManager
    let dateFormatter = DateFormatter()
    
    override func setUp() {
        super.setUp()
         coreDataManager.flushData()
        dateFormatter.dateStyle = .short
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let tabBarController = storyboard.instantiateInitialViewController() as! MyTabBarController
        let tabBarViewControllers = tabBarController.viewControllers
        let navigationController0 = tabBarViewControllers![0] as! UINavigationController
        let navigationController1 = tabBarViewControllers![1] as! UINavigationController
        
        expenseListViewController = navigationController0.viewControllers[0] as? ExpenseListViewController
        analyzeExpensesViewController = navigationController1.viewControllers[0] as? AnalyzeExpensesViewController
        
        let _ = navigationController0.view
        let _ = expenseListViewController!.view
        let _ = navigationController1.view
        let _ = analyzeExpensesViewController!.view
    }
    
    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
