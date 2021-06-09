//
//  BorgAndTalaCell.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/20/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class BorgAndTalaCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var labelBorgName: UILabel!
    @IBOutlet weak var labelBorgNumber: UILabel!
    @IBOutlet weak var labelTalaName: UILabel!
    @IBOutlet weak var labelTalaNumber: UILabel!
    @IBOutlet weak var labelSuhailNumber: UILabel!

    //MARK: - Properties
    
    var delegate: BorgAndTalaCellDelegate?
    var calendar: DayCalendar?
    
    //MARK: - Configuration
    
    func configure(with item: DayCalendar, delegate: BorgAndTalaCellDelegate) {
        self.calendar = item
        self.delegate = delegate
        labelBorgName.text = item.borgName
        labelBorgNumber.text = item.borgNum
        labelTalaName.text = item.talaName
        labelTalaNumber.text = item.talaNum
        labelSuhailNumber.text = item.suhail
    }
    
    //MARK: - Actions
    
    @IBAction func onBorgBtnPressed(_ sender: Any) {
        guard let calendar = calendar, let name = calendar.borgName else { return }
        delegate?.openBorg(named: name)
    }
    
    @IBAction func onTalaBtnPressed(_ sender: Any) {
        guard let calendar = calendar, let name = calendar.talaName else { return }
        delegate?.openTala(named: name)
    }
    
    @IBAction func onSuhailBtnPressed(_ sender: Any) {
        delegate?.openSuhail()
    }
    
    //MARK: - Helpers
    
    
}

protocol BorgAndTalaCellDelegate {
    func openBorg(named: String)
    func openTala(named: String)
    func openSuhail()
}
