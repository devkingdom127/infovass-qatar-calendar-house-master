//
//  EventCell.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/3/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var labelEvent: UILabel!

    //MARK: - Properties
    
    
    //MARK: - Configuration
    
    func configure(with item: Vacation) {
        labelEvent.text = item.title
    }
    
    //MARK: - Actions
    
    
    //MARK: - Helpers
    
    
}
