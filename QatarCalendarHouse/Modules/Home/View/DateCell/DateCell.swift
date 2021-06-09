//
//  DateCell.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/10/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var labelDayHijri: UILabel!
    @IBOutlet weak var labelMonthHijri: UILabel!
    @IBOutlet weak var labelYearHijri: UILabel!
    @IBOutlet weak var labelDayGregorian: UILabel!
    @IBOutlet weak var labelMonthGregorian: UILabel!
    @IBOutlet weak var labelYearGregorian: UILabel!
    @IBOutlet weak var labelDayOfWeek: UILabel!
    @IBOutlet weak var imageLogo: UIImageView!

    //MARK: - Properties
    
    var delegate: DateCellDelegate?
    lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(onLogoImageTapped(_:)))
        return gesture
    }()
    
    //MARK: - Life cycle
    
    override func awakeFromNib() {
        imageLogo.isUserInteractionEnabled = true
        imageLogo.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Configuration
    
    func configure(with item: DayCalendar, delegate: DateCellDelegate) {
        self.delegate = delegate
        attributedString(for: .hijri, with: item)
        attributedString(for: .gregorian, with: item)
        labelDayOfWeek.text = item.date.toDate()?.arabicDayNameFormatted()
    }
    
    //MARK: - Actions
        
    @objc func onLogoImageTapped(_ sender: Any) {
        delegate?.didPressLogo()
    }
    
    //MARK: - Helpers
    
    func attributedString(for type: DateType, with calendar: DayCalendar) {
        let formattedDate =
            type == .hijri ? calendar.date.toDate()?.hijriDateFormatted().toEnglishNumbers().split(separator: "-")
                : calendar.date.toDate()?.gregorianDateFormatted().toEnglishNumbers().split(separator: "-")
        switch type {
        case .hijri:
            labelDayHijri.text = String(formattedDate?.first ?? "")
            labelMonthHijri.text = String(formattedDate?[1] ?? "")
            labelYearHijri.text = String(formattedDate?.last ?? "").replacingOccurrences(of: "هـ", with: "")
        case .gregorian:
            labelDayGregorian.text = String(formattedDate?.first ?? "")
            labelMonthGregorian.text = String(formattedDate?[1] ?? "")
            labelYearGregorian.text = String(formattedDate?.last ?? "").replacingOccurrences(of: "م", with: "")
        }
    }
}

enum DateType {
    case hijri
    case gregorian
}

protocol DateCellDelegate {
    func didPressLogo()
}
