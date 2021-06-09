//
//  AlarmCell.swift
//  QatarCalendarHouse
//
//  Created by Moahmmed Sami on 24/12/2020.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit
import ReadMoreTextView

class AlarmCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleTextView: ReadMoreTextView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleTextView.onSizeChange = { _ in }
        titleTextView.shouldTrim = true
    }
}
