//
//  CalendarDateCell.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 5/22/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarDateCell: JTACDayCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelSecondaryDate: UILabel!
    @IBOutlet weak var viewSelected: UIView!

    //MARK: - Properties
    
    
    //MARK: - Configuration
    
    func configure(with item: CellState, isGregorian: Bool) {
        self.isHidden = item.dateBelongsTo != .thisMonth
        labelDate.text = item.text
        labelSecondaryDate.text = isGregorian ? item.date.islamicDayNumber() : item.date.gregorianDayNumber()
        labelDate.font = R.font.cairoBold(size: 15)
        labelSecondaryDate.font = R.font.cairoRegular(size: 13)
        if item.isSelected {
            viewSelected.isHidden = false
            viewSelected.backgroundColor = R.color.primary()
            labelDate.textColor = R.color.white()
            labelSecondaryDate.textColor = R.color.white()
        } else {
            viewSelected.isHidden = true
            labelDate.textColor = R.color.black()
            labelSecondaryDate.textColor = (labelSecondaryDate.text?.count ?? 0) > 2 ? R.color.primary() : R.color.gray()
        }
    }
    
    //MARK: - Actions
    
    
    //MARK: - Helpers
    
    
}
