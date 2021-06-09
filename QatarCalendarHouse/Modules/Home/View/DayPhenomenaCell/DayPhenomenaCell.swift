//
//  DayPhenomenaCell.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/21/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class DayPhenomenaCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var labelPhenomena: UILabel!
    @IBOutlet weak var labelPhenomenaLine: UILabel!

    //MARK: - Properties
    
    
    //MARK: - Configuration
    
    func configure(with item: DayCalendar) {
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        format.locale = Locale(identifier: "en")
        let formattedDate = format.string(from: item.date.toDate() ?? Date())
        
        labelPhenomenaLine.text = "الظواهر الفلكية خلال عام \(formattedDate)م"
//        labelPhenomena.text = item.dayPhenomena
        labelPhenomena?.removeFromSuperview()
    }
    
    //MARK: - Actions
    
    
    //MARK: - Helpers
    
    
}
