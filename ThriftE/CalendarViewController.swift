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
    var selectedDate = Date()
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
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM  dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2019 01 01")!
        let endDate = formatter.date(from: "2025 12 31")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
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
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        toggleCellSelected(view: cell, cellState: cellState)
        selectedDate = date
        delegate?.calendarViewController(self, didPickDate: selectedDate)
        navigationController?.popViewController(animated: true)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        toggleCellSelected(view: cell, cellState: cellState)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
}



