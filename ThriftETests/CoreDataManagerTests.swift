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

class CoreDataManagerTests: BaseUnitTest {
    
    
    func testCoreDataStackInitialization() {
        XCTAssertNotNil(CoreDataManager.sharedManager, "CoreDataManager.sharedManager was not initialized")
        XCTAssertNotNil(CoreDataManager.sharedManager.persistentContainer, "CoreDataManager's persistentContainer was not initialized")
        XCTAssertNotNil(CoreDataManager.sharedManager.managedObjectContext, "CoreDataManager's managedObjectContext was not initialized")
    }
    
    func testInsertDeleteAndFlushExpense() {
        //Test insert success
        coreDataManager.insertExpense(name: "test1", amount: 30.00, category: "Misc", date: Date())
        coreDataManager.insertExpense(name: "test2", amount: 30.00, category: "Misc", date: Date())
        coreDataManager.insertExpense(name: "test3", amount: 30.00, category: "Misc", date: Date())
        XCTAssertTrue((coreDataManager.isObjectInDataStore(name: "test1")), "Inserted object was not found in the data store")
        XCTAssertTrue((coreDataManager.isObjectInDataStore(name: "test2")), "Inserted object was not found in the data store")
        XCTAssertTrue((coreDataManager.isObjectInDataStore(name: "test3")), "Inserted object was not found in the data store")
        //Test delete success
        coreDataManager.delete(name: "test1")
        XCTAssertFalse((coreDataManager.isObjectInDataStore(name: "test1")), "Deleted object should not be found in the data store")
        XCTAssertTrue((coreDataManager.isObjectInDataStore(name: "test2")), "Object which did not receive a 'delete' call should not have been deleted")
        XCTAssertTrue((coreDataManager.isObjectInDataStore(name: "test3")), "Object which did not receive a 'delete' call should not have been deleted")
        //Test flush success
        coreDataManager.flushData()
        XCTAssertFalse((coreDataManager.isObjectInDataStore(name: "test1")), "Deleted object should not be found in the data store")
        XCTAssertFalse((coreDataManager.isObjectInDataStore(name: "test2")), "Deleted object should not be found in the data store")
        XCTAssertFalse((coreDataManager.isObjectInDataStore(name: "test3")), "Deleted object should not be found in the data store")
    }
    
}
