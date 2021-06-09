//
//  CalendarVC.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/3/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit
import JTAppleCalendar
import PromiseKit

class CalendarVC: UIViewController, Storyboarded {
    
    //MARK: - Outlets
    
    @IBOutlet weak var segmentedControl: ADVSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var labelCurrentMonth: UILabel!
    
    //MARK: - Properties
    
    private let model = CalendarModel()
    private var tableDataSource: EventsTableDataSource!
    private var tableDelegate: EventsTableDelegate!
    private var calendar = Calendar.init(identifier: .islamicUmmAlQura)
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.lastDayCalendarAvailablePromise?.done { [weak self] in
            self?.model.lastDayCalendarAvailable = $0
            self?.calendarView.calendarDataSource = self
            self?.calendarView.calendarDelegate = self
            self?.setupCalendar()
        }
        self.calendarView.superview?.semanticContentAttribute = .forceRightToLeft
        setupSegmentedControl()
        requestVacations(for: Date())
        setupMonthTitle()
    }
    
    //MARK: - Actions

    @IBAction func onNextMonthButtonPressed(_ sender: Any) {
        calendarView.scrollToSegment(.next)
    }
    
    @IBAction func onPreviousMonthButtonPressed(_ sender: Any) {
        calendarView.scrollToSegment(.previous)
    }
    
    @IBAction func onCloseButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSegmentedControlValueChanged(_ sender: Any) {
        calendar = segmentedControl.selectedItem == "التقويم الهجري" ? Calendar.init(identifier: .islamicUmmAlQura) : Calendar.init(identifier: .gregorian)
        calendarView.reloadData()
        setupMonthTitle()
        calendarView.scrollToDate(Date())
        calendarView.selectDates([Date()])
    }

    //MARK: - Helpers
    
    private func setupSegmentedControl() {
        self.segmentedControl.items = ["التقويم الهجري", "التقويم الميلادي"].reversed()
        self.segmentedControl.font = R.font.cairoBold(size: 15)
        self.segmentedControl.selectedIndex = segmentedControl.items.endIndex - 1
        self.segmentedControl.addTarget(self, action: #selector(onSegmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    private func setupMonthTitle() {
        let formatter = DateFormatter()
        formatter.locale = segmentedControl.selectedItem == "التقويم الهجري" ? Locale(identifier: "ar_sa") : Locale(identifier: "ar_eg")
        formatter.dateFormat = "MMMM yyyy"
        labelCurrentMonth.text = formatter.string(from: calendarView.visibleDates().monthDates.first?.date ?? Date()).toEnglishNumbers()
    }

    private func setupCalendar() {
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.scrollDirection = .horizontal
        calendarView.showsHorizontalScrollIndicator = false
        calendarView.scrollToDate(Date())
        calendarView.selectDates([Date()])
        calendarView.semanticContentAttribute = .forceRightToLeft
    }
    
    private func setupTableView(with item: [Vacation], tableView: UITableView) {
        tableDataSource = EventsTableDataSource(with: item)
        tableDelegate = EventsTableDelegate()
        tableView.delegate = tableDelegate
        tableView.dataSource = tableDataSource
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.separatorStyle = .none
        tableView.register(R.nib.eventCell)
        tableView.reloadData()
    }
    
    private func requestVacations(for date: Date) {
        firstly {
            self.model.requestVacations(for: date)
        }.done { [weak self] in
            guard let `self` = self else { return }
            self.setupTableView(with: $0, tableView: self.tableView)
        }.catch {
            self.stopLoading(withErrorMessage: $0.localizedDescription)
        }
    }

}

extension CalendarVC: JTACMonthViewDataSource, JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarDateCell else { return }
        cell.configure(with: cellState, isGregorian: segmentedControl.selectedItem != "التقويم الهجري")
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as? CalendarDateCell else { return JTACDayCell() }
        cell.configure(with: cellState, isGregorian: segmentedControl.selectedItem != "التقويم الهجري")
        return cell
    }
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        let endDate: Date
        if let lastDayCalendarDate = model.lastDayCalendarAvailable?.date.toDate() {
            endDate = lastDayCalendarDate
        } else {
            endDate = Calendar.current.date(byAdding: .year, value: 8, to: Date()) ?? Date()
        }
        return ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 6, calendar: self.calendar, firstDayOfWeek: .sunday)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarDateCell else { return }
        cell.configure(with: cellState, isGregorian: segmentedControl.selectedItem != "التقويم الهجري")
        requestVacations(for: date)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarDateCell else { return }
        cell.configure(with: cellState, isGregorian: segmentedControl.selectedItem != "التقويم الهجري")
    }
    
    func calendarDidScroll(_ calendar: JTACMonthView) {
        setupMonthTitle()
    }
}
