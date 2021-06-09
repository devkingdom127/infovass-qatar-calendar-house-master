//
//  BorgAndTalaTableDataSource.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/29/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class BorgAndTalaTableDataSource: NSObject, UITableViewDataSource {
    
    //MARK: - Properties
    
    var items: [Astrological]
    
    //MARK: - Initializers
    
    init(with items: [Astrological]) {
        self.items = items
        super.init()
    }
    
    //MARK: - DataSource
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.astrologicalCell, for: indexPath) else {
            return UITableViewCell()
        }
        cell.configure(with: items[indexPath.row], rowNumber: indexPath.row + 1)
        return cell
    }

    //MARK: - Helpers
    
    
}
