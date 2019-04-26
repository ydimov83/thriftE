//
//  ExpenseListViewControllerTests.swift
//  ThriftETests
//
//  Created by Yavor Dimov on 3/28/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//


import XCTest
@testable import ThriftE

class ExpenseListViewControllerTests: BaseUnitTest {
    
    func testExpenseCellOrderingAndMetadataAndCorrect() {
        
        let date1 = dateFormatter.date(from: "03/10/19")
        let date2 = dateFormatter.date(from: "03/08/19")
        let date3 = dateFormatter.date(from: "03/09/19")
        
        coreDataManager.insertExpense(name: "test1", amount: 10.50, category: "Misc", date: date1!)
        coreDataManager.insertExpense(name: "test2", amount: 20.00, category: "Misc", date: date2!)
         coreDataManager.insertExpense(name: "test3", amount: 30.95, category: "Misc", date: date3!)
        //Force tableview to load the inserted cells, otherwise  visibleCells calls below will return nil
        expenseListViewController?.tableView.reloadData()
        //Sorting is implicitly tested below, the order of objects should be sorted by their date in descending order, it should not match the order in which they were added
        let cell1 = expenseListViewController?.tableView.visibleCells[0] as? ExpenseListCell
        let cell2 = expenseListViewController?.tableView.visibleCells[1] as? ExpenseListCell
        let cell3 = expenseListViewController?.tableView.visibleCells[2] as? ExpenseListCell
        XCTAssertTrue(cell1?.nameLabel.text == "test1")
        XCTAssertTrue(cell1?.detailLabel.text == "$10.5 \(dateFormatter.string(from: date1!))")
        XCTAssertTrue(cell2?.nameLabel.text == "test3")
        XCTAssertTrue(cell2?.detailLabel.text == "$30.95 \(dateFormatter.string(from: date3!))")
        XCTAssertTrue(cell3?.nameLabel.text == "test2")
        XCTAssertTrue(cell3?.detailLabel.text == "$20.0 \(dateFormatter.string(from: date2!))")
    }
    
}
