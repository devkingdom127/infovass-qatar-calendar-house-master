//
//  SideMenuCell.swift
//  OffaratMasr
//
//  Created by Amr Salman on 12/31/19.
//  Copyright © 2019 Infovass. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var stackContent: UIStackView!

    //MARK: - Properties
    
    
    //MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //MARK: - Configuration
    
    func configure(with item: SideMenuItem) {
        imageIcon.image = item.icon.withRenderingMode(.alwaysTemplate)
        labelTitle.text = item.title
        accessoryType = item.isAccessable ? .disclosureIndicator : .none
        if UIScreen.main.bounds.width < 350 { labelTitle.numberOfLines = 2 }
        else { labelTitle.numberOfLines = 1 }
    }
    
    
    //MARK: - Actions
    
    
    //MARK: - Helpers
    
    
}
