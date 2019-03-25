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

class AnalyzeExpensesViewController: UIViewController{
    
    var managedObjectContext: NSManagedObjectContext! {
        didSet {
            //As soon as managedObjectContext gets a value, which happens at app launch through AppDelegate implementation, this bloc will execute and thus actively listen to changes in data store
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                object: managedObjectContext,
                queue: OperationQueue.main) { notification in
                    if self.isViewLoaded {
                        //We only want to update the chart once the Analyze view is already loaded
                        self.updateData()
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
    let today = Date()
    var userSelectedDate: Date?
    let formatter = DateFormatter()
    var fetchRequestPredicate: NSPredicate?
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var noExpensesLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var calendarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateStyle = DateFormatter.Style.short
        if selectedDateSegment == "" {
            //If selectedDateSegment has no value then it means it's the first time user sees Analyze screen so segmentedControlIndexChanged() has not run yet, set category to Today and predicate accordingly
            selectedDateSegment = "Day"
        }
        updateData()
        pieChartView.delegate = self
        setAccessibilityIdentifiers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //Deselect the previously selected pie chart slice when coming back to the screen
        pieChartView.highlightValue(nil)
        setupPieChartView()
    }
    //MARK: - Actions
    @IBAction func segmentedControlIndexChanged(_ sender: Any) {
        switch  segmentedControl.selectedSegmentIndex {
        case 0:
            selectedDateSegment = "Day"
        case 1:
            selectedDateSegment = "Week"
        case 2:
            selectedDateSegment = "Month"
        case 3:
            selectedDateSegment = "Year"
        default:
            selectedDateSegment = "Day"
        }
        updateCalendarButtonState()
        //Reset from/toDate
        fromDate = today
        toDate = today
        userSelectedDate = nil
        updateData()
    }
    
    @IBAction func calendarButtonActioned(_ sender: UIButton) {
    }
    
    @IBAction func leftButtonActioned(_ sender: Any) {
        userSelectedDate = nil
        updateData(scrollDirection: "earlier")
    }
    @IBAction func rightButtonActioned(_ sender: Any) {
        userSelectedDate = nil
        updateData(scrollDirection: "later")
    }
    //MARK: - Chart Setup
    func setupPieChartView() {
        if totalValueLabel.isHidden {
            //If total value is hidden it means we have no data to show, hide the pie view
            pieChartView.isHidden = true
            noExpensesLabel.isHidden = false
        } else {
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
            dataSet.valueColors = [NSUIColor.black]
            dataSet.entryLabelFont = UIFont(name: "Helvetica Neue", size: 11)
            
            let data = PieChartData(dataSet: dataSet)
            pieChartView.data = data
            
            pieChartView.holeColor = UIColor.black
            pieChartView.chartDescription?.text = "Totals by category"
            pieChartView.chartDescription?.textAlign = .right
            pieChartView.chartDescription?.textColor = UIColor.white
            pieChartView.legend.textColor = UIColor.white
            //This must stay at end of function
            pieChartView.notifyDataSetChanged()
            pieChartView.animate(xAxisDuration: 0.5)
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
            
            //Map the category to an index, this way we can update the category specific totals
            ExpenseCategories.allCases.forEach{
                if expense.category == $0.rawValue{
                    catIndex = getIndexValueFromCategoryName(category: $0)
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
    func updateData(scrollDirection: String? = nil) {
        let calendar = Calendar.current
        var currentYear = calendar.component(.year, from: today)
        var currentMonth = calendar.component(.month, from: today)
        var dateComponents = DateComponents()
        dateComponents.calendar = calendar
        dateComponents.timeZone = TimeZone.current
        //Switch here used to set fromDate, toDate and the calendarButton title
        switch  selectedDateSegment {
        case "Day":
            if userSelectedDate != nil {
                fromDate = calendar.startOfDay(for: userSelectedDate!)
                calendarButton.setTitle(formatter.string(from: fromDate), for: .normal)
            } else {
                if scrollDirection == "earlier" {
                    //Means user never launched calendar, will set userSelectedDate now
                    fromDate = Calendar.current.date(byAdding: .day, value: -1, to: fromDate)!
                    fromDate = calendar.startOfDay(for: fromDate)
                    calendarButton.setTitle(formatter.string(from: fromDate), for: .normal)
                } else if scrollDirection == "later" {
                    //Means user never launched calendar, will set userSelectedDate now
                    fromDate = Calendar.current.date(byAdding: .day, value: 1, to: fromDate)!
                    fromDate = calendar.startOfDay(for: fromDate)
                    calendarButton.setTitle(formatter.string(from: fromDate), for: .normal)
                } else {
                    //Default state when first launching screen or Day segment is reselected
                    fromDate = calendar.startOfDay(for: today)
                    calendarButton.setTitle("Today", for: .normal)
                }
            }
            toDate = Calendar.current.date(byAdding: .day, value: 1, to: fromDate)!
        case "Week" :
            //I'm using Monday as the start of the week and Sunday as the end of the week
            if userSelectedDate != nil {
                //Case when user has come back from calendar picker but hasn't used <, > buttons
                fromDate = calendar.startOfDay(for: userSelectedDate!.previous(.monday, considerToday: true))
            } else {
                if scrollDirection == nil {
                    //Case when user first selects the 'Week' segment
                    fromDate = calendar.startOfDay(for: today.previous(.monday, considerToday: true))
                } else if scrollDirection == "earlier" {
                    //User has used the '<' button
                    fromDate = calendar.startOfDay(for: fromDate.previous(.monday, considerToday: false))
                } else if scrollDirection == "later" {
                    //User has used the '>' button
                    fromDate = calendar.startOfDay(for: fromDate.next(.monday, considerToday: false))
                }
            }
            toDate = fromDate.next(.monday)
            let fromString = formatter.string(from: fromDate)
            //Need to subtract one day from end date to get the proper end date string, otherwise it will include the next Monday
            let toString = formatter.string(from: calendar.date(byAdding: .day, value: -1, to: toDate)!)
            calendarButton.setTitle("\(fromString) - \(toString)", for: .normal)
        case "Month":
            if userSelectedDate != nil {
                //Case when user has come back from calendar picker but hasn't used <, > buttons
                currentYear = calendar.component(.year, from: userSelectedDate!)
                currentMonth = calendar.component(.month, from: userSelectedDate!)
                dateComponents.year = currentYear
                dateComponents.month = currentMonth
                fromDate = calendar.date(from: dateComponents)!
                toDate = calendar.date(byAdding: .month, value: 1, to: fromDate)!
                //Need a temp date in order to avoid mislabeling
                let buttonDate = calendar.date(bySetting: .day, value: 1, of: fromDate)!
                calendarButton.setTitle(Date.getMonthNameFromDate(date: buttonDate), for: .normal)
            } else {
                if scrollDirection == nil {
                    //Case when user first selects the 'Week' segment
                    dateComponents.year = currentYear
                    dateComponents.month = currentMonth
                    fromDate = calendar.date(from: dateComponents)!
                    dateComponents.month = dateComponents.month! + 1
                    toDate = calendar.date(from: dateComponents)!
                } else if scrollDirection == "earlier" {
                    //User has used the '<' button
                    fromDate = calendar.date(byAdding: .month, value: -1, to: fromDate)!
                    fromDate = calendar.date(bySetting: .day, value: 1, of: fromDate)!
                } else if scrollDirection == "later" {
                    //User has used the '>' button
                    fromDate = calendar.date(byAdding: .month, value: 1, to: fromDate)!
                    fromDate = calendar.date(bySetting: .day, value: 1, of: fromDate)!
                }
                toDate = calendar.date(byAdding: .month, value: 1, to: fromDate)!
                calendarButton.setTitle(Date.getMonthNameFromDate(date: fromDate), for: .normal)
            }
        case "Year": //Year
            if scrollDirection == nil { //Default case when user first selects Year segment
                currentYear = calendar.component(.year, from: today)
            } else if scrollDirection == "earlier" {
                currentYear = calendar.component(.year, from: fromDate) - 1
            } else if scrollDirection == "later" {
                currentYear = calendar.component(.year, from: fromDate) + 1
            }
            dateComponents.year = currentYear
            fromDate = calendar.date(from: dateComponents)!
            dateComponents.year = dateComponents.year! + 1
            toDate = calendar.date(from: dateComponents)!
            calendarButton.setTitle("\(currentYear)", for: .normal)
        default: //Day
            fromDate = calendar.startOfDay(for: today)
            calendarButton.setTitle("Today", for: .normal)
            toDate = Calendar.current.date(byAdding: .day, value: 1, to: fromDate)!
        }
        
        print("from: \(fromDate) to: \(toDate)")
        //Predicate used in fetchRequest will change based on selected segment so we need to setup chart data again
        fetchRequestPredicate = NSPredicate(format: "date >= %@ && date < %@", fromDate as CVarArg, toDate as CVarArg)
        
        let entity = Expense.entity()
        let fetchRequest = NSFetchRequest<Expense>()
        //Fetch data and setup pie chart view
        fetchRequest.entity = entity
        fetchRequest.predicate = fetchRequestPredicate
        expenses = try! managedObjectContext.fetch(fetchRequest)
        calculateTotals()
        setupPieChartView()
    }
    func updateCalendarButtonState() {
        if selectedDateSegment == "Year" {
            calendarButton.isEnabled = false
            calendarButton.tintColor = UIColor.lightText
        } else {
            calendarButton.isEnabled = true
            calendarButton.tintColor = tabBarController?.tabBar.tintColor
        }
    }
    func setAccessibilityIdentifiers() {
        pieChartView.accessibilityIdentifier = "pieChartView"
        totalValueLabel.accessibilityIdentifier = "expenseTotalValueLabel"
        totalLabel.accessibilityIdentifier = "expenseTotalLabel"
        noExpensesLabel.accessibilityIdentifier = "noExpensesLabel"
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
            if userSelectedDate != nil {
                controller.selectedDate = userSelectedDate
            } else {
                controller.selectedDate = fromDate
            }
            controller.delegate = self
        }
    }
}
//MARK: - ChartView Delegate Implementation
extension AnalyzeExpensesViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let pieChartDataEntry = entry as! PieChartDataEntry
        selectedPieChartCategory = pieChartDataEntry.label!
        performSegue(withIdentifier: "FilteredExpenseList", sender: self)
    }
}
//MARK:- CalendarViewController Delegate
extension AnalyzeExpensesViewController: CalendarViewControllerDelegate {
    func calendarViewController(_ controller: CalendarViewController, didPickDate date: Date) {
        userSelectedDate = date
        updateData()
    }
}
