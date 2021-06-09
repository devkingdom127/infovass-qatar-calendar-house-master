//
//  AstronomiesTableDataSource.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/3/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class AstronomiesTableDataSource: NSObject, UITableViewDataSource {
    
    //MARK: - Properties
    
    var items: [Astronomy]
    
    //MARK: - Initializers
    
    init(with items: [Astronomy]) {
        self.items = items
        super.init()
    }
    
    //MARK: - DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.astronomyCell, for: indexPath) else { return UITableViewCell() }
        cell.configure(with: items[indexPath.row])
        return cell
    }

    //MARK: - Helpers
    
    
}
