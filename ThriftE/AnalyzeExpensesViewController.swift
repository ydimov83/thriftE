//
//  AnalyzeExpensesViewController.swift
//  ThriftE
//
//  Created by Yavor Dimov on 2/24/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import UIKit
import Charts
import CoreData

class AnalyzeExpensesViewController: UIViewController, ChartViewDelegate {
    
    var managedObjectContext: NSManagedObjectContext! {
        didSet {
            //As soon as managedObjectContext gets a value, which happens at app launch through AppDelegate implementation, this bloc will execute and thus actively listen to changes in data store
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                object: managedObjectContext,
                queue: OperationQueue.main) { notification in
                    if self.isViewLoaded {
                        //We only want to update the chart once the Analyze view is already loaded
                        self.setupChartData()
                    }
            }
        }
    }
    var expenses = [Expense]()
    var total = 0.00
    var categoryTotal = [Double]()
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChartData()
        pieChartView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        totalLabel.text = "\(total)"
    }
    
    //MARK: - Chart Setup
    func setupChartData() {
        let entity = Expense.entity()
        let fetchRequest = NSFetchRequest<Expense>()
        fetchRequest.entity = entity
        
        expenses = try! managedObjectContext.fetch(fetchRequest)
        
        calculateTotals()
        
        let dataSet =  PieChartDataSet(values: [], label: "")
        
        var i = 0
        //Need to enumerate through all category totals and only get ones that have values
        ExpenseCategories.allCases.forEach {_ in
            if categoryTotal[i] > 0.00 {
                let label = getCategoryNameFromHashValue(hashValue: i).rawValue
                let pieChartDataEntry = PieChartDataEntry(value: categoryTotal[i], label: label)
                dataSet.append(pieChartDataEntry)
            }
            i += 1
        }
        dataSet.colors = ChartColorTemplates.pastel()
        dataSet.valueColors = [NSUIColor.white]
        
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
        
        pieChartView.holeColor = UIColor.black
        pieChartView.chartDescription?.text = "Totals by category"
        pieChartView.chartDescription?.textAlign = .right
        pieChartView.chartDescription?.textColor = UIColor.white
        pieChartView.legend.textColor = UIColor.white
        
        //This must stay at end of function
        pieChartView.notifyDataSetChanged()
    }

    //MARK: - Helper Methods
    func calculateTotals() {
        //First zero out totals
        var catIndex: Int?
        total = 0.00
        categoryTotal =  [0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00]
        
        for expense in expenses {
            total += expense.amount
            
            //Map the category to an index
            ExpenseCategories.allCases.forEach{
                if expense.category == $0.rawValue{
                    catIndex = getHashValueFromCategoryName(category: $0)
                }
            }
            categoryTotal[catIndex!] += expense.amount
            print("categoryTotal for \(expense.category) is: \(categoryTotal[catIndex!])")
        }
        print("das total is: \(total)")
    }
    
    //MARK: - ChartView Delegate Implementation
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let pieChartDataEntry = entry as! PieChartDataEntry
        print(pieChartDataEntry.label)
    }
    
}
