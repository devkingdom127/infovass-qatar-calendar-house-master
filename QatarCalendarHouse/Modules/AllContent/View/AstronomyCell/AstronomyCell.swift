//
//  AstronomyCell.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/3/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class AstronomyCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var viewBullet: UIView!
    @IBOutlet weak var buttonDownload: UIButton!

    //MARK: - Properties
    
    
    //MARK: - Life cycle
    
    override func awakeFromNib() {
        viewBullet.shape = .circular
    }
    
    //MARK: - Configuration
    
    func configure(with item: Astronomy) {
        labelDescription.text = item.definition
        buttonDownload.isEnabled = item.file != nil
        buttonDownload.addTargetClosure { _ in
            guard let file = item.file, let url = URL(string: file, relativeTo: QCH.asset.assetURL) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    //MARK: - Actions
    
    
    //MARK: - Helpers
    
    
}
