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

class AnalyzeExpensesViewController: UIViewController, ChartViewDelegate{
    
    
    var managedObjectContext: NSManagedObjectContext! {
        didSet {
            //As soon as managedObjectContext gets a value, which happens at app launch through AppDelegate implementation, this bloc will execute and thus actively listen to changes in data store
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                object: managedObjectContext,
                queue: OperationQueue.main) { notification in
                    if self.isViewLoaded {
                        //We only want to update the chart once the Analyze view is already loaded
                        self.setupPieChartView()
                    }
            }
        }
    }
    var expenses = [Expense]()
    var categoryTotals = [Double]()
    var selectedPieChartCategory = ""
    var selectedDateSegment = ""
    var fromDate = Date()
    var toDate = Date()
    var fetchRequestPredicate = NSPredicate(format: "date <= %@", Date() as CVarArg)
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var noExpensesLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var calendarButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedDateSegment == "" {
            //If selectedDateSegment has no value then it means it's the first time user sees Analyze screen so segmentedControlIndexChanged() has not run yet, set category to Today and predicate accordingly
            selectedDateSegment = "Day"
            fromDate = Calendar.current.startOfDay(for: Date())
            toDate = Calendar.current.date(byAdding: .day, value: 1, to: fromDate)!
            fetchRequestPredicate = NSPredicate(format: "date >= %@ && date < %@", fromDate as CVarArg, toDate as CVarArg)
            calendarButton.isHidden = false
            calendarButton.setTitle("Today", for: .normal)
        }
        setupPieChartView()
        pieChartView.delegate = self
        pieChartView.accessibilityIdentifier = "pieChartView"
        totalValueLabel.accessibilityIdentifier = "expenseTotalValueLabel"
        totalLabel.accessibilityIdentifier = "expenseTotalLabel"
        noExpensesLabel.accessibilityIdentifier = "noExpensesLabel"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //Deselect the previously selected pie chart slice when coming back to the screen
        pieChartView.highlightValue(nil)
    }
    
    //MARK: - Actions
    @IBAction func segmentedControlIndexChanged(_ sender: Any) {
        //TODO: - The from/toDate params should just be passed into this method for easier readability? That also might help with unit testing?
        let today = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: today)
        let currentMonth = calendar.component(.month, from: today)
        var dateComponents = DateComponents()
        dateComponents.calendar = calendar
        dateComponents.timeZone = TimeZone.current
        
        switch  segmentedControl.selectedSegmentIndex {
        case 0:
            selectedDateSegment = "Day"
            fromDate = calendar.startOfDay(for: today)
            toDate = Calendar.current.date(byAdding: .day, value: 1, to: fromDate)!
            calendarButton.isHidden = false
        case 1:
            selectedDateSegment = "Week"
            //I'm using Monday as the start of the week and Sunday as the end of the week
            fromDate = calendar.startOfDay(for: Date.today().previous(.monday, considerToday: true))
            toDate = Date.today().next(.monday)
            calendarButton.isHidden = true
        case 2:
            selectedDateSegment = "Month"
            dateComponents.year = currentYear
            dateComponents.month = currentMonth
            fromDate = calendar.date(from: dateComponents)!
            dateComponents.month = dateComponents.month! + 1
            toDate = calendar.date(from: dateComponents)!
            calendarButton.isHidden = true
        case 3:
            selectedDateSegment = "Year"
            dateComponents.year = currentYear
            fromDate = calendar.date(from: dateComponents)!
            dateComponents.year = dateComponents.year! + 1
            toDate = calendar.date(from: dateComponents)!
            calendarButton.isHidden = true
        default:
            selectedDateSegment = "Day"
            fromDate = calendar.startOfDay(for: today)
            toDate = Calendar.current.date(byAdding: .day, value: 1, to: fromDate)!
            calendarButton.isHidden = true
        }
        print("from: \(fromDate) to: \(toDate)")
        //Predicate used in fetchRequest will change based on selected segment so we need to setup chart data again
        fetchRequestPredicate = NSPredicate(format: "date >= %@ && date < %@", fromDate as CVarArg, toDate as CVarArg)
        setupPieChartView()
    }
    
    @IBAction func calendarButtonActioned(_ sender: UIButton) {
    }
    
    //MARK: - Chart Setup
    func setupPieChartView() {
        let entity = Expense.entity()
        let fetchRequest = NSFetchRequest<Expense>()
        fetchRequest.entity = entity
        fetchRequest.predicate = fetchRequestPredicate
        
        expenses = try! managedObjectContext.fetch(fetchRequest)
        
        calculateTotals()
        
        if !totalValueLabel.isHidden {
            //If total value is hidden it means we have no data to show, hide the pie view
            pieChartView.isHidden = false
            noExpensesLabel.isHidden = true
            
            let dataSet =  PieChartDataSet(values: [], label: "")
            
            var i = 0
            //Need to enumerate through all category totals and only get ones that have values
            ExpenseCategories.allCases.forEach {_ in
                if categoryTotals[i] > 0.00 {
                    let label = getCategoryNameFromHashValue(hashValue: i).rawValue
                    print("Category total is: \(categoryTotals[i])")
                    let value = (categoryTotals[i])
                    let pieChartDataEntry = PieChartDataEntry(value: value, label: label)
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
        } else {
            pieChartView.isHidden = true
            noExpensesLabel.isHidden = false
        }
    }
    
    //MARK: - Helper Methods
    func calculateTotals() {
        //First zero out totals
        var catIndex: Int?
        var total: Double = 0.00
        categoryTotals =  [0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00]
        
        for expense in expenses {
            total += expense.amount
            print(expense.date.debugDescription)
            
            //Map the category to an index, this way we can update the category specific totals
            ExpenseCategories.allCases.forEach{
                if expense.category == $0.rawValue{
                    catIndex = getHashValueFromCategoryName(category: $0)
                }
            }
            categoryTotals[catIndex!] += expense.amount
            print("categoryTotal for \(expense.category) is: \(categoryTotals[catIndex!])")
        }
        if total > 0 {
            totalLabel.isHidden = false
            totalValueLabel.isHidden = false
            totalValueLabel.text = "\(total)"
            print("das total is: \(total)")
        } else {
            totalLabel.isHidden = true
            totalValueLabel.isHidden = true
        }
        
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FilteredExpenseList" {
            let controller = segue.destination as! FilteredExpenseListViewController
            controller.categoryFilter = selectedPieChartCategory
            controller.managedObjectContext = managedObjectContext
            controller.fromDate = fromDate
            controller.toDate = toDate
        }
        if segue.identifier == "ShowCalendar" {
            let controller = segue.destination as! CalendarViewController
            controller.delegate = self
        }
    }
    //MARK: - ChartView Delegate Implementation
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let pieChartDataEntry = entry as! PieChartDataEntry
        selectedPieChartCategory = pieChartDataEntry.label!
        performSegue(withIdentifier: "FilteredExpenseList", sender: self)
    }
    
}

//MARK:
extension AnalyzeExpensesViewController: CalendarViewControllerDelegate {
    func calendarViewController(_ controller: CalendarViewController, didPickDate date: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        fromDate = date
        toDate = Calendar.current.date(byAdding: .day, value: 1, to: fromDate)!
        calendarButton.setTitle(formatter.string(from: fromDate), for: .normal)
        fetchRequestPredicate = NSPredicate(format: "date >= %@ && date < %@", fromDate as CVarArg, toDate as CVarArg)
        setupPieChartView()
    }
}
