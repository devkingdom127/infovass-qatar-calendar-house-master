//
//  TextCell.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/2/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var labelText: UILabel!

    //MARK: - Properties
    
    
    //MARK: - Configuration
    
    func configure(with item: ContentItem) {
        self.labelText.text = item.description
    }
    
    //MARK: - Actions
    
    
    //MARK: - Helpers
    
    
}
