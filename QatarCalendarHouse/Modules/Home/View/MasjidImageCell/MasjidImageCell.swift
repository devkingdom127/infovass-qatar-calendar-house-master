//
//  MasjidImageCell.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/20/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class MasjidImageCell: UITableViewCell {

    //MARK: - Outlets
    

    //MARK: - Properties
    var delegate: MasjidImageCellDelegate?

    
    //MARK: - Configuration
    func configure(delegate: MasjidImageCellDelegate) {
        self.delegate = delegate
    }
    
    //MARK: - Actions
    
    
    //MARK: - Helpers
    
    @IBAction func onPreviousBtnPressed(_ sender: Any) {
        delegate?.previousPressed()
    }
    
    @IBAction func onNextBtnPressed(_ sender: Any) {
        delegate?.nextPressed()
    }
}

protocol MasjidImageCellDelegate {
    func previousPressed()
    func nextPressed()
}
