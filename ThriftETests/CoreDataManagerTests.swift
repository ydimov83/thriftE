//
//  File.swift
//  ThriftETests
//
//  Created by Yavor Dimov on 3/28/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//


import XCTest
import CoreData
@testable import ThriftE

class CoreDataManagerTests: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    override func setUp() {
        super.setUp()
        
        coreDataManager = CoreDataManager.sharedManager
//
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let tabBarController = storyboard.instantiateInitialViewController() as! MyTabBarController
//        let tabBarViewControllers = tabBarController.viewControllers
//        let navigationController = tabBarViewControllers![1] as! UINavigationController
//
//        viewController = navigationController.viewControllers[0] as! AnalyzeExpensesViewController
//
//        let _ = navigationController.view
//        let _ = viewController!.view
    }
    
    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCoreDataManagerInit() {
        let coreDataInstance = CoreDataManager.sharedManager
        XCTAssertNotNil(coreDataInstance, "CoreDataManager.sharedManager was not initialized")
    }
    
    func testInsertDeleteAndFlushExpense() {
        //Test insert success
        coreDataManager.insertExpense(name: "test1", amount: 30.00, category: "Misc", date: Date())
        coreDataManager.insertExpense(name: "test2", amount: 30.00, category: "Misc", date: Date())
        XCTAssertTrue((coreDataManager?.isObjectInDataStore(name: "test1"))!, "Inserted object was not found in the data store")
        XCTAssertTrue((coreDataManager?.isObjectInDataStore(name: "test2"))!, "Inserted object was not found in the data store")
        //Test delete success
        coreDataManager.delete(name: "test1")
        XCTAssertFalse((coreDataManager?.isObjectInDataStore(name: "test1"))!, "Deleted object should not be found in the data store")
        XCTAssertTrue((coreDataManager?.isObjectInDataStore(name: "test2"))!, "Object which did not receive a 'delete' call should not have been deleted")
        //Test flush success
        coreDataManager.insertExpense(name: "test3", amount: 30.00, category: "Misc", date: Date())
        coreDataManager?.flushData()
        XCTAssertFalse((coreDataManager?.isObjectInDataStore(name: "test1"))!, "Deleted object should not be found in the data store")
        XCTAssertFalse((coreDataManager?.isObjectInDataStore(name: "test2"))!, "Deleted object should not be found in the data store")
        XCTAssertFalse((coreDataManager?.isObjectInDataStore(name: "test3"))!, "Deleted object should not be found in the data store")
    }
    
    
}
