//
//  MonthlyCalendarPhenomenaCell.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/19/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class MonthlyCalendarPhenomenaCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var labelPhenomena: UILabel!
    @IBOutlet weak var viewDivider: UIView!
    @IBOutlet var labels: [UILabel]!

    //MARK: - Properties
    
    
    //MARK: - Configuration
    
    func configure(with item: DayCalendar, rowNumber: Int, type: CalendarType) {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "dd-MM-yyyy"
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.locale = Locale(identifier: "en_US")
        outputDateFormatter.dateFormat = "MM/dd"
        if let date = inputDateFormatter.date(from: item.date) {
            self.labelNumber.text = "\(outputDateFormatter.string(from: date))"
        } else {
            self.labelNumber.text = "\(rowNumber)"
        }
        switch type {
        case .phenomena:
            self.labelPhenomena.text = item.dayPhenomena
        case .season:
            self.labelPhenomena.text = item.mawasem
        default: break
        }
        self.contentView.backgroundColor = rowNumber.isMultiple(of: 2) ? R.color.primary()?.withAlphaComponent(0.05) : R.color.white()
        self.viewDivider.backgroundColor = R.color.darkGray()?.withAlphaComponent(0.05)
        self.labels.forEach { $0.textColor = R.color.black() }
    }
    
    func configureAsHeader(with type: CalendarType) {
        self.labelNumber.text = "اليوم"
        switch type {
        case .phenomena:
            self.labelPhenomena.text = "الظواهر الفلكية"
        case .season:
            self.labelPhenomena.text = "المواسم"
        default: break
        }
        self.contentView.backgroundColor = R.color.primary()
        self.viewDivider.backgroundColor = R.color.white()
        self.labels.forEach { $0.textColor = R.color.white() }
    }
    
    //MARK: - Actions
    
    
    //MARK: - Helpers
    
    
}
