//
//  FilteredExpenseListViewControllerTests.swift
//  ThriftETests
//
//  Created by Yavor Dimov on 3/29/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import XCTest
@testable import ThriftE

class FilteredExpenseListViewControllerTests: BaseUnitTest {
    
    func testSetFetchedResultsController() {
        let filteredVC = FilteredExpenseListViewController()
        filteredVC.loadViewIfNeeded()
        let fromDate = dateFormatter.date(from: "01/01/19")!
        let toDate = dateFormatter.date(from: "03/01/19")!
        let categoryFilter = "Misc"
        
        let fetched = filteredVC.setFetchedResultsController(fromDate: fromDate, toDate: toDate, categoryFilter: categoryFilter)
        let predicate = NSPredicate(format: "date >= %@ && date < %@ && category == %@", fromDate as CVarArg, toDate as CVarArg, categoryFilter)
        let sortDescriptors = [(NSSortDescriptor(key: "date", ascending: false))]
        
        XCTAssert(fetched.fetchRequest.predicate == predicate, "Fetch Results Controller's fetchRequest predicate was not set correctly")
        XCTAssert(fetched.cacheName == "Expenses", "Cache name was not set to 'Expenses'")
        XCTAssert(fetched.fetchRequest.sortDescriptors == sortDescriptors, "Fetch Results Controller's fetchRequest sortDescriptors were not set correctly")
    }
    
}
