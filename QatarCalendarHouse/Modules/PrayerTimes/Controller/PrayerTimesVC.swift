//
//  PrayerTimesVC.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/28/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit
import PromiseKit

class PrayerTimesVC: UIViewController, Storyboarded {
    
    //MARK: - Outlets
    
    @IBOutlet weak var fieldCapital: UITextField!
    @IBOutlet weak var labelDayName: UILabel!
    @IBOutlet weak var pageControlNumberOfDays: UIPageControl!
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var labelFajr: UILabel!
    @IBOutlet weak var labelSunrise: UILabel!
    @IBOutlet weak var labelDuhur: UILabel!
    @IBOutlet weak var labelAsr: UILabel!
    @IBOutlet weak var labelMagrib: UILabel!
    @IBOutlet weak var labelIsha: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet var stackPrayerTimes: [UIStackView]!
    
    lazy var pickerViewCapitals: UIPickerView = {
       let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    //MARK: - Properties
    
    let model = PrayerTimesModel()
    var selectedDate: DayCalendar? {
        didSet {
            self.labelDayName.isHidden = self.selectedDate == nil
            self.labelDate.isHidden = self.selectedDate == nil
            self.stackPrayerTimes.forEach { $0.isHidden = self.selectedDate == nil }

            guard let selectedDate = self.selectedDate else { return }

            self.labelDayName.text = selectedDate.date.toDate()?.arabicDayNameFormatted()
            self.labelDate.text = "\(selectedDate.date.toDate()?.hijriDateFormatted().split(separator: "-").joined(separator: " ").toEnglishNumbers() ?? selectedDate.date) | \(selectedDate.date.toDate()?.gregorianDateFormatted().split(separator: "-").joined(separator: " ").toEnglishNumbers() ?? selectedDate.hijriDate ?? "")"
            self.labelFajr.text = selectedDate.fajr.toFormattedTime()
            self.labelSunrise.text = selectedDate.shrouk.toFormattedTime()
            self.labelDuhur.text = selectedDate.zuhr.toFormattedTime()
            self.labelAsr.text = selectedDate.asr.toFormattedTime()
            self.labelMagrib.text = selectedDate.maghrib.toFormattedTime()
            self.labelIsha.text = selectedDate.eshaa.toFormattedTime()
        }
    }
    var selectedCapital: CapitalType? {
        didSet {
            dates = []
            fetchPrayerTimes()
            self.fieldCapital.text = self.selectedCapital?.rawValue
        }
    }
    var dates = [DayCalendar]() {
        didSet {
            self.buttonNext.isEnabled = !self.dates.isEmpty
            self.buttonPrevious.isEnabled = !self.dates.isEmpty
            self.pageControlNumberOfDays.numberOfPages = self.dates.count
            self.selectedDate = self.dates.first
        }
    }
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFieldCapitals()
        selectedCapital = .doha

    }
    
    //MARK: - Actions
    
    @IBAction func onNextButtonPressed(_ sender: Any) {
        let newIndex = pageControlNumberOfDays.currentPage + 1
        guard let item = dates[safeIndex: newIndex] else { return }
        self.selectedDate = item
        self.pageControlNumberOfDays.currentPage = newIndex
    }
    
    @IBAction func onPreviousButtonPressed(_ sender: Any) {
        let newIndex = pageControlNumberOfDays.currentPage - 1
        guard let item = dates[safeIndex: newIndex] else { return }
        self.selectedDate = item
        self.pageControlNumberOfDays.currentPage = newIndex
    }
    
    @IBAction func onChooseCapitalButtonPressed(_ sender: Any) {
        self.fieldCapital.becomeFirstResponder()
    }
    
    @IBAction func onCloseButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helpers

    private func setupFieldCapitals() {
        self.fieldCapital.inputView = pickerViewCapitals
    }
    
    private func fetchPrayerTimes() {
        guard let capital = selectedCapital else { return }
        self.startLoading(shouldFreeze: false)
        firstly {
            model.requestPrayerTimes(for: capital)
        }.done { [weak self] in
            self?.dates = $0
        }.ensure { [weak self] in
            self?.startLoading()
        }.catch { [weak self] in
            self?.stopLoading(withErrorMessage: $0.localizedDescription)
        }
    }
    
}

extension PrayerTimesVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CapitalType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CapitalType.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCapital = CapitalType.allCases[row]
    }
}
