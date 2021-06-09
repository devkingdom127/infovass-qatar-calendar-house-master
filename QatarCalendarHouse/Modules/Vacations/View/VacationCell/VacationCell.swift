//
//  VacationCell.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/26/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class VacationCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var labelVacation: UILabel!
    @IBOutlet weak var viewDot: UIView!

    //MARK: - Properties
    
    
    //MARK: - Configuration
    
    func configure(with item: Vacation) {
        labelVacation.text = "\(item.title) (\(item.date.toDate()?.gregorianDateFormatted().toEnglishNumbers().split(separator: "-").joined(separator: " ") ?? item.date))"
        viewDot.shape = .circular
        viewDot.backgroundColor = R.color.primary()
    }
    
    //MARK: - Actions
    
    
    //MARK: - Helpers
    
    
}
