//
//  RamadanPrayersTimeCell.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/25/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class RamadanPrayersTimeCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var labelWeekDay: UILabel!
    @IBOutlet weak var labelFajer: UILabel!
    @IBOutlet weak var labelSunrise: UILabel!
    @IBOutlet weak var labelDuhur: UILabel!
    @IBOutlet weak var labelAsr: UILabel!
    @IBOutlet weak var labelMagrib: UILabel!
    @IBOutlet weak var labelIsha: UILabel!
    @IBOutlet weak var labelRamadanDayNumber: UILabel!
    @IBOutlet weak var labelGregorianDate: UILabel!
    @IBOutlet weak var labelLastThird: UILabel!
    @IBOutlet var labels: [UILabel]!

    //MARK: - Properties
    
    
    //MARK: - Configuration
    
    func configure(with item: DayCalendar, rowNumber: Int) {
        self.contentView.backgroundColor = rowNumber.isMultiple(of: 2) ? R.color.white() : R.color.primary()?.withAlphaComponent(0.05)
        self.labels.forEach {
            $0.textColor = $0.tag.isMultiple(of: 2) ? R.color.black() : R.color.primary()
            $0.font = R.font.cairoBold(size: 12)
            $0.numberOfLines = 1
        }
        self.labelWeekDay.text = item.date.toDate()?.arabicDayNameFormatted()
        self.labelFajer.text = item.fajr.toFormattedTime(twelveFormat: false)
        self.labelSunrise.text = item.shrouk.toFormattedTime(twelveFormat: false)
        self.labelDuhur.text = item.zuhr.toFormattedTime(twelveFormat: false)
        self.labelAsr.text = item.asr.toFormattedTime(twelveFormat: false)
        self.labelMagrib.text = item.maghrib.toFormattedTime(twelveFormat: false)
        self.labelIsha.text = item.eshaa.toFormattedTime(twelveFormat: false)
        self.labelLastThird.text = item.lastThird?.toFormattedTime(twelveFormat: false)
        self.labelRamadanDayNumber.text = item.hijriDay?.toEnglishNumbers()
        self.labelGregorianDate.text = item.date.toDate()?.gregorianDayAndMonthDateFormatted()
    }
    
//    func configureAsHeader() {
//        self.contentView.backgroundColor = R.color.gray()
//        self.labels.forEach {
//            $0.textColor = R.color.black()
//            $0.font = R.font.cairoBold(size: 10)
//        }
//        labelLastThird.font = R.font.cairoBold(size: 9)
//        labelLastThird.numberOfLines = 2
//        self.labelWeekDay.text = "اليوم"
//        self.labelFajer.text = "الفجر"
//        self.labelSunrise.text = "الشروق"
//        self.labelDuhur.text = "الظهر"
//        self.labelAsr.text = "العصر"
//        self.labelMagrib.text = "المغرب"
//        self.labelIsha.text = "العشاء"
//        self.labelRamadanDayNumber.text = "رمضان"
//        self.labelLastThird.text = "الثلث الأخير"
//        self.labelGregorianDate.text = "ميلادي"
//    }
    
    //MARK: - Actions
    
    
    //MARK: - Helpers
    
    
}
