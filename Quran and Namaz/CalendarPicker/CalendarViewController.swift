//
//  CalendarViewController.swift
//  Quran and Namaz
//
//  Created by Anas khurshid on 02/03/2021.
//  Copyright © 2021 Anas khurshid. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    let df : DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()
    let islamic:NSCalendar = {
        let islamicCalendar  = NSCalendar(identifier: NSCalendar.Identifier.islamic)
        return islamicCalendar!
    }()
    
    @IBOutlet var calendarView: JTAppleCalendarView!
    @IBOutlet var islamicDate: UILabel!
    @IBOutlet var year: UILabel!
    @IBOutlet var month: UILabel!
    
    
    let outsideMonthColor = UIColor(colorWithHexValue: 0x584a66)
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor(colorWithHexValue: 0x3a294b)
    let currentDateSelectedViewColor = UIColor(colorWithHexValue: 0x4e3f5d)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
        
    }
    func setupCalendarView() {
        calendarView.scrollDirection = .vertical
        calendarView.scrollingMode   = .stopAtEachCalendarFrame
        calendarView.showsHorizontalScrollIndicator = false
        
        calendarView.visibleDates { visibleDates in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? DateCell  else { return }
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
            validCell.dateSubLabel.textColor = selectedMonthColor
            
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
                validCell.dateSubLabel.textColor = monthColor
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
                validCell.dateSubLabel.textColor = outsideMonthColor
            }
        }
    }
    
    func handleCellTextSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? DateCell  else { return }
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
            validCell.selectedSubView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
            validCell.selectedSubView.isHidden = true
        }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        
        let date = visibleDates.monthDates.first!.date
        //        let dateFormatter = DateFormatter()
        
        df.dateFormat = "YYYY"
        
        year.text = df.string(from: date)
        
        df.dateFormat = "MMMM"
        
        month.text = df.string(from: date)
    }
    
    func getIslamicDateComponents(date: Date) -> DateComponents {
        //        let dateFormatter = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        let georgianDate = date
        
        
        let components = islamic.components(NSCalendar.Unit(rawValue: UInt.max), from: georgianDate)
        
        return components
    }
    
    func getIslamicFullString(components: DateComponents) -> String {
        let dateString = String(format: "%02d-%02d-%04d", components.day!, components.month!, components.year!)
        return dateString
    }
    
    func getIslamicDayString(components: DateComponents) -> String {
        let dateString = String(format: "%02d", components.day!)
        return dateString
    }
    
    
}

extension CalendarViewController: JTAppleCalendarViewDataSource { 
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        //        let formatter = DateFormatter()
        df.dateFormat = "yyyy MM dd"
        
        let startDate = df.date(from: "2021 01 01")!
        let endDate = Date()
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let dateComponents = getIslamicDateComponents(date: date)
        let islamicDay = getIslamicDayString(components: dateComponents)
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        cell.dateLabel.text = cellState.text
        cell.dateSubLabel.text = islamicDay
        
        handleCellTextSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellTextSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        let dateComponents = getIslamicDateComponents(date: date)
        let fullIslamicDate = getIslamicFullString(components: dateComponents)
        
        islamicDate.text = fullIslamicDate
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
        
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellTextSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0) {
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
