//
//  AstrologicalCell.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/1/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class AstrologicalCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelNumberOfDays: UILabel!
    @IBOutlet weak var labelStartDate: UILabel!
    @IBOutlet weak var labelSuhail: UILabel!
    @IBOutlet var labels: [UILabel]!

    //MARK: - Properties
    
    var item: Astrological?
    
    //MARK: - Configuration
    
    func configure(with item: Astrological, rowNumber: Int) {
        self.contentView.backgroundColor = rowNumber.isMultiple(of: 2) ? R.color.primary()?.withAlphaComponent(0.05) : .clear
        self.labels.forEach {
            $0.textColor = R.color.black()
            $0.font = R.font.cairoSemiBold(size: 13)
            $0.numberOfLines = 1
        }
        self.item = item
        self.labelNumber.text = "\(rowNumber)"
        self.labelName.text = item.name
        self.labelNumberOfDays.text = item.numOfDays
        self.labelStartDate.text = item.start
        self.labelSuhail.text = item.sahil
    }
    
    func configureAsHeader(isBorg: Bool) {
        self.labels.forEach {
            $0.textColor = R.color.primary()
            $0.font = R.font.cairoSemiBold(size: 11)
        }
        self.labelNumber.text = "الرقم"
        self.labelName.text = isBorg ? "اسم البرج" : "اسم الطالع"
        self.labelNumberOfDays.text = "عدد ايامه"
        self.labelStartDate.text = "يوافق ميلادياً"
        self.labelSuhail.text = "موافقته لسهيل"
        if UIScreen.main.bounds.size.width < 350 {
            self.labelSuhail.numberOfLines = 2
        }
        self.contentView.backgroundColor = R.color.gray()
    }
    
    //MARK: - Actions
    
    
    //MARK: - Helpers
    
    
}
