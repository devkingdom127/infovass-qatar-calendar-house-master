//
//  ContentTableDataSource.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/2/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class ContentTableDataSource: NSObject, UITableViewDataSource {
    
    //MARK: - Properties
    
    var item: ContentItem
    var assetService: Asseted
    
    //MARK: - Initializers
    
    init(with item: ContentItem, assetService: Asseted) {
        self.item = item
        self.assetService = assetService
        super.init()
    }
    
    //MARK: - DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if let image = item.image, image != "" && section == 0 { return 1 }
        if let description = item.description, description != "" && section == 1 { return 1 }
        if let file = item.file, file != "" && section == 2 { return 1 }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let image = item.image, image != "" && indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.imageCell, for: indexPath) else { return UITableViewCell() }
            cell.configure(with: item, assetService: assetService)
            return cell
        } else if let description = item.description, description != "" && indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.textCell, for: indexPath) else { return UITableViewCell() }
            cell.configure(with: item)
            return cell
        } else if let file = item.file, file != "" && indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.fileCell, for: indexPath) else { return UITableViewCell() }
            cell.configure(with: item, assetService: assetService)
            return cell
        } else {
            return UITableViewCell()
        }
    }

    //MARK: - Helpers
    
    
}
