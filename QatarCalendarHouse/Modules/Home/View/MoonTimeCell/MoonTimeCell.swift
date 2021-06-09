//
//  MoonTimeCell.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 5/5/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class MoonTimeCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var labelSunrise: UILabel!
    @IBOutlet weak var labelSunset: UILabel!

    //MARK: - Properties
    
    
    //MARK: - Configuration
    
    func configure(with item: DayCalendar) {
        labelSunset.text = item.ghoroubTime?.replacingOccurrences(of: "AM", with: " AM").replacingOccurrences(of: "PM", with: " PM")
        labelSunrise.text = item.shoroukTime?.replacingOccurrences(of: "AM", with: " AM").replacingOccurrences(of: "PM", with: " PM")
    }
    
    //MARK: - Actions
    
    
    //MARK: - Helpers
    
    
}
