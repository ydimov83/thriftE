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

class AnalyzeExpensesViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        totalLabel.text = "\(total)"
        setupChartData()
    }
    
    //MARK: - Chart Setup
    func setupChartData() {
        let dataSet =  PieChartDataSet(values: [], label: "")
        
        var i = 0
        //Need to enumerate through all category totals and only get ones that have values
        ExpenseCategories.allCases.forEach {_ in
            if categoryTotal[i] > 0.00 {
                let label = getCategoryNameFromHashValue(hashValue: i).rawValue
                let pieChartDataEntry = PieChartDataEntry(value: categoryTotal[i], label: label)
                dataSet.append(pieChartDataEntry)
            }
            i = i + 1
        }
        let data = PieChartData(dataSet: dataSet)
        
        dataSet.colors = ChartColorTemplates.joyful()
        dataSet.valueColors = [NSUIColor.black]
        pieChartView.data = data
        pieChartView.chartDescription?.text = "Totals by category"
        
        //All other additions to this function will go here
        
        //This must stay at end of function
        pieChartView.notifyDataSetChanged()
        print("Data set count: \(dataSet.count)")
    }
    
}
