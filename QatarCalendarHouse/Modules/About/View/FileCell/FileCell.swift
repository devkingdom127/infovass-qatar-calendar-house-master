//
//  FileCell.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/2/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class FileCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var buttonDownloadFile: UIButton!

    //MARK: - Properties
    
    
    //MARK: - Life cycle
    
    override func awakeFromNib() {
        
    }
    
    //MARK: - Configuration
    
    func configure(with item: ContentItem, assetService: Asseted) {
        guard let file = item.file else { return }
        buttonDownloadFile.isEnabled = item.file != ""
        buttonDownloadFile.tintColor = R.color.primary()
        buttonDownloadFile.setImage(R.image.download()?.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonDownloadFile.addTargetClosure { _ in
            let url = assetService.getAssetURL(for: file)
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    //MARK: - Actions
    
    
    //MARK: - Helpers
    
    
}
