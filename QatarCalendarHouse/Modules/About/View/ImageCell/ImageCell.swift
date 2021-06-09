//
//  ImageCell.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/2/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit
import Kingfisher

class ImageCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var imageMain: UIImageView!

    //MARK: - Properties
    
    
    //MARK: - Configuration
    
    func configure(with item: ContentItem, assetService: Asseted) {
        guard let image = item.image else { return }
        imageMain.kf.indicatorType = .activity
        imageMain.kf.setImage(with: assetService.getAssetURL(for: image))
    }
    
    //MARK: - Actions
    
    
    //MARK: - Helpers
    
}
