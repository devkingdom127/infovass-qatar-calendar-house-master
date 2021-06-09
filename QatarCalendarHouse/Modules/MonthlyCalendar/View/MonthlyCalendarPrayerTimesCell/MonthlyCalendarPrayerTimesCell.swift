//
//  MonthlyCalendarPrayerTimesCell.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/19/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class MonthlyCalendarPrayerTimesCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var labelFajer: UILabel!
    @IBOutlet weak var labelSunrise: UILabel!
    @IBOutlet weak var labelDuhur: UILabel!
    @IBOutlet weak var labelAsr: UILabel!
    @IBOutlet weak var labelMagrib: UILabel!
    @IBOutlet weak var labelIsha: UILabel!
    @IBOutlet weak var viewDivider: UIView!
    @IBOutlet var labels: [UILabel]!

    //MARK: - Properties
    
    
    //MARK: - Configuration
    
    func configure(with item: DayCalendar, rowNumber: Int) {
        self.contentView.backgroundColor = rowNumber.isMultiple(of: 2) ? R.color.primary()?.withAlphaComponent(0.05) : R.color.white()
        self.viewDivider.backgroundColor = R.color.darkGray()?.withAlphaComponent(0.05)
        self.labels.forEach {
            $0.textColor = $0.tag.isMultiple(of: 2) ? R.color.black() : R.color.primary()
            $0.font = R.font.cairoBold(size: 14)
        }
        self.labelNumber.text = "\(rowNumber)"
        self.labelFajer.text = item.fajr.toFormattedTime()
        self.labelSunrise.text = item.shrouk.toFormattedTime()
        self.labelDuhur.text = item.zuhr.toFormattedTime()
        self.labelAsr.text = item.asr.toFormattedTime()
        self.labelMagrib.text = item.maghrib.toFormattedTime()
        self.labelIsha.text = item.eshaa.toFormattedTime()
    }
    
    func configureAsHeader() {
        self.contentView.backgroundColor = R.color.primary()
        self.viewDivider.backgroundColor = R.color.white()
        self.labels.forEach {
            $0.textColor = R.color.white()
            $0.font = R.font.cairoBold(size: 13)
        }
        self.labelNumber.text = "اليوم"
        self.labelFajer.text = "الفجر"
        self.labelSunrise.text = "الشروق"
        self.labelDuhur.text = "الظهر"
        self.labelAsr.text = "العصر"
        self.labelMagrib.text = "المغرب"
        self.labelIsha.text = "العشاء"
    }
    
    //MARK: - Actions
    
    
    //MARK: - Helpers
    
    
}
