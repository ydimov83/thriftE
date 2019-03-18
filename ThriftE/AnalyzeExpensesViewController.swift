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
    var selectedPieChartCategory = ""
    var selectedFilter = "Today"
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChartData()
        pieChartView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //Deselect the previously selected pie chart slice when coming back to the screen
        pieChartView.highlightValue(nil)
    }
    
    //MARK: - Actions
    @IBAction func segmentedControlIndexChanged(_ sender: Any) {
        switch  segmentedControl.selectedSegmentIndex {
        case 0:
            selectedFilter = "Today"
        case 1:
            selectedFilter = "Week"
        case 2:
            selectedFilter = "Month"
        case 3:
            selectedFilter = "Year"
        default:
            selectedFilter = "Today"
        }
        //Predicate used in fetchRequest will change based on selected segment so we need to setup chart data again
        setupChartData()
    }
    
    //MARK: - Chart Setup
    func setupChartData() {
        let entity = Expense.entity()
        let fetchRequest = NSFetchRequest<Expense>()
        fetchRequest.entity = entity
        fetchRequest.predicate = setFetchRequestPredicate()
        
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
            print(expense.date.debugDescription)
            
            //Map the category to an index
            ExpenseCategories.allCases.forEach{
                if expense.category == $0.rawValue{
                    catIndex = getHashValueFromCategoryName(category: $0)
                }
            }
            categoryTotal[catIndex!] += expense.amount
            print("categoryTotal for \(expense.category) is: \(categoryTotal[catIndex!])")
        }
        totalLabel.text = "\(total)"
        print("das total is: \(total)")
    }
    
    func setFetchRequestPredicate() -> NSPredicate {
        //TODO: - The from/toDate params should just be passed into this method for easier readability? That also might help with unit testing?
        var predicate: NSPredicate
        let today = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: today)
        let currentMonth = calendar.component(.month, from: today)
        var fromDate = Date()
        var toDate = Date()
        var dateComponents = DateComponents()
        dateComponents.calendar = calendar
        dateComponents.timeZone = TimeZone.current
        
        switch selectedFilter {
        case "Today":
            fromDate = calendar.startOfDay(for: today)
            toDate = Calendar.current.date(byAdding: .day, value: 1, to: fromDate)!
            predicate =  NSPredicate(format: "date >= %@ && date < %@", fromDate as CVarArg, toDate as CVarArg)
        case "Week":
            fromDate = calendar.startOfDay(for: Date.today().previous(.monday, considerToday: true))
            toDate = Date.today().next(.monday)
            predicate =  NSPredicate(format: "date >= %@ && date < %@", fromDate as CVarArg, toDate as CVarArg)
        case "Month":
            dateComponents.year = currentYear
            dateComponents.month = currentMonth
            fromDate = calendar.date(from: dateComponents)!
            dateComponents.month = dateComponents.month! + 1
            toDate = calendar.date(from: dateComponents)!
            predicate =  NSPredicate(format: "date >= %@ && date < %@", fromDate as CVarArg, toDate as CVarArg)
        case "Year":
            dateComponents.year = currentYear
            fromDate = calendar.date(from: dateComponents)!
            dateComponents.year = dateComponents.year! + 1
            toDate = calendar.date(from: dateComponents)!
            predicate =  NSPredicate(format: "date >= %@ && date < %@", fromDate as CVarArg, toDate as CVarArg)
        default:
            predicate =  NSPredicate(format: "date <= %@", Date() as CVarArg)
        }
        
        print("from: \(fromDate) to: \(toDate)")
        return predicate
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FilteredExpenseList" {
            let controller = segue.destination as! FilteredExpenseListViewController
            controller.categoryFilter = selectedPieChartCategory
            controller.managedObjectContext = managedObjectContext
        }
    }
    //MARK: - ChartView Delegate Implementation
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let pieChartDataEntry = entry as! PieChartDataEntry
        selectedPieChartCategory = pieChartDataEntry.label!
        print(pieChartDataEntry.label)
        performSegue(withIdentifier: "FilteredExpenseList", sender: self)
    }
    
}
