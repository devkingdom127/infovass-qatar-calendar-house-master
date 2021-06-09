//
//  DayContentCell.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/21/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class DayContentCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var labelContentLine: UILabel!
    @IBOutlet weak var labelMore: UILabel!

    //MARK: - Properties
    
    
    //MARK: - Configuration
    
    func configure(with item: DayCalendar) {
        labelContent.text = item.dayContent
        labelContentLine.text = "محتوى اليوم"
        labelMore.isHidden = !labelContent.isTruncated()
    }
    
    //MARK: - Actions
    
    
    //MARK: - Helpers
    
}
