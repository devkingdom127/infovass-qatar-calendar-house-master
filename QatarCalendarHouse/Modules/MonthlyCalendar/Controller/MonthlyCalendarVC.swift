//
//  MonthlyCalendarVC.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/16/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit
import PromiseKit

class MonthlyCalendarVC: UIViewController, Storyboarded {
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var fieldMonth: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var phenomenaHeaderView: UIView!
    @IBOutlet weak var prayerTimesHeaderView: UIView!
    @IBOutlet weak var labelPhenomena: UILabel!

    //MARK: - Properties
    
    internal var type: CalendarType = .prayerTimes
    internal var date: Date = Date()
    private var tableDelegate = MonthlyCalendarTableDelegate()
    private var tableDataSource: MonthlyCalendarTableDataSource!
    private lazy var model = MonthlyCalendarModel(date: date)
    lazy var monthPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    private var selectedMonth: String? {
        didSet {
            guard let selectedMonth = selectedMonth else { return }
            self.fieldMonth.text = selectedMonth
            self.setupTableView(for: calendars[selectedMonth] ?? [])
        }
    }
    private var calendars: [String: [DayCalendar]] = [:] {
        didSet {
            selectedMonth = fieldMonth.text?.isEmpty ?? true ? model.currentMonth : fieldMonth.text
            self.monthPicker.reloadAllComponents()
        }
    }
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        startLoading(shouldFreeze: false)
        firstly {
            model.requestMonthlyCalendar(date: date)
        }.done { [weak self] in
            self?.calendars = $0
        }.ensure { [weak self] in
            self?.stopLoading()
        }.catch { [weak self] in
            self?.stopLoading(withErrorMessage: $0.localizedDescription)
        }

    }
    
    //MARK: - Actions
    
    @IBAction func onCloseButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    //MARK: - Helpers

    private func setup() {
        fieldMonth.inputView = monthPicker
        labelTitle.text = type.title(date: date)
    }

    private func setupTableView(for items: [DayCalendar]) {
        tableDataSource = MonthlyCalendarTableDataSource(calendars: items, type: type)
        tableView.delegate = tableDelegate
        tableView.dataSource = tableDataSource
        
        if type == .prayerTimes {
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 600
            phenomenaHeaderView.isHidden = true
        } else {
            tableView.rowHeight = 75
            labelPhenomena.text = type == .phenomena ? "الظواهر الفلكية" : "المواسم"
            prayerTimesHeaderView.isHidden = true
        }
        tableView.separatorStyle = .none
        tableView.register(R.nib.monthlyCalendarPhenomenaCell)
        tableView.register(R.nib.monthlyCalendarPrayerTimesCell)
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }

}

extension MonthlyCalendarVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedMonth = model.nameOfYearMonths[row]
    }
}

extension MonthlyCalendarVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return model.nameOfYearMonths.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return model.nameOfYearMonths[row]
    }
}
