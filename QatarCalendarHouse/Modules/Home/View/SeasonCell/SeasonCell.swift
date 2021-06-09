//
//  SeasonCell.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/21/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class SeasonCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var labelSeason: UILabel!
    @IBOutlet weak var labelSeasonLine: UILabel!

    //MARK: - Properties
    
    
    //MARK: - Configuration
    
    func configure(with item: DayCalendar) {
        labelSeasonLine.text = "مواسم"
        labelSeason.text = item.mawasem
    }
    
    //MARK: - Actions
    
    
    //MARK: - Helpers
    
    
}
