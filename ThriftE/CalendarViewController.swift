//
//  CalendarViewController.swift
//  ThriftE
//
//  Created by Yavor Dimov on 3/22/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//


import UIKit
import JTAppleCalendar

protocol CalendarViewControllerDelegate: class {
    func calendarViewController(_ controller: CalendarViewController, didPickDate date: Date)
}

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    let formatter = DateFormatter()
    let outsideMonthColor = UIColor.lightText
    let monthColor = UIColor.black
    let selectedMonthColor = UIColor.red
    let currentDateSelectedViewColor = UIColor.orange
    
    var selectedDate: Date?
    weak var delegate: CalendarViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
    }
    
    func setupCalendarView() {
        //Setup calendar
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        //Setup labels
        calendarView.visibleDates { visibleDates in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        calendarView.scrollToDate(selectedDate!, animateScroll: false)
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        formatter.dateFormat = "MMMM"
        month.text = formatter.string(from: date)
    }
    
    func toggleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCalendarCell else { return }
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
        if cellState.date == selectedDate {
            validCell.selectedView.isHidden = false
        }
    }
    
    func setCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCalendarCell else { return }
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
        if cellState.date == selectedDate {
            validCell.dateLabel.textColor = UIColor.orange
        }
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM  dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate: Date
        //If we get a date passed by Analyze controller we should use that to correctly focus the calendar on that month, it should mean user was already switching dates and returning to the calendar
        if selectedDate != nil {
//            startDate = selectedDate!
            startDate = formatter.date(from: "2017 01 01")!
        } else {
            startDate = Date()
        }
        
        let endDate = formatter.date(from: "2025 12 31")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 6, calendar: Calendar.current, generateInDates: InDateCellGeneration.forAllMonths, generateOutDates: OutDateCellGeneration.tillEndOfGrid, firstDayOfWeek: DaysOfWeek.monday, hasStrictBoundaries: false)
        return parameters
    }
    
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let myCell = cell as! CustomCalendarCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCalendarCell
        
        cell.dateLabel.text = cellState.text
        toggleCellSelected(view: cell, cellState: cellState)
        setCellTextColor(view: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        toggleCellSelected(view: cell, cellState: cellState)
        setCellTextColor(view: cell, cellState: cellState)
        selectedDate = date
        delegate?.calendarViewController(self, didPickDate: selectedDate!)
        navigationController?.popViewController(animated: true)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        toggleCellSelected(view: cell, cellState: cellState)
        setCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
}
